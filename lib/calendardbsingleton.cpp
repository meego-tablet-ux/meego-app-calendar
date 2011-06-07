/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendardbsingleton.h"

CalendarDBSingleton* CalendarDBSingleton::pinstance = 0;// pointer initialized
eKCal::EStorage::Ptr CalendarDBSingleton::storage = eKCal::EStorage::defaultStorage(KCalCore::IncidenceBase::TypeEvent);
KCalCore::Calendar::Ptr CalendarDBSingleton::calendar = storage->calendar();
MeeGoCalendarObserver *observer = new MeeGoCalendarObserver(CalendarDBSingleton::calendarPtr());

CalendarDBSingleton* CalendarDBSingleton::instance()
{
    if (pinstance == 0) // true when called first time
    {
        pinstance = new CalendarDBSingleton(); // create sole instance
    }
    return pinstance; // address of sole  instance
}

CalendarDBSingleton::CalendarDBSingleton()
{
    calendar->registerObserver(observer);
    storage->registerObserver(observer);
    storage->startLoading();
}

KCalCore::Calendar::Ptr& CalendarDBSingleton::calendarPtr()
{
    return calendar;
}

eKCal::EStorage::Ptr& CalendarDBSingleton::storagePtr()
{
    return storage;
}

