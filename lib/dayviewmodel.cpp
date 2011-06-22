/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "dayviewmodel.h"
#include "calendardataitem.h"
#include <inttypes.h>
#include <utilmethods.h>
#include "incidenceio.h"
#include <QMultiHash>
#include <math.h>

DayViewModel::DayViewModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;

    roles.insert(CalendarDataItem::Index,"index");
    roles.insert(CalendarDataItem::Type, "type");
    roles.insert(CalendarDataItem::Uid,"uid");
    roles.insert(CalendarDataItem::Description,"description");
    roles.insert(CalendarDataItem::Summary,"summary");
    roles.insert(CalendarDataItem::Location,"location");
    roles.insert(CalendarDataItem::AllDay,"allDay");
    roles.insert(CalendarDataItem::RepeatType,"repeatType");
    roles.insert(CalendarDataItem::RepeatEndType,"repeatEndType");
    roles.insert(CalendarDataItem::RepeatCount,"repeatCount");
    roles.insert(CalendarDataItem::StartDate,"startDate");
    roles.insert(CalendarDataItem::StartTime,"startTime");
    roles.insert(CalendarDataItem::EndDate,"endDate");
    roles.insert(CalendarDataItem::EndTime,"endTime");
    roles.insert(CalendarDataItem::RepeatEndDate,"repeatEndDate");
    roles.insert(CalendarDataItem::RepeatEndTime,"repeatEndTime");
    roles.insert(CalendarDataItem::AlarmType,"alarmType");
    roles.insert(CalendarDataItem::AlarmDate,"alarmDate");
    roles.insert(CalendarDataItem::AlarmTime,"alarmTime");
    roles.insert(CalendarDataItem::ZoneOffset,"zoneOffset");
    roles.insert(CalendarDataItem::ZoneName,"zoneName");
    roles.insert(CalendarDataItem::XUnits,"xUnits");
    roles.insert(CalendarDataItem::YUnits,"yUnits");
    roles.insert(CalendarDataItem::HeightUnits,"heightUnits");
    roles.insert(CalendarDataItem::WidthUnits,"widthUnits");
    roles.insert(CalendarDataItem::StartIndex,"startIndex");

    setRoleNames(roles);
}


DayViewModel::~DayViewModel()
{
    clearData();
}

void DayViewModel::loadCurrentDayValues()
{
    CalendarController controller;
    QList<IncidenceIO*> list = controller.getEventsFromDB(EDayList,KDateTime(dateVal));
    beginResetModel();
    clearData();
    int eventsCount=0;
    if(modelType == UtilMethods::EAllEvents ) {
        foreach(IncidenceIO *ioObject, list) {
            if(ioObject->isAllDay()) {
                itemsList << new CalendarDataItem(eventsCount,ioObject);
                ++eventsCount;
            }
        }
        foreach(IncidenceIO *ioObject, list) {
            if(!ioObject->isAllDay()) {
                itemsList << new CalendarDataItem(eventsCount,ioObject);
                ++eventsCount;
            }
        }
    } else {
        foreach(IncidenceIO *ioObject, list) {
            if((modelType == UtilMethods::EAllDay) && (ioObject->isAllDay())) {
                itemsList << new CalendarDataItem(eventsCount,ioObject);
                ioObject->printIncidence();
                ++eventsCount;
            } else if((modelType == UtilMethods::ENotAllDay) && (!ioObject->isAllDay())) {
                itemsList << new CalendarDataItem(eventsCount,ioObject);
                ioObject->printIncidence();
                ++eventsCount;
            }
        }
        assignDisplayValues();
    }
    endResetModel();
}

void DayViewModel::loadGivenDayModel(QDate nextDate)
{
    dateVal = nextDate;
    loadCurrentDayValues();
}

