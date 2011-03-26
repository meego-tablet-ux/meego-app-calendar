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

TimeListItem::TimeListItem(int index, QString timeVal, int startHr, int endHr,QObject *parent) : QObject(parent)
{
    this->index = index;
    this->timeVal = timeVal;
    this->startHr = startHr;
    this->endHr = endHr;
}


TimeListModel::TimeListModel(QObject *parent) : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles.insert(TimeListItem::Index, "index");
    roles.insert(TimeListItem::TimeVal, "timeVal");
    roles.insert(TimeListItem::StartHr, "startHr");
    roles.insert(TimeListItem::EndHr, "endHr");
    setRoleNames(roles);

    UtilMethods utilities;

    QTime startTime;
    startTime.setHMS(0,0,0);
    itemsList << new TimeListItem(0,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),0,030);
    itemsList << new TimeListItem(1,tr(""),0,100);

    startTime.setHMS(1,0,0);
    itemsList << new TimeListItem(2,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),1,130);
    itemsList << new TimeListItem(3,tr(""),1,200);

    startTime.setHMS(2,0,0);
    itemsList << new TimeListItem(4,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),2,230);
    itemsList << new TimeListItem(5,tr(""),2,300);

    startTime.setHMS(3,0,0);
    itemsList << new TimeListItem(6,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),3,330);
    itemsList << new TimeListItem(7,tr(""),3,400);

    startTime.setHMS(4,0,0);
    itemsList << new TimeListItem(8,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),4,430);
    itemsList << new TimeListItem(9,tr(""),4,500);

    startTime.setHMS(5,0,0);
    itemsList << new TimeListItem(10,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),5,530);
    itemsList << new TimeListItem(11,tr(""),5,600);

    startTime.setHMS(6,0,0);
    itemsList << new TimeListItem(12,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),6,630);
    itemsList << new TimeListItem(13,tr(""),6,700);

    startTime.setHMS(7,0,0);
    itemsList << new TimeListItem(14,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),7,730);
    itemsList << new TimeListItem(15,tr(""),7,800);

    startTime.setHMS(8,0,0);
    itemsList << new TimeListItem(16,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),8,830);
    itemsList << new TimeListItem(17,tr(""),8,900);

    startTime.setHMS(9,0,0);
    itemsList << new TimeListItem(18,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),9,930);
    itemsList << new TimeListItem(19,tr(""),9,1000);

    startTime.setHMS(10,0,0);
    itemsList << new TimeListItem(20,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),10,1030);
    itemsList << new TimeListItem(21,tr(""),10,1100);

    startTime.setHMS(11,0,0);
    itemsList << new TimeListItem(22,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),11,1130);
    itemsList << new TimeListItem(23,tr(""),11,1200);

    startTime.setHMS(12,0,0);
    itemsList << new TimeListItem(24,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),12,1230);
    itemsList << new TimeListItem(25,tr(""),12,1300);

    startTime.setHMS(13,0,0);
    itemsList << new TimeListItem(26,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),13,1330);
    itemsList << new TimeListItem(27,tr(""),13,1400);

    startTime.setHMS(14,0,0);
    itemsList << new TimeListItem(28,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),14,1430);
    itemsList << new TimeListItem(29,tr(""),14,1500);

    startTime.setHMS(15,0,0);
    itemsList << new TimeListItem(30,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),15,1530);
    itemsList << new TimeListItem(31,tr(""),15,1600);

    startTime.setHMS(16,0,0);
    itemsList << new TimeListItem(32,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),16,1630);
    itemsList << new TimeListItem(33,tr(""),16,1700);

    startTime.setHMS(17,0,0);
    itemsList << new TimeListItem(34,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),17,1730);
    itemsList << new TimeListItem(35,tr(""),17,1800);

    startTime.setHMS(18,0,0);
    itemsList << new TimeListItem(36,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),18,1830);
    itemsList << new TimeListItem(37,tr(""),18,1900);

    startTime.setHMS(19,0,0);
    itemsList << new TimeListItem(38,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),19,1930);
    itemsList << new TimeListItem(39,tr(""),19,2000);

    startTime.setHMS(20,0,0);
    itemsList << new TimeListItem(40,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),20,2030);
    itemsList << new TimeListItem(41,tr(""),20,2100);

    startTime.setHMS(21,0,0);
    itemsList << new TimeListItem(42,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),21,2130);
    itemsList << new TimeListItem(43,tr(""),21,2200);

    startTime.setHMS(22,0,0);
    itemsList << new TimeListItem(44,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),22,2230);
    itemsList << new TimeListItem(45,tr(""),22,2300);

    startTime.setHMS(23,0,0);
    itemsList << new TimeListItem(46,utilities.getTimeInFormat(startTime,UtilMethods::ETimeSystemLocale),23,2330);
    itemsList << new TimeListItem(47,tr(""),23,2300);
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
    if(!itemsList.isEmpty())
    {
        beginRemoveRows(QModelIndex(), 0, itemsList.count()-1);
        for(int i = 0; i < itemsList.count(); i++)
            delete itemsList[i];
        itemsList.clear();
        endRemoveRows();
    }
}


QML_DECLARE_TYPE(TimeListModel);
