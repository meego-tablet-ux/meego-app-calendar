/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "viewcalendarmodel.h"
#include <inttypes.h>
#include <utilmethods.h>

ViewItem::ViewItem(int type, QString desc,QString icon, QObject *parent) : QObject(parent)
{
    this->type = type;
    this->description = desc;
    this->icon = icon;
}


ViewCalendarModel::ViewCalendarModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(ViewItem::Type, "type");
    roles.insert(ViewItem::Description, "description");
    roles.insert(ViewItem::Icon, "icon");
    setRoleNames(roles);

    itemsList << new ViewItem(UtilMethods::EDayView,tr("Day"),"image://theme/calendar/icn_daycalendar_up");
    itemsList << new ViewItem(UtilMethods::EWeekView,tr("Week"),"image://theme/calendar/icn_weekcalendar_up");
    itemsList << new ViewItem(UtilMethods::EMonthView,tr("Month"),"image://theme/calendar/icn_monthcalendar_up");
}

ViewCalendarModel::~ViewCalendarModel()
{
    clearData();
}

QVariant ViewCalendarModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    ViewItem *item = itemsList[index.row()];

    if (role == ViewItem::Type)
        return item->type;

    if (role == ViewItem::Description)
        return item->description;

    if (role == ViewItem::Icon)
        return item->icon;

    return QVariant();
}

QVariant ViewCalendarModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int ViewCalendarModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int ViewCalendarModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void ViewCalendarModel::clearData()
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

QML_DECLARE_TYPE(ViewCalendarModel);
