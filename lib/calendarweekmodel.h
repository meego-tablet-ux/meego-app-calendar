/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARWEEKMODEL_H
#define CALENDARWEEKMODEL_H
#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>

class DateItem : QObject{
    Q_OBJECT
public:
    DateItem(int index, QString dateValString, QDate coreDateVal, QObject *parent = 0);

    enum RepeatItemRoles {
        Index = Qt::UserRole+1,
        DateValString = Qt::UserRole+2,
        CoreDateVal = Qt::UserRole+3
    };

    int index;
    QString dateValString;
    QDate coreDateVal;

};



class CalendarWeekModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);
    Q_PROPERTY(int weekStartIndex READ getWeekStartDay WRITE setWeekStartDay);

public:
    CalendarWeekModel(QObject *parent = 0);
    ~CalendarWeekModel();

    int getCount() const
    { return itemsList.count(); }

    void setWeekStartDay(const int startDay)
    {
        weekStartDay = startDay;
        //loadCurrentWeekValues();
    }

    int getWeekStartDay()
    {
        return weekStartDay;
    }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();
    Q_INVOKABLE void loadCurrentWeekValues();
    Q_INVOKABLE void loadGivenWeekValuesFromOffset(QDate currDateInFocus,int offSetFromCurrentWeek);
    Q_INVOKABLE void loadGivenWeekValuesFromDate(QDate fromDate);

signals:
     void dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight);

protected:
    QList<DateItem *> itemsList;
    int weekStartDay;

};


#endif // CALENDARWEEKMODEL_H
