/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "components.h"
#include "calendarcontroller.h"
#include "incidenceio.h"
#include "utilmethods.h"
#include "repeatlistmodel.h"
#include "alarmlistmodel.h"
#include "viewcalendarmodel.h"
#include "calendarweekmodel.h"
#include "timelistmodel.h"
#include "dayviewmodel.h"
#include "calendarmonthmodel.h"
#include "calendarlistmodel.h"
#include "weekviewmodel.h"
#include "eventsdatamodel.h"

components::components ()
{

}

void components::registerTypes(const char *uri)
{
    qmlRegisterType<IncidenceIO>(uri, 0, 1, "IncidenceIO");
    qmlRegisterType<UtilMethods>(uri, 0, 1, "UtilMethods");
    qmlRegisterType<CalendarController>(uri, 0, 1, "CalendarController");
    qmlRegisterType<RepeatListModel>(uri, 0, 1, "RepeatListModel");
    qmlRegisterType<RepeatEndListModel>(uri, 0, 1, "RepeatEndListModel");
    qmlRegisterType<AlarmListModel>(uri, 0, 1, "AlarmListModel");
    qmlRegisterType<ViewCalendarModel>(uri, 0, 1, "ViewCalendarModel");
    qmlRegisterType<CalendarWeekModel>(uri, 0, 1, "CalendarWeekModel");
    qmlRegisterType<TimeListModel>(uri, 0, 1, "TimeListModel");
    qmlRegisterType<DayViewModel>(uri, 0, 1, "DayViewModel");
    qmlRegisterType<CalendarMonthModel>(uri, 0, 1, "CalendarMonthModel");
    qmlRegisterType<CalendarListModel>(uri, 0, 1, "CalendarListModel");
    qmlRegisterType<WeekViewModel>(uri, 0, 1, "WeekViewModel");
    qmlRegisterType<EventsDataModel>(uri, 0, 1, "EventsDataModel");
}

Q_EXPORT_PLUGIN(components);
