/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef TIMELISTMODEL_H
#define TIMELISTMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include "utilmethods.h"
#include "incidenceio.h"
#include "calendarcontroller.h"

class TimeListItem : QObject{
    Q_OBJECT
public:
    TimeListItem(int index, QString timeVal, int startHr, int endHr, QObject *parent = 0);

    enum TimeListItemRoles {
        Index = Qt::UserRole+1,
        TimeVal = Qt::UserRole+2,
        StartHr = Qt::UserRole+3,
        EndHr = Qt::UserRole+4
    };

    int index;
    int startHr;
    int endHr;
    QString timeVal;
};

class TimeListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    TimeListModel(QObject *parent = 0);
    ~TimeListModel();

    int getCount() const
        { return itemsList.count(); }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<TimeListItem*> itemsList;
};

#endif // TIMELISTMODEL_H
