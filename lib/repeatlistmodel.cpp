/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "repeatlistmodel.h"
#include <inttypes.h>
#include <utilmethods.h>

RepeatItem::RepeatItem(int type, QString desc, QObject *parent) : QObject(parent)
{
    this->type = type;
    this->description = desc;
}


RepeatListModel::RepeatListModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(RepeatItem::Type, "type");
    roles.insert(RepeatItem::Description, "description");
    setRoleNames(roles);

    itemsList << new RepeatItem(UtilMethods::ENoRepeat,tr("Never"));
    itemsList << new RepeatItem(UtilMethods::EEveryDay,tr("Every day"));
    itemsList << new RepeatItem(UtilMethods::EEveryWeek,tr("Every week"));
    itemsList << new RepeatItem(UtilMethods::EEvery2Weeks,tr("Every 2 weeks"));
    itemsList << new RepeatItem(UtilMethods::EEveryMonth,tr("Every month"));
    itemsList << new RepeatItem(UtilMethods::EEveryYear,tr("Every year"));
    itemsList << new RepeatItem(UtilMethods::EOtherRepeat,tr("Other..."));
}

RepeatListModel::~RepeatListModel()
{
    clearData();
}

QVariant RepeatListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    RepeatItem *item = itemsList[index.row()];

    if (role == RepeatItem::Type)
        return item->type;

    if (role == RepeatItem::Description)
        return item->description;

    return QVariant();
}

QVariant RepeatListModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int RepeatListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int RepeatListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void RepeatListModel::clearData()
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

RepeatEndListModel::RepeatEndListModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(RepeatItem::Type, "type");
    roles.insert(RepeatItem::Description, "description");
    setRoleNames(roles);

    itemsList << new RepeatItem(UtilMethods::EForever,tr("Repeats forever"));
    itemsList << new RepeatItem(UtilMethods::EForNTimes,tr("Ends after number of times..."));
    itemsList << new RepeatItem(UtilMethods::EAfterDate,tr("Ends after date..."));
}

RepeatEndListModel::~RepeatEndListModel()
{
    clearData();
}

QVariant RepeatEndListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() > itemsList.count())
        return QVariant();

    RepeatItem *item = itemsList[index.row()];

    if (role == RepeatItem::Type)
        return item->type;

    if (role == RepeatItem::Description)
        return item->description;

    return QVariant();
}

QVariant RepeatEndListModel::data(int index) const
{
    if(index >= itemsList.size())
        index = itemsList.size() - 1;

    return QVariant::fromValue(static_cast<void *>(itemsList[index]));
}

int RepeatEndListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return itemsList.size();
}

int RepeatEndListModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return 1;
}

void RepeatEndListModel::clearData()
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

QML_DECLARE_TYPE(RepeatListModel);
QML_DECLARE_TYPE(RepeatEndListModel);
