/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARDATAITEM_H
#define CALENDARDATAITEM_H
#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include <kdatetime.h>
#include <QDebug>
#include "incidenceio.h"
class CalendarDataItem : QObject{
    Q_OBJECT
public:
    CalendarDataItem(int index, const IncidenceIO& fromObj, QObject *parent = 0);
    CalendarDataItem(const CalendarDataItem& fromObj);

    enum CalendarDataItemRoles
    {
        Index = Qt::UserRole+1,
        Type = Qt::UserRole+2,
        Uid = Qt::UserRole+3,
        Description = Qt::UserRole+4,
        Summary = Qt::UserRole+5,
        Location = Qt::UserRole+6,
        AllDay = Qt::UserRole+7,
        RepeatType = Qt::UserRole+8,
        RepeatEndType = Qt::UserRole+9,
        RepeatCount = Qt::UserRole+10,
        StartDate = Qt::UserRole+11,
        StartTime = Qt::UserRole+12,
        EndDate = Qt::UserRole+13,
        EndTime = Qt::UserRole+14,
        RepeatEndDate = Qt::UserRole+15,
        RepeatEndTime = Qt::UserRole+16,
        AlarmType = Qt::UserRole+17,
        AlarmDate = Qt::UserRole+18,
        AlarmTime = Qt::UserRole+19,
        ZoneOffset = Qt::UserRole+20,
        XUnits = Qt::UserRole+21,
        YUnits = Qt::UserRole+22,
        HeightUnits = Qt::UserRole+23,
        WidthUnits = Qt::UserRole+24,
        StartIndex = Qt::UserRole+25,
        DayIndex = Qt::UserRole+26,
        ZoneName = Qt::UserRole+27
    };

    int index;
    int type;
    QString uid;
    QString description;
    QString summary;
    QString location;
    bool allDay;
    int repeatType;
    int repeatEndType;
    int repeatCount;
    QDate startDate;
    QTime startTime;
    QDate endDate;
    QTime endTime;
    QDate repeatEndDate;
    QTime repeatEndTime;
    int alarmType;
    QDate alarmDate;
    QTime alarmTime;
    int zoneOffset;
    QString zoneName;

    int xUnits;
    int yUnits;
    int heightUnits;
    double widthUnits;
    int startIndex;
    int dayIndex;
};


#endif // CALENDARDATAITEM_H
