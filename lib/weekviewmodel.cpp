/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "weekviewmodel.h"
#include "calendardataitem.h"
#include <inttypes.h>
#include <utilmethods.h>
#include "incidenceio.h"
#include <math.h>

WeekViewModel::WeekViewModel(QObject *parent) : QAbstractListModel(parent)
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
    roles.insert(CalendarDataItem::XUnits,"xUnits");
    roles.insert(CalendarDataItem::YUnits,"yUnits");
    roles.insert(CalendarDataItem::HeightUnits,"heightUnits");
    roles.insert(CalendarDataItem::WidthUnits,"widthUnits");
    roles.insert(CalendarDataItem::StartIndex,"startIndex");
    roles.insert(CalendarDataItem::DayIndex,"dayIndex");

    setRoleNames(roles);
    loadCurrentWeekValues();
}


WeekViewModel::~WeekViewModel()
{
    clearData();
}

void WeekViewModel::setMap(QDate currDate)
{
    int currDayIndex = currDate.dayOfWeek();
    QDate startDate = currDate.addDays(1-currDayIndex);

    weekMap.insert(startDate.dayOfWeek(),0);
    weekMap.insert(startDate.addDays(1).dayOfWeek(),1);
    weekMap.insert(startDate.addDays(2).dayOfWeek(),2);
    weekMap.insert(startDate.addDays(3).dayOfWeek(),3);
    weekMap.insert(startDate.addDays(4).dayOfWeek(),4);
    weekMap.insert(startDate.addDays(5).dayOfWeek(),5);
    weekMap.insert(startDate.addDays(6).dayOfWeek(),6);

    QHash<int, int>::const_iterator i = weekMap.constBegin();
     while (i != weekMap.constEnd()) {
         qDebug() << i.key() << ": " << i.value() << endl;
         ++i;
     }

}

int WeekViewModel::getMapIndex(QDate startDate)
{
    int index=0;

    int key = startDate.dayOfWeek();
    qDebug()<<"Finding value for key="<<key;
    if(weekMap.contains(key)) {
        index = (int)(weekMap.value(key));
    } else {
        index = -1;
    }

    qDebug()<<"index from getMapindex="<<index<<", for date "<<startDate.dayOfWeek();
    return index;
}

void WeekViewModel::loadCurrentWeekValues()
{
    qDebug()<<"entered loadCurrentWeekValues()\n";
    loadGivenWeekModel(QDate::currentDate());
}

void WeekViewModel::loadGivenWeekModel(QDate nextDate)
{
    qDebug()<<"entered loadGivenDayModel()\n";
    setMap(nextDate);
    int currDayIndex = nextDate.dayOfWeek();
    QDate startDate = nextDate.addDays(1-currDayIndex);

    CalendarController controller;
    clearData();
    emit beginResetModel();
    int eventsCount=0;

    for(int i=0;i<7;i++)
    {
        QList<IncidenceIO> list = controller.getEventsFromDB(EDayList,KDateTime(startDate.addDays(i)));

        if(modelType == UtilMethods::EAllEvents ) {
            for(int i=0;i<list.count();i++) {
                IncidenceIO ioObject = list.at(i);
                if(ioObject.isAllDay()) {
                    itemsList << new CalendarDataItem(eventsCount,ioObject);
                    eventsCount++;
                }
            }
            for(int i=0;i<list.count();i++) {
                IncidenceIO ioObject = list.at(i);
                if(!ioObject.isAllDay()) {
                    itemsList << new CalendarDataItem(eventsCount,ioObject);
                    eventsCount++;
                }
            }
            qDebug()<<"Added total events = "<<itemsList.count();
        } else {
            for(int i=0;i<list.count();i++) {
                IncidenceIO ioObject = list.at(i);
                if((modelType == UtilMethods::EAllDay) && (ioObject.isAllDay())) {
                    itemsList << new CalendarDataItem(i,ioObject);
                    ioObject.printIncidence();
                } else if((modelType == UtilMethods::ENotAllDay) && (!ioObject.isAllDay())) {
                    itemsList << new CalendarDataItem(i,ioObject);
                    ioObject.printIncidence();
                }
            }
            assignDisplayValues();

        }
    }
    emit endResetModel();
}

