/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARLISTMODEL_H
#define CALENDARLISTMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include "utilmethods.h"
#include "incidenceio.h"
#include "calendardataitem.h"
#include "calendarcontroller.h"

class FilterTerminate;

class CalendarListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);
    Q_PROPERTY(int modelType READ getModelType WRITE setModelType);

public:
    CalendarListModel(QObject *parent = 0);

    ~CalendarListModel();

    int getCount() const
        { return itemsDisplay.count(); }

    int getModelType() const
        { return modelType; }

    void setModelType(const int type)
        {
          modelType = type;
        }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();
    Q_INVOKABLE void refresh();

    void loadAllEventsSorted();

public slots:
    void filterOut(QString filter, FilterTerminate *terminateObject = 0);


signals:
     void dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight);

protected:
    QList<CalendarDataItem*> itemsList;
    QList<CalendarDataItem*> itemsDisplay;
    int modelType;
};


#endif // CALENDARLISTMODEL_H
