/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendarcontroller.h"
#include "calendardbsingleton.h"
#include <stdlib.h>
#include <exception>
#include <alarm.h>
#include <icalformat.h>
#include <QDebug>

using namespace std;

static CalendarDBSingleton *instance = NULL;

CalendarController::CalendarController(QObject *parent) : QObject(parent)
{
    setUpCalendars();
}

//Destructor
CalendarController::~CalendarController()
{
}

bool CalendarController::setUpCalendars()
{
    bool setUpStatus=true;
    try {
        instance = CalendarDBSingleton::instance();
        storage = instance->storagePtr();
        if(!storage) throw exception();
        calendar = instance->calendarPtr();
        if(!calendar) throw exception();
        bool ok;
        ok = connect(instance, SIGNAL(dbLoaded()), this, SIGNAL(dbLoaded()));
        Q_ASSERT(ok);
        ok = connect(instance, SIGNAL(dbChanged()), this, SIGNAL(dbChanged()));
        Q_ASSERT(ok);


    } catch (exception &e) {
        setUpStatus=false;
        qDebug()<<e.what();
    }
    return setUpStatus;
}


/**
  * This method adds the Event to the database
  * @param eventIO, The IncidenceIO object which has all the
  * details the user enters on the New Event form.
  * @return returns true if added successfully, else false
  */
bool CalendarController::addModifyEvent(int actionType, QObject* eventIOObj)
 {
    bool success = true;
    IncidenceIO eventIO(*(IncidenceIO*)(eventIOObj));

   try {
        KCalCore::Event::Ptr coreEvent;
        if(actionType == EAddEvent) {
            coreEvent = KCalCore::Event::Ptr(new KCalCore::Event());
        } else if(actionType == EModifyEvent) {
            coreEvent = calendar->event(eventIO.getUid());
        }
        if(!coreEvent) {
            return false;
        }
        coreEvent->setSummary(eventIO.getSummary());
        coreEvent->setDescription(eventIO.getDescription());
        coreEvent->setLocation(eventIO.getLocation());

       //handle Event time
        handleEventTime(coreEvent,eventIO);

        //handle repeat
        handleRepeat(coreEvent,eventIO);

        //handle alarm processing
        if(eventIO.getAlarmType()!= ENoAlarm) {
            coreEvent->clearAlarms();
            KCalCore::Alarm::Ptr eventAlarm(coreEvent->newAlarm());
            handleAlarm(eventIO,eventAlarm);
        }

        if(actionType == EAddEvent) {
            calendar->addEvent(coreEvent); //,notebook->uid()
        } else if(actionType == EModifyEvent) {
            coreEvent->setRevision(coreEvent->revision()+1);
        }
        storage->save();
    } catch (exception &e) {
        success = false;
        qDebug()<< e.what();
    }

    return success;
 }

/**
  * This method deletes the event from the Calendar and the Storage
  * @param eventUid the unique identifier of the Event
  * @return true of deleted successfully,else false
  */
bool CalendarController::deleteEvent(const QString& eventUid)
{
    bool deleted = true;
    try {
        KCalCore::Event::Ptr coreEvent = calendar->event(eventUid);
        if(coreEvent) {
            deleted = calendar->deleteEvent(coreEvent);
            storage->save();
        }

    }catch(exception &e){
        deleted = false;
        qDebug()<< e.what();
    }
    return deleted;
}

/**
  * Method to set the recurrence of the event. This method is called by addEvent method
  * @param coreEvent, event whose recurrence has to be set
  * @param eventIO, the IO object from the UI
  */
void CalendarController::handleRepeat(const KCalCore::Event::Ptr& coreEventPtr,
                                      const IncidenceIO&  eventIO)
{
   KCalCore::Recurrence *eventRecurrence = coreEventPtr->recurrence();
   try {
        if(eventIO.getRepeatType()==ENoRepeat){
            KCalCore::RecurrenceRule::List rList = eventRecurrence->rRules();
            foreach(KCalCore::RecurrenceRule* rule, rList) {
               eventRecurrence->deleteRRule(rule);
            }
        } else {
            switch(eventIO.getRepeatType()) {

                case EEveryDay: {
                        eventRecurrence->setDaily(1);
                        break;
                }
                case EEveryWeek: {
                        eventRecurrence->setWeekly(1);
                        break;
                }
                case EEvery2Weeks: {
                        eventRecurrence->setWeekly(2,EMonday);
                        break;
                }
                case EEveryMonth: {
                        eventRecurrence->setMonthly(1);
                        break;
                }
                case EEveryYear: {
                        eventRecurrence->setYearly(1);
                        break;
                }
                case EOtherRepeat: {
                        qDebug()<<"Not Sure At this moment";
                        eventRecurrence->setWeekly(1);
                        break;
                }
            default: {
                    eventRecurrence->clear();
                    break;
                }
            }//end of switch

            if(eventIO.getRepeatEndType() == UtilMethods::EForNTimes) {
                eventRecurrence->setDuration(eventIO.getRepeatCount());
            } else if(eventIO.getRepeatEndType() == UtilMethods::EAfterDate) {
                eventRecurrence->setEndDateTime(eventIO.getRepeatEndDateTime());
            }

        }//end of else
    } catch (exception &e) {
        qDebug()<<e.what();
    }
    return;
}

