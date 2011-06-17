/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendardbsingleton.h"

CalendarDBSingleton* CalendarDBSingleton::pinstance = 0;// pointer initialized

CalendarDBSingleton* CalendarDBSingleton::instance()
{
    if (pinstance == 0) // true when called first time
    {
        pinstance = new CalendarDBSingleton(); // create sole instance
    }
    return pinstance; // address of sole  instance
}

CalendarDBSingleton::~CalendarDBSingleton()
{
    if(pinstance != NULL) {
        delete pinstance;
        pinstance = NULL;
    }
    if(myObserver != NULL) {
        delete myObserver;
        myObserver = NULL;
    }
}

CalendarDBSingleton::CalendarDBSingleton()
{
    storage = eKCal::EStorage::defaultStorage(KCalCore::IncidenceBase::TypeEvent);
    calendar = storage->calendar();
    myObserver = new MeeGoCalendarObserver(CalendarDBSingleton::calendarPtr());
    bool ok;
    ok = connect(myObserver, SIGNAL(dbReady()), this, SIGNAL(dbLoaded()));
    Q_ASSERT(ok);
    ok = connect(myObserver, SIGNAL(dbChanged()), this, SIGNAL(dbChanged()));
    Q_ASSERT(ok);
    calendar->registerObserver(myObserver);
    storage->registerObserver(myObserver);
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
