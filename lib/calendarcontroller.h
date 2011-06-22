/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARCONTROLLER_H
#define CALENDARCONTROLLER_H

#include <kdatetime.h>
#include <duration.h>
#include <QDir>
#include <QDebug>
#include <QtDeclarative/qdeclarative.h>
#include <QObject>
#include "ekcal/ekcal-storage.h"
#include <incidenceio.h>
#include  <utilmethods.h>

class CalendarController : public QObject
{
    Q_OBJECT

public:
    CalendarController(QObject *parent = 0);
    ~CalendarController();

    Q_INVOKABLE bool addModifyEvent(int actionType, QObject* eventIO);
    Q_INVOKABLE bool deleteEvent(const QString& eventUId);
    Q_INVOKABLE QList<IncidenceIO*> getEventsFromDB(int listType,
                                                   const KDateTime& startDate = KDateTime::currentLocalDateTime(),
                                                   const KDateTime& endDate = KDateTime::currentLocalDateTime(),
                                                   const QString& uid = "");
    Q_INVOKABLE QObject* getEventForEdit(const QString& uid);
    Q_INVOKABLE QDateTime getEventPositionInView(const QString& uid);

signals:
    void dbLoaded();
    void dbChanged();

private:
    bool setUpCalendars();
    void handleRepeat(const KCalCore::Event::Ptr& coreEventPtr, IncidenceIO* eventIO);
    void handleEventTime(const KCalCore::Event::Ptr& coreEventPtr, IncidenceIO* eventIO);
    void handleAlarm(const KCalCore::Alarm::Ptr& eventAlarm, IncidenceIO* eventIO);


private:    
    KCalCore::Calendar::Ptr calendar;
    eKCal::EStorage::Ptr storage;
};

#endif // CALENDARCONTROLLER_H
