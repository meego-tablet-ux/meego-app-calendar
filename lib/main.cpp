/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include <QtCore/QCoreApplication>
#include "calendarcontroller.h"
#include "incidenceio.h"
#include "utilmethods.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    CalendarController *controller = CalendarController::getInstance();

    IncidenceIO eventIO;
    bool success = false;

    //***************ADD EVENT****************
///*
    eventIO.setType(EEvent);
    eventIO.setUid("Uid");
    eventIO.setDescription("Description");
    eventIO.setSummary("Summary");
    eventIO.setLocation("Location");
    eventIO.setAllDay(false);
    eventIO.setRepeatType(EEveryWeek);
    eventIO.setRepeatEndDateTime(KDateTime::currentLocalDateTime().addMonths(12).addSecs(60*60*4));
    eventIO.setStartDateTime(KDateTime::currentLocalDateTime().addDays(1).addSecs(60*60*4));
    eventIO.setEndDateTime(KDateTime::currentLocalDateTime().addDays(1).addSecs(60*60*5));
    eventIO.setAlarmType(E30MinB4);
    success = controller->addModifyEvent(EAddEvent,eventIO);
    if(success)
        qDebug()<<"************************Added the event**************"<<"\n";
    else
        qDebug()<<"************************Failed Add event**************"<<"\n";
//*/

    //***************DELETE EVENT****************
    /*success = controller->deleteEvent(QString("UID:76cb38f7-aa71-43ba-9251-c3a934ff792e"));
    if(success)
        qDebug()<<"************************Deleted the event**************"<<"\n";
    else
        qDebug()<<"************************Failed Delete event**************"<<"\n";
    */

    //***************MODIFY EVENT****************
/*
    eventIO.setType(EEvent);
    eventIO.setUid(QString("361e01c2-58ff-4110-8009-809a5e568a3c"));
    eventIO.setDescription("New Description");
    eventIO.setSummary("New Summary");
    eventIO.setLocation("New Location");
    eventIO.setAllDay(false);
    eventIO.setRepeatType(ENoRepeat);
    eventIO.setStartDateTime(KDateTime::currentLocalDateTime().addDays(7).addSecs(60*60*4));
    eventIO.setEndDateTime(KDateTime::currentLocalDateTime().addDays(7).addSecs(60*60*5));
    eventIO.setAlarmType(E2DaysB4);
    success = controller->addModifyEvent(EModifyEvent,eventIO);

    if(success)
        qDebug()<<"************************Modified the event**************"<<"\n";
    else
        qDebug()<<"************************Failed Modify event**************"<<"\n";

    */

    //*********************PRINT EVENTS*********************
    controller->getEventsFromDB(EAll);
    //controller->getEventsFromDB(EDayList,KDateTime::currentLocalDateTime().addDays(1),KDateTime::currentLocalDateTime().addDays(1));

    exit(0);
    return a.exec();
}
