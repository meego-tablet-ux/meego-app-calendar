/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef INCIDENCEIO_H
#define INCIDENCEIO_H

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <string>
#include <kdatetime.h>
#include <ksystemtimezone.h>
#include <QDebug>
#include <QtDeclarative/qdeclarative.h>
#include <QObject>
#include <utilmethods.h>

using namespace std;


class IncidenceIO : public QObject
{
    Q_OBJECT;

public:
    explicit IncidenceIO(QObject *parent = 0);
    ~IncidenceIO();

public:
    //Getters and Setters
    Q_PROPERTY (int type READ getType WRITE setType);
    Q_PROPERTY (QString uid READ getUid WRITE setUid);
    Q_PROPERTY (QString description READ getDescription WRITE setDescription);
    Q_PROPERTY (QString summary READ getSummary WRITE setSummary);
    Q_PROPERTY (QString location READ getLocation WRITE setLocation);
    Q_PROPERTY (bool allDay READ isAllDay WRITE setAllDay);
    Q_PROPERTY (int repeatType READ getRepeatType WRITE setRepeatType);
    Q_PROPERTY (int repeatEndType READ getRepeatEndType WRITE setRepeatEndType);
    Q_PROPERTY (int repeatCount READ getRepeatCount WRITE setRepeatCount);
    Q_PROPERTY (KDateTime startDateTime READ getStartDateTime WRITE setStartDateTime);
    Q_PROPERTY (KDateTime endDateTime READ getEndDateTime WRITE setEndDateTime);
    Q_PROPERTY (KDateTime repeatEndDateTime READ getRepeatEndDateTime WRITE setRepeatEndDateTime);
    Q_PROPERTY (int alarmType READ getAlarmType WRITE setAlarmType);
    Q_PROPERTY (int zoneOffset READ getTimeZoneOffset WRITE setTimeZoneOffset);
    Q_PROPERTY (QString zoneName READ getTimeZoneName WRITE setTimeZoneName);


    int getType() const;
    QString getUid() const;
    QString getDescription() const;
    QString getSummary() const;
    QString getLocation() const;
    bool isAllDay() const;
    int getRepeatType() const;
    int getRepeatEndType() const;
    int getRepeatCount() const;
    KDateTime getStartDateTime() const;
    KDateTime getEndDateTime() const;
    KDateTime getRepeatEndDateTime() const;
    int getAlarmType() const;
    KDateTime getAlarmDateTime() const;
    int getTimeZoneOffset() const;
    QString getTimeZoneName() const;
    Q_INVOKABLE QDate getStartDateFromKDT();
    Q_INVOKABLE QTime getStartTimeFromKDT();
    Q_INVOKABLE QDate getEndDateFromKDT();
    Q_INVOKABLE QTime getEndTimeFromKDT();
    Q_INVOKABLE QDate getRepeatEndDateFromKDT();
    Q_INVOKABLE QTime getRepeatEndTimeFromKDT();

    void setType(const int type);
    void setUid(const QString  uid);
    void setDescription(const QString description);
    void setSummary(const QString summary);
    void setLocation(const QString location);
    void setAllDay(const bool allDay);
    void setRepeatType(const int repeatType);
    void setRepeatEndType(const int repeatEndType);
    void setRepeatCount(const int repeatCount);
    void setStartDateTime(const KDateTime startDateTime);
    Q_INVOKABLE void setStartDateTime(const QDate startDate, const QTime startTime, QString tzName);
    void setEndDateTime(const KDateTime endDateTime);
    Q_INVOKABLE void setEndDateTime(const QDate endDate, const QTime endTime, QString tzName);
    void setRepeatEndDateTime(const KDateTime repeatEndDateTime);
    Q_INVOKABLE void setRepeatEndDateTime(const QDate repeatEndDate, const QTime repeatEndTime, QString tzName);
    void setAlarmType(const int alarmType);
    void setAlarmDateTime(const KDateTime alarmDateTime);
    void setTimeZoneOffset(const int zoneOffset);
    void setTimeZoneName(const QString zoneName);


    void printIncidence();

private:
    int type;
    QString uid;
    QString description;
    QString summary;
    QString location;
    bool allDay;
    int repeatType;
    int repeatEndType;
    int repeatCount;
    KDateTime startDateTime;
    KDateTime endDateTime;
    KDateTime repeatEndDateTime;
    int alarmType;
    KDateTime alarmDateTime;
    int zoneOffset;
    QString zoneName;
};

#endif // INCIDENCEIO_H