/**
  * This method handles allday flag in an event
  */
//Might need some additional processing.
//So put the logic seperately into a method instead of cluttering the addEvent method
void CalendarController::handleEventTime(const KCalCore::Event::Ptr& coreEventPtr,
                                         const IncidenceIO& eventIO)
{
    try{
        coreEventPtr->setDtStart(eventIO.getStartDateTime());
        if(eventIO.isAllDay()) {
            coreEventPtr->setAllDay(true);
            if(coreEventPtr->hasEndDate()) { coreEventPtr->setDtEnd(eventIO.getStartDateTime());}
        } else {
            coreEventPtr->setAllDay(false);
            coreEventPtr->setDtEnd(eventIO.getEndDateTime());
        }
    } catch(exception &e) {
        qDebug()<<e.what();
    }
    return;
}


/**
  * This method handles setting alarm in an event
  * @param eventIO, the IncidenceIO object from the UI
  * @param eventAlarm, the KCalCore::Alarm object with its parent set
  */
void CalendarController::handleAlarm(const IncidenceIO&  eventIO,
                                     const KCalCore::Alarm::Ptr& eventAlarm)
{
    try{
        eventAlarm->setText(eventIO.getSummary());
        eventAlarm->setDisplayAlarm(eventIO.getSummary());
        eventAlarm->setEnabled(true);

        switch(eventIO.getAlarmType()) {
            case E10MinB4:
            default:
                    //snooze with 5min interval
                    eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                    eventAlarm->setRepeatCount(1);
                    eventAlarm->setStartOffset( KCalCore::Duration( -60*10 ) );
                    break;
            case E15MinB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration( -60*15 ) );
                    break;
            }
            case E30MinB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration( -60*30 ) );
                break;
            }
            case E1HrB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration( -60*60 ) );
                break;
            }
            case E2HrsB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration( -60*120 ) );
                break;
            }
            case E1DayB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration(-1,KCalCore::Duration::Days) );
                break;
            }
            case E2DaysB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration(-2,KCalCore::Duration::Days) );
                break;
            }
            case E1WeekB4: {
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration(-7,KCalCore::Duration::Days) );
                break;
            }
            case EOtherAlarm: {
                qDebug()<<"Not Sure At this moment";
                eventAlarm->setSnoozeTime( KCalCore::Duration( 60*5 ) );
                eventAlarm->setRepeatCount(1);
                eventAlarm->setStartOffset( KCalCore::Duration( -60*15 ) );
                    break;
                }
        }//end of switch
        qDebug()<<"Exiting handleAlarm\n";
    } catch(exception &e) {
        qDebug()<<e.what();
    }
    return;
}

