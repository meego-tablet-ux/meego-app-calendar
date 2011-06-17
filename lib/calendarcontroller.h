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
    Q_OBJECT;

public:
    CalendarController(QObject *parent = 0);
    ~CalendarController();

    Q_INVOKABLE bool addModifyEvent(int actionType, QObject* eventIO);
    Q_INVOKABLE bool deleteEvent(QString eventUId);
    Q_INVOKABLE QList<IncidenceIO> getEventsFromDB(int listType,KDateTime startDate=KDateTime::currentLocalDateTime(), KDateTime endDate=KDateTime::currentLocalDateTime(),const QString uid="");
    Q_INVOKABLE QObject* getEventForEdit(const QString uid);
    Q_INVOKABLE QDateTime getEventPositonInView(const QString uid);

signals:
    void dbLoaded();
    void dbChanged();

public slots:
    void emitDbLoaded();
    void emitDbChanged();


private:
    bool setUpCalendars();
    void handleRepeat(KCalCore::Event::Ptr coreEventPtr,const IncidenceIO& eventIO);
    void handleEventTime(KCalCore::Event::Ptr coreEventPtr,const IncidenceIO& eventIO);
    void handleAlarm(const IncidenceIO& eventIO,KCalCore::Alarm::Ptr eventAlarm);    


private:    
    KCalCore::Calendar::Ptr calendar;
    eKCal::EStorage::Ptr storage;

    //Notebook *notebook;
    QString nUid;
};

#endif // CALENDARCONTROLLER_H
