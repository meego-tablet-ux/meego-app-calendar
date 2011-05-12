/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "timelistmodel.h"
#include <inttypes.h>
#include <utilmethods.h>

TimeListItem::TimeListItem(int index, QString timeVal, int startHr, int endHr,EventsDataModel *dataModel,QObject *parent) : QObject(parent)
{
    this->index = index;
    this->timeVal = timeVal;
    this->startHr = startHr;
    this->endHr = endHr;
    this->dataModel = dataModel;
}


TimeListModel::TimeListModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(TimeListItem::Index, "index");
    roles.insert(TimeListItem::TimeVal, "timeVal");
    roles.insert(TimeListItem::StartHr, "startHr");
    roles.insert(TimeListItem::EndHr, "endHr");
    roles.insert(TimeListItem::DataModel, "dataModel");
    setRoleNames(roles);
}

void TimeListModel::loadValues()
{

    UtilMethods utilities;
    QTime startTime;
    startTime.setHMS(0,0,0);
    itemsList << new TimeListItem(0,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),0,030,getDataModelAtIndex(0));
    itemsList << new TimeListItem(1,tr(""),0,100,getDataModelAtIndex(1));

    startTime.setHMS(1,0,0);
    itemsList << new TimeListItem(2,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),1,130,getDataModelAtIndex(2));
    itemsList << new TimeListItem(3,tr(""),1,200,getDataModelAtIndex(3));

    startTime.setHMS(2,0,0);
    itemsList << new TimeListItem(4,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),2,230,getDataModelAtIndex(4));
    itemsList << new TimeListItem(5,tr(""),2,300,getDataModelAtIndex(5));

    startTime.setHMS(3,0,0);
    itemsList << new TimeListItem(6,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),3,330,getDataModelAtIndex(6));
    itemsList << new TimeListItem(7,tr(""),3,400,getDataModelAtIndex(7));

    startTime.setHMS(4,0,0);
    itemsList << new TimeListItem(8,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),4,430,getDataModelAtIndex(8));
    itemsList << new TimeListItem(9,tr(""),4,500,getDataModelAtIndex(9));

    startTime.setHMS(5,0,0);
    itemsList << new TimeListItem(10,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),5,530,getDataModelAtIndex(10));
    itemsList << new TimeListItem(11,tr(""),5,600,getDataModelAtIndex(11));

    startTime.setHMS(6,0,0);
    itemsList << new TimeListItem(12,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),6,630,getDataModelAtIndex(12));
    itemsList << new TimeListItem(13,tr(""),6,700,getDataModelAtIndex(13));

    startTime.setHMS(7,0,0);
    itemsList << new TimeListItem(14,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),7,730,getDataModelAtIndex(14));
    itemsList << new TimeListItem(15,tr(""),7,800,getDataModelAtIndex(15));

    startTime.setHMS(8,0,0);
    itemsList << new TimeListItem(16,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),8,830,getDataModelAtIndex(16));
    itemsList << new TimeListItem(17,tr(""),8,900,getDataModelAtIndex(17));

    startTime.setHMS(9,0,0);
    itemsList << new TimeListItem(18,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),9,930,getDataModelAtIndex(18));
    itemsList << new TimeListItem(19,tr(""),9,1000,getDataModelAtIndex(19));

    startTime.setHMS(10,0,0);
    itemsList << new TimeListItem(20,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),10,1030,getDataModelAtIndex(20));
    itemsList << new TimeListItem(21,tr(""),10,1100,getDataModelAtIndex(21));

    startTime.setHMS(11,0,0);
    itemsList << new TimeListItem(22,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),11,1130,getDataModelAtIndex(22));
    itemsList << new TimeListItem(23,tr(""),11,1200,getDataModelAtIndex(23));

    startTime.setHMS(12,0,0);
    itemsList << new TimeListItem(24,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),12,1230,getDataModelAtIndex(24));
    itemsList << new TimeListItem(25,tr(""),12,1300,getDataModelAtIndex(25));

    startTime.setHMS(13,0,0);
    itemsList << new TimeListItem(26,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),13,1330,getDataModelAtIndex(26));
    itemsList << new TimeListItem(27,tr(""),13,1400,getDataModelAtIndex(27));

    startTime.setHMS(14,0,0);
    itemsList << new TimeListItem(28,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),14,1430,getDataModelAtIndex(28));
    itemsList << new TimeListItem(29,tr(""),14,1500,getDataModelAtIndex(29));

    startTime.setHMS(15,0,0);
    itemsList << new TimeListItem(30,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),15,1530,getDataModelAtIndex(30));
    itemsList << new TimeListItem(31,tr(""),15,1600,getDataModelAtIndex(31));

    startTime.setHMS(16,0,0);
    itemsList << new TimeListItem(32,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),16,1630,getDataModelAtIndex(32));
    itemsList << new TimeListItem(33,tr(""),16,1700,getDataModelAtIndex(33));

    startTime.setHMS(17,0,0);
    itemsList << new TimeListItem(34,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),17,1730,getDataModelAtIndex(34));
    itemsList << new TimeListItem(35,tr(""),17,1800,getDataModelAtIndex(35));

    startTime.setHMS(18,0,0);
    itemsList << new TimeListItem(36,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),18,1830,getDataModelAtIndex(36));
    itemsList << new TimeListItem(37,tr(""),18,1900,getDataModelAtIndex(37));

    startTime.setHMS(19,0,0);
    itemsList << new TimeListItem(38,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),19,1930,getDataModelAtIndex(38));
    itemsList << new TimeListItem(39,tr(""),19,2000,getDataModelAtIndex(39));

    startTime.setHMS(20,0,0);
    itemsList << new TimeListItem(40,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),20,2030,getDataModelAtIndex(40));
    itemsList << new TimeListItem(41,tr(""),20,2100,getDataModelAtIndex(41));

    startTime.setHMS(21,0,0);
    itemsList << new TimeListItem(42,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),21,2130,getDataModelAtIndex(42));
    itemsList << new TimeListItem(43,tr(""),21,2200,getDataModelAtIndex(43));

    startTime.setHMS(22,0,0);
    itemsList << new TimeListItem(44,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),22,2230,getDataModelAtIndex(44));
    itemsList << new TimeListItem(45,tr(""),22,2300,getDataModelAtIndex(45));

    startTime.setHMS(23,0,0);
    itemsList << new TimeListItem(46,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),23,2330,getDataModelAtIndex(46));
    itemsList << new TimeListItem(47,tr(""),23,2300,getDataModelAtIndex(47));
}