QList<IncidenceIO> CalendarController::getEventsFromDB(int listType, const KDateTime& startDate,
                                                       const KDateTime& endDate, const QString& uid)
{
    QList<IncidenceIO> eventIOList;
    try {
        KCalCore::Event::List eventList;
        if(listType == EAll) {
            eventList = calendar->rawEvents(KCalCore::EventSortStartDate, KCalCore::SortDirectionAscending);            
        }
        else if(listType == EDayList) {
            eventList = calendar->rawEventsForDate(startDate.date(),KDateTime::Spec(KDateTime::LocalZone),KCalCore::EventSortStartDate,KCalCore::SortDirectionAscending);
            qDebug()<<"$$$$$$$$$$$$$$$$$$$$$$ Inside CalendarController getEventsFromDB, obtained events = "<<eventList.count();
        } else if(listType == EMonthList) {
            eventList = calendar->rawEvents(startDate.date(),endDate.date(),KDateTime::Spec(KDateTime::LocalZone));
        } else if(listType == EByUid) {
            KCalCore::Event::Ptr eventPtr = calendar->event(uid);
            eventList.append(eventPtr);
        }

        foreach(const KCalCore::Event::Ptr& event, eventList) {
            IncidenceIO eventIO;
            eventIO.setType(EEvent);
            eventIO.setUid(event->uid());
            eventIO.setDescription(event->description());
            eventIO.setSummary(event->summary());
            eventIO.setLocation(event->location());

            eventIO.setStartDateTime(event->dtStart().toLocalZone());
            if(event->allDay() || (event->dtStart().time() == event->dtEnd().time()))
            {
                eventIO.setAllDay(true);
            } else {
                eventIO.setAllDay(false);
                eventIO.setEndDateTime(event->dtEnd().toLocalZone());
            }

            if ( event->hasEnabledAlarms() ) {
                KCalCore::Alarm::List alarmList = event->alarms();

                if ( !alarmList.isEmpty() ) {
                    KCalCore::Alarm::Ptr& eventAlarm = alarmList.first();
                    eventIO.setAlarmDateTime(eventAlarm->time().toLocalZone());

                    if(eventAlarm->startOffset().asSeconds()==(-60*10))
                             eventIO.setAlarmType(E10MinB4);
                    else if(eventAlarm->startOffset().asSeconds()==(-60*15))
                        eventIO.setAlarmType(E15MinB4);
                    else if (eventAlarm->startOffset().asSeconds()==(-60*30))
                         eventIO.setAlarmType(E30MinB4);
                    else if(eventAlarm->startOffset().asSeconds()==(-60*60))
                         eventIO.setAlarmType(E1HrB4);
                    else if(eventAlarm->startOffset().asSeconds()==(-60*120))
                         eventIO.setAlarmType(E2HrsB4);
                    else if(eventAlarm->startOffset().asDays()==(-1))
                         eventIO.setAlarmType(E1DayB4);
                    else if(eventAlarm->startOffset().asDays()==(-2))
                         eventIO.setAlarmType(E2DaysB4);
                    else if(eventAlarm->startOffset().asDays()==(-7))
                         eventIO.setAlarmType(E1WeekB4);
                    else eventIO.setAlarmType(EOtherAlarm);
                }
            } else {
                eventIO.setAlarmType(ENoAlarm);
            }

            if(event->hasRecurrenceId())
                qDebug() <<"Recurrence Id="<< event->recurrenceId().toString(KDateTime::LocalDate).toStdString().c_str()<<"\n\n";
            if(event->recurrence()->recurrenceType()==KCalCore::Recurrence::rNone)
            {
                eventIO.setRepeatType(ENoRepeat);
            } else {
                if(event->recurrence()->recurrenceType()==KCalCore::Recurrence::rDaily)
                    eventIO.setRepeatType(EEveryDay);
                else if((event->recurrence()->recurrenceType()==KCalCore::Recurrence::rWeekly) && (event->recurrence()->frequency()!=2))
                    eventIO.setRepeatType(EEveryWeek);
                else if((event->recurrence()->recurrenceType()==KCalCore::Recurrence::rWeekly) && (event->recurrence()->frequency()==2))
                    eventIO.setRepeatType(EEvery2Weeks);
                else if(event->recurrence()->recurrenceType()==KCalCore::Recurrence::rMonthlyDay)
                    eventIO.setRepeatType(EEveryMonth);
                else if(event->recurrence()->recurrenceType()==KCalCore::Recurrence::rYearlyDay)
                    eventIO.setRepeatType(EEveryYear);
                else eventIO.setRepeatType(EOtherRepeat);

                if(event->recurrence()->duration() > 0) {
                    eventIO.setRepeatEndType(UtilMethods::EForNTimes);
                    eventIO.setRepeatCount(event->recurrence()->duration());
                } else if(event->recurrence()->endDateTime()>=event->recurrence()->startDateTime()) {
                    eventIO.setRepeatEndType(UtilMethods::EAfterDate);
                    eventIO.setRepeatCount(0);
                    eventIO.setRepeatEndDateTime(event->recurrence()->endDateTime().toLocalZone());
                }
            }
            eventIO.setTimeZoneOffset(event->dtStart().utcOffset());
            eventIO.setTimeZoneName(event->dtStart().timeZone().name());
            eventIOList.append(eventIO);
        }
    } catch(exception &e) {
        qDebug()<<e.what();
    }
    return eventIOList;
}


QObject* CalendarController::getEventForEdit(const QString& uid)
{
    QList<IncidenceIO> listIO = getEventsFromDB(EByUid, KDateTime(), KDateTime(), uid);
    IncidenceIO* objIO = new IncidenceIO(listIO.first());
    objIO->printIncidence();
    return objIO;
}

QDateTime CalendarController::getEventPositionInView(const QString& uid)
{
    QList<IncidenceIO> listIO = getEventsFromDB(EByUid, KDateTime(), KDateTime(), uid);
    const IncidenceIO& objIO = listIO.first();

    return objIO.getStartDateTime().dateTime();
}

QML_DECLARE_TYPE(CalendarController);
