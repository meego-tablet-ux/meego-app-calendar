/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */
#include "eventsdatamodel.h"
#include "calendardataitem.h"
#include <inttypes.h>
#include <utilmethods.h>
#include "incidenceio.h"
#include <QMultiHash>
#include <math.h>

EventsDataModel::EventsDataModel(int count, QList<CalendarDataItem*> dataList,QObject *parent) : QAbstractListModel(parent)
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
    this->count = count;
    this->itemsList = dataList;
}

EventsDataModel::EventsDataModel(QObject *parent) : QAbstractListModel(parent)
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
    this->count = 0;
    this->itemsList = QList<CalendarDataItem*>();
}


EventsDataModel::~EventsDataModel()
{
    clearData();
}


QVariant EventsDataModel::data(const QModelIndex &index, int role) const
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
    return QVariant();
}

QVariant EventsDataModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int EventsDataModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int EventsDataModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void EventsDataModel::clearData()
{
    if(!itemsList.isEmpty())
    {
        beginResetModel();
        for(int i = 0; i < itemsList.count(); i++)
            delete itemsList[i];
        itemsList.clear();
        endResetModel();
    }
}

QML_DECLARE_TYPE(EventsDataModel*);

