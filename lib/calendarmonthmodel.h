/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARMONTHMODEL_H
#define CALENDARMONTHMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>

class MonthItem : QObject{
    Q_OBJECT
public:
    MonthItem(int index, QString dateValString, QDate coreDateVal, bool isMonthDay,bool isCurrentDay,QString event1="",QString event2="",QString event3="",int eventsCount=0,QObject *parent = 0);

    enum RepeatItemRoles {
        Index = Qt::UserRole+1,
        DateValString = Qt::UserRole+2,
        CoreDateVal = Qt::UserRole+3,
        IsMonthDay = Qt::UserRole+4,
        IsCurrentDay = Qt::UserRole+5,
        Event1 = Qt::UserRole+6,
        Event2 = Qt::UserRole+7,
        Event3 = Qt::UserRole+8,
        EventsCount = Qt::UserRole+9
    };

    int index;
    QString dateValString;
    QDate coreDateVal;
    bool isMonthDay;
    bool isCurrentDay;
    QString event1;
    QString event2;
    QString event3;
    int eventsCount;

};



class CalendarMonthModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);
    Q_PROPERTY(QDate dateVal READ getDateVal WRITE setDateVal);
    Q_PROPERTY(int weekStartDay READ getWeekStartDay WRITE setWeekStartDay);


public:
    CalendarMonthModel(QObject *parent = 0);
    ~CalendarMonthModel();

    int getCount() const
        { return itemsList.count(); }

    void setDateVal(QDate dateValue) {
        dateVal = dateValue;
        loadCurrentMonthValues();
        return;
    }

    QDate getDateVal() const {
        return dateVal;
    }

    void setWeekStartDay(const int startDay)
    {
        weekStartDay = startDay;
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
    Q_INVOKABLE void loadCurrentMonthValues();
    Q_INVOKABLE void loadGivenMonthValuesFromOffset(QDate dateInFocus);

signals:
     void dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight);

protected:
    QList<MonthItem *> itemsList;
    QDate dateVal;
    int weekStartDay;
};

#endif // CALENDARMONTHMODEL_H
