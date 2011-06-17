/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARDBSINGLETON_H
#define CALENDARDBSINGLETON_H

#include <meegocalendarobserver.h>
#include "ekcal/ekcal-storage.h"
#include <qdebug.h>

using namespace eKCal;

class CalendarDBSingleton : public QObject
{
      Q_OBJECT
public:
    static CalendarDBSingleton* instance();
    KCalCore::Calendar::Ptr& calendarPtr();
    eKCal::EStorage::Ptr& storagePtr();

signals:
    void dbLoaded();
    void dbChanged();

protected:
    CalendarDBSingleton();
    ~CalendarDBSingleton();
    CalendarDBSingleton(const CalendarDBSingleton&);
    CalendarDBSingleton& operator= (const CalendarDBSingleton&);

private:
    static CalendarDBSingleton* pinstance;
    MeeGoCalendarObserver *myObserver;
    KCalCore::Calendar::Ptr calendar;
    eKCal::EStorage::Ptr storage;
} ;

#endif //CALENDARDBSINGLETON_H