void DayViewModel::assignDisplayValues()
{
    int count = itemsList.count();

    if(count == 0)
        return;

    QMultiHash<int,int> hashmap;

    //Counting how many items start at an index
    for(int i=0;i<count;i++)
    {
        int index = 0,itemCount=0;

        CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
        index = computeStartIndex(calItem->startTime);
        ((CalendarDataItem*)(itemsList.at(i)))->startIndex = index;
        ((CalendarDataItem*)(itemsList.at(i)))->xUnits = 0;
        ((CalendarDataItem*)(itemsList.at(i)))->yUnits = 0;
        ((CalendarDataItem*)(itemsList.at(i)))->widthUnits = 1.0;
        double htVal = (calItem->startTime.secsTo(calItem->endTime) / (60.0*30.0));
        if(htVal<0.5) {
            htVal = 0.5;
        }
        htVal = round(htVal);
        ((CalendarDataItem*)(itemsList.at(i)))->heightUnits = htVal;

        for(int j=0;j<calItem->heightUnits;j++) {
            if(hashmap.count(index+j) == 0) {
                itemCount = 1;
            } else {
                itemCount = hashmap.value(index+j);
                itemCount++;
            }
            hashmap.replace(index+j,itemCount);
        }

    }

    //Assign width values based on number of items at an index and their height
    for(int i=0;i<count;i++)
    {
        CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
        int startIndex = calItem->startIndex;
        int htUnits = calItem->heightUnits;
        int maxCount=1,tmpVal=0;

        for(int j=0;j<htUnits;j++) {
            tmpVal = hashmap.value(startIndex+j);
            if(tmpVal>maxCount) {
                maxCount = tmpVal;
            }
        }

        calItem->widthUnits = (calItem->widthUnits)/maxCount;
    }

    //Assign xUnits value
    QMultiHash<int,int> xOffsetHashmap;

    for(int i=0;i<count;i++)
    {
        int itemCount=0;
        CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
        int startIndex = calItem->startIndex;
        int htUnits = calItem->heightUnits;
        int maxCount=0,tmpVal=0;

        for(int j=0;j<htUnits;j++) {
            tmpVal = xOffsetHashmap.value(startIndex+j);
            if(tmpVal>maxCount) {
                maxCount = tmpVal;
            }
        }
        calItem->xUnits=maxCount;
        for(int j=0;j<htUnits;j++) {
            if(xOffsetHashmap.count(startIndex+j) == 0) {
                itemCount = 1;
            } else {
                itemCount = xOffsetHashmap.value(startIndex+j);
                itemCount++;
            }
            xOffsetHashmap.replace(startIndex+j,itemCount);
        }

    }

    return;
}

int DayViewModel::computeStartIndex(QTime startTime)
{
    int startHr = startTime.hour();
    int startMin = startTime.minute();
    int startIndex = 0;
    switch(startHr) {
    case 0: {
        if(startMin<30) { startIndex = UtilMethods::E0to030; }
        else { startIndex = UtilMethods::E030to1; }
        break;
    }

    case 1: {
        if(startMin<30) { startIndex = UtilMethods::E1to130; }
        else { startIndex = UtilMethods::E130to2; }
        break;
    }

    case 2: {
        if(startMin<30) { startIndex = UtilMethods::E2to230; }
        else { startIndex = UtilMethods::E230to3; }
        break;
    }

    case 3: {
        if(startMin<30) { startIndex = UtilMethods::E3to330; }
        else { startIndex = UtilMethods::E330to4; }
        break;
    }

    case 4: {
        if(startMin<30) { startIndex = UtilMethods::E4to430; }
        else { startIndex = UtilMethods::E430to5; }
        break;
    }

    case 5: {
        if(startMin<30) { startIndex = UtilMethods::E5to530; }
        else { startIndex = UtilMethods::E530to6; }
        break;
    }

    case 6: {
        if(startMin<30) { startIndex = UtilMethods::E6to630; }
        else { startIndex = UtilMethods::E630to7; }
        break;
    }
        case 7: {
            if(startMin<30) { startIndex = UtilMethods::E7to730; }
            else { startIndex = UtilMethods::E730to8; }
            break;
        }

        case 8: {
            if(startMin<30) { startIndex = UtilMethods::E8to830; }
            else { startIndex = UtilMethods::E830to9; }
            break;
        }

        case 9: {
            if(startMin<30) { startIndex = UtilMethods::E9to930; }
            else { startIndex = UtilMethods::E930to10; }
            break;
        }

        case 10: {
        if(startMin<30) { startIndex = UtilMethods::E10to1030; }
        else { startIndex = UtilMethods::E1030to11; }
        break;
    }
        case 11:{
        if(startMin<30) { startIndex = UtilMethods::E11to1130; }
        else { startIndex = UtilMethods::E1130to12; }
        break;
    }

        case 12: {
        if(startMin<30) { startIndex = UtilMethods::E12to1230; }
        else { startIndex = UtilMethods::E1230to13; }
        break;
    }
        case 13:{
        if(startMin<30) { startIndex = UtilMethods::E13to1330; }
        else { startIndex = UtilMethods::E1330to14; }
        break;
    }
        case 14: {
        if(startMin<30) { startIndex = UtilMethods::E14to1430; }
        else { startIndex = UtilMethods::E1430to15; }
        break;
    }

        case 15: {
        if(startMin<30) { startIndex = UtilMethods::E15to1530; }
        else { startIndex = UtilMethods::E1530to16; }
        break;
    }

        case 16: {
        if(startMin<30) { startIndex = UtilMethods::E16to1630; }
        else { startIndex = UtilMethods::E1630to17; }
        break;
    }
        case 17: {
        if(startMin<30) { startIndex = UtilMethods::E17to1730; }
        else { startIndex = UtilMethods::E1730to18; }
        break;
    }

        case 18: {
        if(startMin<30) { startIndex = UtilMethods::E18to1830; }
        else { startIndex = UtilMethods::E1830to19; }
        break;
    }

        case 19: {
        if(startMin<30) { startIndex = UtilMethods::E19to1930; }
        else { startIndex = UtilMethods::E1930to20; }
        break;
    }
        case 20: {
        if(startMin<30) { startIndex = UtilMethods::E20to2030; }
        else { startIndex = UtilMethods::E2030to21; }
        break;
    }
        case 21:{
        if(startMin<30) { startIndex = UtilMethods::E21to2130; }
        else { startIndex = UtilMethods::E2130to22; }
        break;
    }
        case 22: {
        if(startMin<30) { startIndex = UtilMethods::E22to2230; }
        else { startIndex = UtilMethods::E2230to23; }
        break;
    }
        case 23: {
        if(startMin<30) { startIndex = UtilMethods::E23to2330; }
        else { startIndex = UtilMethods::E2330to24; }
        break;
    }
    }
    return startIndex;
}