void WeekViewModel::assignDisplayValues()
{
    int count = itemsList.count();

    if(count == 0)
        return;

    if(modelType == UtilMethods::EAllDay)
    {
        for(int i=0;i<count;i++)
        {
            CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
            int mapIndex = getMapIndex(calItem->startDate);
            calItem->dayIndex = mapIndex;
        }
        return;
    }

    QMultiHash<int,int> hashmap;

    //Counting how many items start at an index
    for(int i=0;i<count;i++)
    {
        int index = 0,itemCount=0;

        CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
        index = computeStartIndex(calItem->startTime,calItem->startDate,calItem->dayIndex);
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
        qDebug()<<"xUnits="<<calItem->xUnits<<",yUnits="<<calItem->yUnits<<",widthUnits="<<calItem->widthUnits<<", heightUnits="<<calItem->heightUnits<<",startIndex="<<calItem->startIndex<<",dayIndex="<<calItem->dayIndex;

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

    //Based on the count computed above, assign the width and xUnits
    for(int i=0;i<count;i++)
    {
        int itemCount=0;
        CalendarDataItem *calItem = ((CalendarDataItem*)(itemsList.at(i)));
        itemCount = hashmap.value(calItem->startIndex);
        qDebug()<<"Itemcount for "<<calItem->startIndex<<"="<<itemCount;
        if(itemCount >1) {
            QList<CalendarDataItem*> sameIndexItems;
            for(int k=0;k<count;k++) {
                CalendarDataItem *nextItem = ((CalendarDataItem*)(itemsList.at(k)));
                if((nextItem->startIndex == calItem->startIndex)) {
                    sameIndexItems.append(nextItem);
                }
                nextItem = NULL;
            }
            qDebug()<<"Count of sameIndexItems.count()="<<sameIndexItems.count()<<"itemCount="<<itemCount;
            if(sameIndexItems.count() == itemCount) {
                for(int l=0;l<itemCount;l++) {
                    qDebug()<<"Assigning values for item"<<l;
                    ((CalendarDataItem*)(sameIndexItems.at(l)))->xUnits = l;
                    ((CalendarDataItem*)(sameIndexItems.at(l)))->widthUnits = (1.0/itemCount);
                    qDebug()<<"xUnits="<<((CalendarDataItem*)(sameIndexItems.at(l)))->xUnits<<",widthUnits="<<((CalendarDataItem*)(sameIndexItems.at(l)))->widthUnits;
                }
                sameIndexItems.clear();
                qDebug()<<"Done with same index items";
            }
            qDebug()<<"After same index items block";

            //Computing how many item start within the height of an existing item
            QList<CalendarDataItem*> overlapByOffsetItems;
            for(int k=0;k<count;k++) {
                qDebug()<<"Inside the loop for overlapitems";
                CalendarDataItem *nextItem = ((CalendarDataItem*)(itemsList.at(k)));
                if((calItem->startIndex > nextItem->startIndex ) && (calItem->startIndex <(nextItem->startIndex+nextItem->heightUnits)) ) {
                    overlapByOffsetItems.append(nextItem);
                }
                nextItem = NULL;
            }

            qDebug()<<"Count of overlapbyoffset items ="<<overlapByOffsetItems.count();
            if(overlapByOffsetItems.count()>0) {
                calItem->xUnits = itemCount-1;
                calItem->widthUnits = (1.0/itemCount);
                qDebug()<<"xUnits="<<calItem->xUnits<<",widthUnits="<<calItem->widthUnits;
               for(int m=0;m<overlapByOffsetItems.count();m++) {
                    CalendarDataItem *prevItem = ((CalendarDataItem*)(overlapByOffsetItems.at(m)));
                    prevItem->widthUnits = (1.0/itemCount);
                }
                overlapByOffsetItems.clear();
                qDebug()<<"done with overlap items";
            }
        }

    }//end for loop

    return;
}

int WeekViewModel::computeStartIndex(QTime startTime,QDate startDate,int &dayIndex)
{
    int startHr = startTime.hour();
    int startMin = startTime.minute();
    int startIndex = 0;
    int mapIndex = getMapIndex(startDate);
    dayIndex = mapIndex;

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

    qDebug()<<"After computation,startIndex="<<startIndex;
    return startIndex;
}

QVariant WeekViewModel::data(const QModelIndex &index, int role) const
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
    if (role == CalendarDataItem::DayIndex)
        return item->dayIndex;
    return QVariant();
}

QVariant WeekViewModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int WeekViewModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int WeekViewModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void WeekViewModel::clearData()
{
    if(!itemsList.isEmpty())
    {
        beginRemoveRows(QModelIndex(), 0, itemsList.count()-1);
        for(int i = 0; i < itemsList.count(); i++)
            delete itemsList[i];
        itemsList.clear();
        endRemoveRows();
    }
}

QML_DECLARE_TYPE(WeekViewModel);


