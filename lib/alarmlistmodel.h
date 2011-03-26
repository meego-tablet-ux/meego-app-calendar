/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef ALARMLISTMODEL_H
#define ALARMLISTMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>

class AlarmItem : QObject{
    Q_OBJECT
public:
    AlarmItem(int type, QString desc, QObject *parent = 0);

    enum AlarmItemRoles {
        Type = Qt::UserRole+1,
        Description = Qt::UserRole+2
    };

    int type;
    QString description;

};

class AlarmListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    AlarmListModel(QObject *parent = 0);
    ~AlarmListModel();

    int getCount() const
        { return itemsList.count(); }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<AlarmItem *> itemsList;

};


#endif // ALARMLISTMODEL_H
