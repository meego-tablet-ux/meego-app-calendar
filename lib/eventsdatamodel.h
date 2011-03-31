/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef EVENTSDATAMODEL_H
#define EVENTSDATAMODEL_H
#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include "utilmethods.h"
#include "incidenceio.h"
#include "calendardataitem.h"
#include "calendarcontroller.h"

class EventsDataModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    explicit EventsDataModel(int count, QList<CalendarDataItem*> dataList,QObject *parent = 0);
    EventsDataModel(QObject *parent = 0);

    ~EventsDataModel();

    int getCount() const
        { return count; }


    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<CalendarDataItem*> itemsList;
    int count;
};

Q_DECLARE_METATYPE(EventsDataModel*);

#endif // EVENTSDATAMODEL_H