TimeListModel::~TimeListModel()
{
    clearData();
}


QVariant TimeListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    TimeListItem *item = itemsList[index.row()];

    if (role == TimeListItem::Index)
        return item->index;

    if (role == TimeListItem::TimeVal)
        return item->timeVal;

    if (role == TimeListItem::StartHr)
        return item->startHr;

    if (role == TimeListItem::EndHr)
        return item->endHr;

    if (role == TimeListItem::DataModel)
        //return item->dataModel;
        return QVariant::fromValue<EventsDataModel*>(item->dataModel);

    return QVariant();
}

QVariant TimeListModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int TimeListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int TimeListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}


void TimeListModel::clearData()
{
    while (!itemsList.isEmpty())
        delete itemsList.takeFirst();

    while (!eventsList.isEmpty())
        delete eventsList.takeFirst();

    if(!indexHash.empty()) {
        indexHash.clear();
    }
}


void TimeListModel::loadCurrentDayModel()
{
    beginResetModel();
    clearData();
    CalendarController controller;
    QList<IncidenceIO> list = controller.getEventsFromDB(EDayList,KDateTime(dateVal));

    int eventsCount=0;
    for(int i=0;i<list.count();i++) {
        IncidenceIO ioObject = list.at(i);
        if(!ioObject.isAllDay()) {
            eventsList << new CalendarDataItem(eventsCount,ioObject);
            eventsCount++;
        }
    }
    assignDisplayValues();
    loadValues();
    endResetModel();
    return;
}


void TimeListModel::loadGivenDayModel(QDate nextDate)
{
    dateVal = nextDate;
    loadCurrentDayModel();
    return;
}

void TimeListModel::assignDisplayValues()
{
    int count = eventsList.count();

    if(count == 0)
        return;

    QMultiHash<int,int> hashmap;

    //Counting how many items start at an index
    for(int i=0;i<count;i++)
    {
        int index = 0,itemCount=0;

        CalendarDataItem *calItem = ((CalendarDataItem*)(eventsList.at(i)));
        index = computeStartIndex(calItem->startTime);
        ((CalendarDataItem*)(eventsList.at(i)))->startIndex = index;
        ((CalendarDataItem*)(eventsList.at(i)))->xUnits = 0;
        ((CalendarDataItem*)(eventsList.at(i)))->yUnits = 0;
        ((CalendarDataItem*)(eventsList.at(i)))->widthUnits = 1.0;
        double htVal = (calItem->startTime.secsTo(calItem->endTime) / (60.0*30.0));
        if(htVal<0.5) {
            htVal = 0.5;
        }
        htVal = round(htVal);
        ((CalendarDataItem*)(eventsList.at(i)))->heightUnits = htVal;

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
        CalendarDataItem *calItem = ((CalendarDataItem*)(eventsList.at(i)));
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
        CalendarDataItem *calItem = ((CalendarDataItem*)(eventsList.at(i)));
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

    //Insert all the events into hash as per their indices
    for(int i=0;i<count;i++)
    {
        CalendarDataItem *calItem = ((CalendarDataItem*)(eventsList.at(i)));
        int startIndex = calItem->startIndex;
        indexHash.insertMulti(startIndex,calItem);
    }

    return;
}


EventsDataModel* TimeListModel::getDataModelAtIndex(int index)
{
    bool valuesExist = indexHash.contains(index);
    EventsDataModel *eventsModel;
    if(valuesExist) {
        QList<CalendarDataItem*> events = indexHash.values(index);
        eventsModel = new EventsDataModel(events.count(),events);
    } else {
        eventsModel = new EventsDataModel(0,indexHash.values(index));
    }
    return eventsModel;
}

int TimeListModel::computeStartIndex(QTime startTime)
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

QML_DECLARE_TYPE(TimeListModel);
