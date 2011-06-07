/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef CALENDARDBSINGLETON_H
#define CALENDARDBSINGLETON_H

#include <extendedcalendar.h>
#include <extendedstorage.h>
#include <meegocalendarobserver.h>

#include "ekcal/ekcal-storage.h"
#include <qdebug.h>

using namespace mKCal;
using namespace eKCal;


class CalendarDBSingleton : public QObject
{
      Q_OBJECT
public:
    static CalendarDBSingleton* instance();
    static KCalCore::Calendar::Ptr& calendarPtr();
    static eKCal::EStorage::Ptr& storagePtr();

protected:

    CalendarDBSingleton();
    CalendarDBSingleton(const CalendarDBSingleton&);
    CalendarDBSingleton& operator= (const CalendarDBSingleton&);

private:

    static CalendarDBSingleton* pinstance;
    static KCalCore::Calendar::Ptr calendar;
    static eKCal::EStorage::Ptr storage;
    static MeeGoCalendarObserver *observer;
} ;

#endif //CALENDARDBSINGLETON_H

