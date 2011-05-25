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

using namespace mKCal;

class CalendarDBSingleton
{
public:
    static CalendarDBSingleton* instance();
    static ExtendedCalendar::Ptr& calendarPtr();
    static ExtendedStorage::Ptr& storagePtr();

protected:

    CalendarDBSingleton();
    CalendarDBSingleton(const CalendarDBSingleton&);
    CalendarDBSingleton& operator= (const CalendarDBSingleton&);

private:

    static CalendarDBSingleton* pinstance;
    static ExtendedCalendar::Ptr calendar;
    static ExtendedStorage::Ptr storage;
};

#endif //CALENDARDBSINGLETON_H
