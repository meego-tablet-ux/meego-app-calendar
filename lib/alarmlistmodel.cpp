/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "alarmlistmodel.h"
#include <inttypes.h>
#include <utilmethods.h>

AlarmItem::AlarmItem(int type, QString desc, QObject *parent) : QObject(parent)
{
    this->type = type;
    this->description = desc;
}


AlarmListModel::AlarmListModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(AlarmItem::Type, "type");
    roles.insert(AlarmItem::Description, "description");
    setRoleNames(roles);
    itemsList << new AlarmItem(UtilMethods::ENoAlarm,tr("No reminder"));
    itemsList << new AlarmItem(UtilMethods::E10MinB4,tr("10 minutes before"));
    itemsList << new AlarmItem(UtilMethods::E15MinB4,tr("15 minutes before"));
    itemsList << new AlarmItem(UtilMethods::E30MinB4,tr("30 minutes before"));
    itemsList << new AlarmItem(UtilMethods::E1HrB4,tr("1 hour before"));
    itemsList << new AlarmItem(UtilMethods::E2HrsB4,tr("2 hours before"));
    itemsList << new AlarmItem(UtilMethods::E1DayB4,tr("1 day before"));
    itemsList << new AlarmItem(UtilMethods::E2DaysB4,tr("2 days before"));
    itemsList << new AlarmItem(UtilMethods::E1WeekB4,tr("1 week before"));
    itemsList << new AlarmItem(UtilMethods::EOtherAlarm,tr("Other..."));
}

AlarmListModel::~AlarmListModel()
{
    clearData();
}

QVariant AlarmListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    AlarmItem *item = itemsList[index.row()];

    if (role == AlarmItem::Type)
        return item->type;

    if (role == AlarmItem::Description)
        return item->description;

    return QVariant();
}

QVariant AlarmListModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int AlarmListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int AlarmListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void AlarmListModel::clearData()
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

QML_DECLARE_TYPE(AlarmListModel);
