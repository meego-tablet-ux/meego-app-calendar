/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef UTILMETHODS_H
#define UTILMETHODS_H

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <QDebug>
#include <QtDeclarative/qdeclarative.h>
#include <QObject>
#include <extendedcalendar.h>
#include <extendedstorage.h>
#include <notebook.h>
#include <sqlitestorage.h>
#include <kdatetime.h>
#include <duration.h>
#include <sstream>
#include <string>

enum EIncidenceType {
    EEvent = 1,
    EToDo,
    EJournal
};

enum EActionType {
    EAddEvent=1,
    EModifyEvent
};

enum ERepeatType
{
    ENoRepeat = 0,
    EEveryDay,
    EEveryWeek,
    EEvery2Weeks,
    EEveryMonth,
    EEveryYear,
    EOtherRepeat
};

enum EAlarmType
{
    ENoAlarm=0,
    E10MinB4 =1 ,
    E15MinB4,
    E30MinB4,
    E1HrB4,
    E2HrsB4,
    E1DayB4,
    E2DaysB4,
    E1WeekB4,
    EOtherAlarm
};


enum EWeekDays
{
    EMonday=1,
    ETuesday,
    EWednesday,
    EThursday,
    EFriday,
    ESaturday,
    ESunday
};

enum EEventList
{
    EAll=1,
    EDayList,
    EWeekList,
    EMonthList,
    EByUid
};


class UtilMethods: public QObject
{
    Q_OBJECT;

    public:

    enum EIncidenceType {
        EEvent = 1,
        EToDo,
        EJournal
    };

    enum EActionType {
        EAddEvent=1,
        EModifyEvent
    };

    enum ERepeatType
    {
        ENoRepeat = 0,
        EEveryDay,
        EEveryWeek,
        EEvery2Weeks,
        EEveryMonth,
        EEveryYear,
        EOtherRepeat
    };

    enum ERepeatEndType {
        ENoRepeatEndType=-1,
        EForever=0,
        EForNTimes,
        EAfterDate
    };

    enum EAlarmType
    {
        ENoAlarm=0,
        E10MinB4 =1 ,
        E15MinB4,
        E30MinB4,
        E1HrB4,
        E2HrsB4,
        E1DayB4,
        E2DaysB4,
        E1WeekB4,
        EOtherAlarm
    };


    enum EWeekDays
    {
        EMonday=1,
        ETuesday,
        EWednesday,
        EThursday,
        EFriday,
        ESaturday,
        ESunday
    };

    enum EEventList
    {
        EAll=1,
        EDayList,
        EWeekList,
        EMonthList,
        EByUid
    };


    enum EFormat {
        EShortMonth=1,
        ELongMonth
    };

    enum EViewCal {
        EDayView = 0,
        EWeekView,
        EMonthView
    };

    enum EEventType {
        EAllDay=1,
        ENotAllDay=2,
        EAllEvents
    };


    enum EEventDisplayIndex{
        E0to030=0,E030to1,E1to130,E130to2,E2to230,E230to3,E3to330,E330to4,E4to430,E430to5,E5to530,
        E530to6,E6to630,E630to7,E7to730,E730to8,E8to830,E830to9,E9to930,E930to10,E10to1030,E1030to11,
        E11to1130,E1130to12,E12to1230,E1230to13,E13to1330,E1330to14,E14to1430,E1430to15,E15to1530,
        E1530to16,E16to1630,E1630to17,E17to1730,E1730to18,E18to1830,E1830to19,E19to1930,E1930to20,
        E20to2030,E2030to21,E21to2130,E2130to22,E22to2230,E2230to23,E23to2330,E2330to24
    };

    enum EDateFormats {
        EDefault=0,
        ESystemLocaleShortDate,
        ESystemLocaleLongDate,
        EDefaultLocaleShortDate,
        EDefaultLocaleLongDate
    };

    enum ETimeFormats {
        ETimeDefault=0,
        ETimeSystemLocale
    };

    enum EDayIndices {
        EDayTimeStart=14
    };


    Q_ENUMS(EIncidenceType);
    Q_ENUMS(EActionType);
    Q_ENUMS(ERepeatType);
    Q_ENUMS(EAlarmType);
    Q_ENUMS(EWeekDays);
    Q_ENUMS(EEventList);
    Q_ENUMS(ERepeatEndType);
    Q_ENUMS(EViewCal);
    Q_ENUMS(EEventType);
    Q_ENUMS(EEventDisplayIndex);
    Q_ENUMS(EDateFormats);
    Q_ENUMS(ETimeFormats);
    Q_ENUMS(EDayIndices);

    UtilMethods(QObject *parent = 0);


public:
    Q_INVOKABLE QString getCurrentDate(int format=UtilMethods::EDefault);
    Q_INVOKABLE QDate getCurrentDateVal();
    Q_INVOKABLE QDate getDateFromVal(QString fromDate);
    Q_INVOKABLE QString getDateInFormatString(QDate fromDate,QString format);
    Q_INVOKABLE QString getDateInFormat(QDate fromDate,int format);
    Q_INVOKABLE QString getShortDate(QDate fromDate);
    Q_INVOKABLE QString getLongDate(QDate fromDate);
    Q_INVOKABLE QString getTimeInFormat(QTime fromTime,int format);
    Q_INVOKABLE QTime getCurrentTimeVal();
    Q_INVOKABLE QTime roundTime(QTime timeVal);
    Q_INVOKABLE QString getCurrentTime(int format=UtilMethods::ETimeSystemLocale);
    Q_INVOKABLE QTime addHMToCurrentTime(int hr,int min);
    Q_INVOKABLE QDate addDMYToGivenDate(QDate toDate,int days, int mon, int yr);
    Q_INVOKABLE QDate createDateFromVals(int day,int mon,int year);
    Q_INVOKABLE QString getWeekHeaderTitle(int day,int mon,int year);
    Q_INVOKABLE QTime createTimeFromVals(int ht,int min);
    Q_INVOKABLE QString getMonth(QDate fromDate);
    Q_INVOKABLE QString getDay(QDate fromDate);
    Q_INVOKABLE QString getYear(QDate fromDate);
    Q_INVOKABLE QString getHour(QTime fromTime);
    Q_INVOKABLE QString getMin(QTime fromTime);
    Q_INVOKABLE bool datesEqual(QDate date1, QDate date2);
    Q_INVOKABLE int compareDates(QDate date1,QDate date2);
    Q_INVOKABLE int compareTimes(QTime time1,QTime time2);
    Q_INVOKABLE QString getAlarmString(int alarmType);
    Q_INVOKABLE QString getLocalTimeZoneName();
    Q_INVOKABLE QString getRepeatTypeString(int repeatType);

    ~UtilMethods();
};

#endif // UTILMETHODS_H