QVariant DayViewModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    CalendarDataItem *item = itemsList[index.row()];

    if (role == CalendarDataItem::Index)
        return item->index;
    if (role == CalendarDataItem::Type)
        return item->type;
    if (role == CalendarDataItem::Uid)
        return item->uid;
    if (role == CalendarDataItem::Description)
        return item->description;
    if (role == CalendarDataItem::Summary)
        return item->summary;
    if (role == CalendarDataItem::Location)
        return item->location;
    if (role == CalendarDataItem::AllDay)
        return item->allDay;
    if (role == CalendarDataItem::RepeatType)
        return item->repeatType;
    if (role == CalendarDataItem::RepeatEndType)
        return item->repeatEndType;
    if (role == CalendarDataItem::RepeatCount)
        return item->repeatCount;
    if (role == CalendarDataItem::StartDate)
        return item->startDate;
    if (role == CalendarDataItem::StartTime)
        return item->startTime;
    if (role == CalendarDataItem::EndDate)
        return item->endDate;
    if (role == CalendarDataItem::EndTime)
        return item->endTime;
    if (role == CalendarDataItem::RepeatEndDate)
        return item->repeatEndDate;
    if (role == CalendarDataItem::RepeatEndTime)
        return item->repeatEndTime;
    if (role == CalendarDataItem::AlarmType)
        return item->alarmType;
    if (role == CalendarDataItem::AlarmDate)
        return item->alarmDate;
    if (role == CalendarDataItem::AlarmTime)
        return item->alarmTime;
    if (role == CalendarDataItem::ZoneOffset)
        return item->zoneOffset;
    if (role == CalendarDataItem::ZoneName)
        return item->zoneName;
    if (role == CalendarDataItem::XUnits)
        return item->xUnits;
    if (role == CalendarDataItem::YUnits)
        return item->yUnits;
    if (role == CalendarDataItem::HeightUnits)
        return item->heightUnits;
    if (role == CalendarDataItem::WidthUnits)
        return item->widthUnits;
    if (role == CalendarDataItem::StartIndex)
        return item->startIndex;
    return QVariant();
}

QVariant DayViewModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int DayViewModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int DayViewModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void DayViewModel::clearData()
{

    if(!itemsList.isEmpty())
    {
        while (!itemsList.isEmpty())
            delete itemsList.takeFirst();
    }
}

QML_DECLARE_TYPE(DayViewModel);

