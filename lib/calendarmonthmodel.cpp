/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendarmonthmodel.h"
#include <inttypes.h>
#include <utilmethods.h>
#include <calendarcontroller.h>
#include "incidenceio.h"


MonthItem::MonthItem(int index, QString dateValString, QDate coreDateVal, bool isMonthDay, bool isCurrentDay, QString event1,QString event2,QString event3,int eventsCount,QObject *parent) : QObject(parent)
{
    this->index = index;
    this->dateValString = dateValString;
    this->coreDateVal = coreDateVal;
    this->isMonthDay = isMonthDay;
    this->isCurrentDay = isCurrentDay;
    this->event1 = event1;
    this->event2 = event2;
    this->event3 = event3;
    this->eventsCount = eventsCount;
}


CalendarMonthModel::CalendarMonthModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(MonthItem::Index, "index");
    roles.insert(MonthItem::DateValString, "dateValString");
    roles.insert(MonthItem::CoreDateVal, "coreDateVal");
    roles.insert(MonthItem::IsMonthDay,"isMonthDay");
    roles.insert(MonthItem::IsCurrentDay,"isCurrentDay");
    roles.insert(MonthItem::Event1,"event1");
    roles.insert(MonthItem::Event2,"event2");
    roles.insert(MonthItem::Event3,"event3");
    roles.insert(MonthItem::EventsCount,"eventsCount");

    setRoleNames(roles);
}

CalendarMonthModel::~CalendarMonthModel()
{
    clearData();
}

void CalendarMonthModel::loadCurrentMonthValues()
{
    UtilMethods utilities;
    CalendarController controller;
    int monthDays = dateVal.daysInMonth();
    QDate monthStartDate(dateVal.year(),dateVal.month(),1);
    QDate monthEndDate(dateVal.year(),dateVal.month(),monthDays);


    int startDayOfMonth = monthStartDate.dayOfWeek();
    int endDayOfMonth = monthEndDate.dayOfWeek();
    int daysBeforeStartDay = (7-weekStartDay+startDayOfMonth)%7;
    int endDateIndex = (weekStartDay-1)<1?7:(weekStartDay-1);
    int daysAfterEndDay = endDateIndex-endDayOfMonth;
    int totalDisplayDays = monthDays+daysBeforeStartDay+daysAfterEndDay;
    daysAfterEndDay += (42-totalDisplayDays);
    totalDisplayDays = monthDays+daysBeforeStartDay+daysAfterEndDay;
    beginResetModel();
    clearData();

    int indexCount=0;
    for(indexCount=0;indexCount<daysBeforeStartDay;indexCount++) {
        QDate tmpDate = monthStartDate.addDays(-(daysBeforeStartDay-indexCount));
        bool currDate = false;
        if(utilities.datesEqual(tmpDate,QDate::currentDate())) {
            currDate = true;
        }
        itemsList << new MonthItem(indexCount,utilities.getDateInFormatString(tmpDate,"d"),tmpDate,false,currDate);
    }

    for(int j=0;j<monthDays;j++,indexCount++) {
        QDate tmpDate = monthStartDate.addDays(j);
        bool currDate = false;
        int eventsCount=0;
        QString event1="";
        QString event2="";
        QString event3="";
        QString allDayText = tr("All day: ");

        if(utilities.datesEqual(tmpDate,QDate::currentDate())) {
            currDate = true;
        }
        QList<IncidenceIO*> list = controller.getEventsFromDB(EDayList,KDateTime(tmpDate));

        eventsCount = list.count();
        if(eventsCount>0) {
            if(eventsCount==1) {
                IncidenceIO *ioObject = list.at(0);
                if(ioObject->isAllDay()) event1 = allDayText;
                event1 += ioObject->getSummary();
            } else if(eventsCount ==2) {
                IncidenceIO *ioObject = list.at(0);
                if(ioObject->isAllDay()) event1 = allDayText;
                event1 += ioObject->getSummary();
                IncidenceIO *ioObject2 = list.at(1);
                if(ioObject2->isAllDay()) event2 = allDayText;
                event2 += ioObject2->getSummary();
            } else if(eventsCount ==3) {
                IncidenceIO *ioObject = list.at(0);
                if(ioObject->isAllDay()) event1 = allDayText;
                event1 += ioObject->getSummary();
                IncidenceIO *ioObject2 = list.at(1);
                if(ioObject2->isAllDay()) event2 = allDayText;
                event2 += ioObject2->getSummary();
                IncidenceIO *ioObject3 = list.at(2);
                if(ioObject3->isAllDay()) event3 = allDayText;
                event3 += ioObject3->getSummary();
            } else {
                IncidenceIO *ioObject = list.at(0);
                if(ioObject->isAllDay()) event1 = allDayText;
                event1 += ioObject->getSummary();
                IncidenceIO *ioObject2 = list.at(1);
                if(ioObject2->isAllDay()) event2 = allDayText;
                event2 += ioObject2->getSummary();
                //: %n corresponds to events count
                event3 = tr("%n more event(s)", "", eventsCount - 2);
            }

        }
        itemsList << new MonthItem(indexCount,utilities.getDateInFormatString(tmpDate,"d"),tmpDate,true,currDate,event1,event2,event3,eventsCount);
        // Clean up
        qDeleteAll(list);
    }

    for(int k=1;k<=daysAfterEndDay;k++,indexCount++) {
        QDate tmpDate = monthEndDate.addDays(k);
        bool currDate = false;
        if(utilities.datesEqual(tmpDate,QDate::currentDate())) {
            currDate = true;
        }
        itemsList << new MonthItem(indexCount,utilities.getDateInFormatString(tmpDate,"d"),tmpDate,false,currDate);
    }

   endResetModel();
}

void CalendarMonthModel::loadGivenMonthValuesFromOffset(QDate dateInFocus)
{
    dateVal = dateInFocus;
    loadCurrentMonthValues();
}

QVariant CalendarMonthModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    MonthItem *item = itemsList[index.row()];

    if (role == MonthItem::Index)
        return item->index;

    if (role == MonthItem::DateValString)
        return item->dateValString;

    if (role == MonthItem::CoreDateVal)
        return item->coreDateVal;

    if (role == MonthItem::IsMonthDay)
        return item->isMonthDay;

    if(role == MonthItem::IsCurrentDay)
        return item->isCurrentDay;

    if(role == MonthItem::Event1)
        return item->event1;

    if(role == MonthItem::Event2)
        return item->event2;

    if(role == MonthItem::Event3)
        return item->event3;

    if(role == MonthItem::EventsCount)
        return item->eventsCount;

    return QVariant();
}

QVariant CalendarMonthModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int CalendarMonthModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int CalendarMonthModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void CalendarMonthModel::clearData()
{
    if(!itemsList.isEmpty())
    {
        while (!itemsList.isEmpty())
            delete itemsList.takeFirst();
    }
}

QML_DECLARE_TYPE(CalendarMonthModel);
