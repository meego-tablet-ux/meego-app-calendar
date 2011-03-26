/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef DAYVIEWMODEL_H
#define DAYVIEWMODEL_H
#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include "utilmethods.h"
#include "incidenceio.h"
#include "calendardataitem.h"
#include "calendarcontroller.h"

class DayViewModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);
    Q_PROPERTY(int modelType READ getModelType WRITE setModelType);

public:
    DayViewModel(QObject *parent = 0);

    ~DayViewModel();

    int getCount() const
        { return itemsList.count(); }

    int getModelType() const
        { return modelType; }

    void setModelType(const int type)
        {
          qDebug()<<"model set to="<<type;
          modelType = type;
          loadCurrentDayValues();
        }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

    void loadCurrentDayValues();
    void assignDisplayValues();
    int computeStartIndex(QTime startTime);
    Q_INVOKABLE void loadGivenDayModel(QDate nextDate);

signals:
     void dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight);

protected:
    QList<CalendarDataItem*> itemsList;
    int modelType;
};

#endif // DAYVIEWMODEL_H
