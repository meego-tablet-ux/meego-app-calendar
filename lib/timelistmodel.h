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
#include "dayviewmodel.h"
#include "eventsdatamodel.h"

class TimeListItem : QObject{
    Q_OBJECT
public:
    TimeListItem(int index, QTime timeVal, int startHr, int endHr, EventsDataModel *modelData, QObject *parent = 0);

    enum TimeListItemRoles {
        Index = Qt::UserRole+1,
        TimeVal = Qt::UserRole+2,
        StartHr = Qt::UserRole+3,
        EndHr = Qt::UserRole+4,
        DataModel = Qt::UserRole+5
    };

    int index;
    int startHr;
    int endHr;
    QTime timeVal;
    EventsDataModel *dataModel;

};

class TimeListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);
    Q_PROPERTY(QDate dateVal READ getDateVal WRITE setDateVal);

public:
    TimeListModel(QObject *parent = 0);
    ~TimeListModel();

    int getCount() const
        { return 48;  } //itemsList.count();

    void setDateVal(QDate dateValue) {
        dateVal = dateValue;
        loadCurrentDayModel();
        return;
    }

    QDate getDateVal() const {
        return dateVal;
    }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();
    Q_INVOKABLE void loadGivenDayModel(QDate nextDate);
    void sortEventList();

protected:
    QList<TimeListItem*> itemsList;
    QList<CalendarDataItem*> eventsList;
    QMultiHash<int,CalendarDataItem*> indexHash;
    QDate dateVal;
    void loadValues();
    void loadCurrentDayModel();
    void assignDisplayValues();
    int computeStartIndex(QTime startTime);
    EventsDataModel* getDataModelAtIndex(int index);
};

#endif // TIMELISTMODEL_H
