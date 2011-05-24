/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendardbsingleton.h"

CalendarDBSingleton* CalendarDBSingleton::pinstance = 0;// pointer initialized
ExtendedCalendar::Ptr CalendarDBSingleton::calendar = ExtendedCalendar::Ptr ( new ExtendedCalendar(KDateTime::Spec::LocalZone()));
ExtendedStorage::Ptr CalendarDBSingleton::storage = calendar->defaultStorage(calendar );

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
    storage->open();
}

ExtendedCalendar::Ptr& CalendarDBSingleton::calendarPtr()
{
    return calendar;
}

ExtendedStorage::Ptr& CalendarDBSingleton::storagePtr()
{
    return storage;
}

