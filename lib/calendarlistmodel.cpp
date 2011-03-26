/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendarlistmodel.h"
#include <inttypes.h>
#include <utilmethods.h>
#include "incidenceio.h"
#include <QHash>
#include <math.h>

CalendarListModel::CalendarListModel(QObject *parent) : QAbstractListModel(parent)
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

    setRoleNames(roles);
    loadAllEventsSorted();

    for(int i = 0; i < itemsList.count(); i++)
        itemsDisplay << itemsList[i];
}


CalendarListModel::~CalendarListModel()
{
    clearData();
}

void CalendarListModel::refresh()
{
    qDebug()<<"entered refresh()\n";
    CalendarController controller;
    QList<IncidenceIO> list = controller.getEventsFromDB(EAll);

    beginResetModel();
    clearData();
    int eventsCount=0;
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
    qDebug()<<"refresh Added total events = "<<itemsList.count();

    if(!itemsDisplay.isEmpty())
    {
        itemsDisplay.clear();
    }
    for(int i = 0; i < itemsList.count(); i++)
        itemsDisplay << itemsList[i];
    endResetModel();
    qDebug()<<"exiting refresh";
}

void CalendarListModel::loadAllEventsSorted()
{
    qDebug()<<"entered loadAllEventsSorted()\n";
    CalendarController controller;
    QList<IncidenceIO> list = controller.getEventsFromDB(EAll);

    beginResetModel();
    clearData();
    int eventsCount=0;
    for(int i=0;i<list.count();i++) {
        IncidenceIO ioObject = list.at(i);
        if(ioObject.isAllDay()) {
            qDebug()<<"Inside adding alldayevents, eventsCount="<<eventsCount;
            itemsList << new CalendarDataItem(eventsCount,ioObject);
            eventsCount++;
        }
    }
    for(int i=0;i<list.count();i++) {
        IncidenceIO ioObject = list.at(i);
        if(!ioObject.isAllDay()) {
            qDebug()<<"Inside adding not alldayevents, eventsCount="<<eventsCount;
            itemsList << new CalendarDataItem(eventsCount,ioObject);
            eventsCount++;
        }
    }
    qDebug()<<"Added total events = "<<itemsList.count();

    endResetModel();
    qDebug()<<"exiting loadAllEventsSorted";
}



void CalendarListModel::filterOut(QString filter)
{
    QList<CalendarDataItem*> displaylist;
        for(int i = 0; i < itemsList.count(); i++) {
            if(filter.isEmpty()||itemsList[i]->summary.contains(filter, Qt::CaseInsensitive))
            {
                itemsList[i]->xUnits = itemsList[i]->summary.indexOf(filter,0,Qt::CaseInsensitive);
                itemsList[i]->widthUnits = filter.length();
                displaylist << itemsList[i];
                qDebug()<<"xUnits="<<itemsList[i]->xUnits<<",widthUnits="<<itemsList[i]->widthUnits;
            }
        }
    //qDebug()<<"Total events in displaylist ="<<displaylist.count();
    if(!itemsDisplay.isEmpty())
    {
        beginRemoveRows(QModelIndex(), 0, itemsDisplay.count()-1);
        itemsDisplay.clear();
        endRemoveRows();
    }
    if(!displaylist.isEmpty())
    {
        beginInsertRows(QModelIndex(), 0, displaylist.count()-1);

        itemsDisplay = displaylist;

        qDebug()<<"itemsDisplay has "<<itemsDisplay.count()<<" items";
        endInsertRows();
    }
}


QVariant CalendarListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsDisplay.count())
        return QVariant();

    CalendarDataItem *item = itemsDisplay[index.row()];

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
    return QVariant();
}

QVariant CalendarListModel::data(int index) const
{
    if(index >= itemsDisplay.size())
        index = itemsDisplay.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsDisplay[index]));
}

int CalendarListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsDisplay.size();
}

int CalendarListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void CalendarListModel::clearData()
{
    if(!itemsList.isEmpty())
    {
        for(int i = 0; i < itemsList.count(); i++)
            delete itemsList[i];
        itemsList.clear();
    }
}

QML_DECLARE_TYPE(CalendarListModel);

