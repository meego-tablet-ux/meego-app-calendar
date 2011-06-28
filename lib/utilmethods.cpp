/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "utilmethods.h"

UtilMethods::UtilMethods(QObject *parent) : QObject(parent)
{

}

QString UtilMethods::getCurrentDate(int format)
{
    KDateTime now = KDateTime::currentLocalDateTime();
    QString toTxt = "";
    switch(format) {
        case EDefault: {
            toTxt = now.date().toString(Qt::TextDate);
        }break;

        case ESystemLocaleShortDate: {
            toTxt = now.date().toString(Qt::SystemLocaleShortDate);
        }break;
        case ESystemLocaleLongDate: {
            toTxt = now.date().toString(Qt::SystemLocaleLongDate);
        }break;
        case EDefaultLocaleShortDate: {
            toTxt = now.date().toString(Qt::DefaultLocaleShortDate);
        }break;
        case EDefaultLocaleLongDate: {
            toTxt = now.date().toString(Qt::DefaultLocaleLongDate);
        }break;

    }
    return toTxt;
}

QDate UtilMethods::getCurrentDateVal()
{
    return QDate::currentDate();
}

QString UtilMethods::getShortDate(QDate fromDate)
{
    QString toTxt = fromDate.toString("ddd d");
    return toTxt;
}

QString UtilMethods::getLongDate(QDate fromDate)
{
    QString toTxt = fromDate.toString("MMMM dd, yyyy");
    return toTxt;
}

QDate UtilMethods::getDateFromVal(QString fromDate)
{
    QDate toDate = QDate::fromString(fromDate,"dd MMM yyyy");
    return toDate;
}

QString UtilMethods::getDateInFormatString(QDate fromDate,QString format)
{
    QString toTxt = fromDate.toString(format);
    return toTxt;
}

QString UtilMethods::getDateInFormat(QDate fromDate,int format)
{
    QString toTxt = "";
    switch(format) {
        case EDefault: {
            toTxt = fromDate.toString(Qt::TextDate);
        }break;

        case ESystemLocaleShortDate: {
            toTxt = fromDate.toString(Qt::SystemLocaleShortDate);
        }break;
        case ESystemLocaleLongDate: {
            toTxt = fromDate.toString(Qt::SystemLocaleLongDate);
        }break;
        case EDefaultLocaleShortDate: {
            toTxt = fromDate.toString(Qt::DefaultLocaleShortDate);
        }break;
        case EDefaultLocaleLongDate: {
            toTxt = fromDate.toString(Qt::DefaultLocaleLongDate);
        }break;

    }

    return toTxt;
}


QString UtilMethods::getTimeInFormat(QTime fromTime,int format)
{
    QString toTxt = "";
    switch(format) {
        case ETimeDefault: {
            toTxt = fromTime.toString(Qt::TextDate);
        }break;

        case ETimeSystemLocale: {
            toTxt = fromTime.toString(Qt::SystemLocaleDate);
        }break;
    }

    return toTxt;
}

QTime UtilMethods::getCurrentTimeVal()
{
    return QTime::currentTime();
}

QTime UtilMethods::roundTime(QTime timeVal)
{
    QTime now = timeVal;
    int hr = now.hour();
    int min = now.minute();
    min=(min<=30)?30:0;
    now.setHMS(hr,min,0);

    return now;
}


QString UtilMethods::getCurrentTime(int format)
{
    KDateTime now = KDateTime::currentLocalDateTime();
    QString toTxt = "";
    switch(format) {
        case ETimeDefault: {
            toTxt = now.time().toString(Qt::TextDate);
        }break;

        case ETimeSystemLocale: {
            toTxt = now.time().toString(Qt::SystemLocaleDate);
        }break;
    }

    return toTxt;
}


QDate UtilMethods::addDMYToGivenDate(QDate toDate,int days, int mon, int yr) {
    toDate = toDate.addDays(days).addMonths(mon).addYears(yr);
    return toDate;
}

QDate UtilMethods::createDateFromVals(int day,int mon,int year)
{
    QDate dateVal;
    dateVal.setYMD(year,mon,day);    
    return dateVal;
}

QString UtilMethods::getWeekHeaderTitle(int day,int mon,int year)
{
    QDate inFocusDateVal;
    QDate startDateVal;
    QDate endDateVal;
    inFocusDateVal.setYMD(year,mon,day);

    int dayOfWeek = inFocusDateVal.dayOfWeek();

    startDateVal = inFocusDateVal.addDays(1-dayOfWeek);
    endDateVal = startDateVal.addDays(6);
    //: %1 is StartDate and %2 is EndDate (will be deleted from code soon)
    QString toTxt = tr("%1 - %2","Date Range").arg(getDateInFormat(startDateVal,UtilMethods::EDefault)).arg(getDateInFormat(endDateVal,UtilMethods::EDefault));
    return toTxt;
}

QDate UtilMethods::getStartDateOfWeek(QDate inFocusDate,int weekStartDayIndex)
{
    QDate startDateVal;

    int dayOfWeek = inFocusDate.dayOfWeek();
    int daysToStartDate = (7-weekStartDayIndex+dayOfWeek)%7;
    startDateVal = inFocusDate.addDays(-daysToStartDate);
    return startDateVal;
}


QDate UtilMethods::getEndDateOfWeek(QDate startDate)
{
    QDate endDateVal;
    endDateVal = startDate.addDays(6);
    return endDateVal;
}

QTime UtilMethods::createTimeFromVals(int hr,int min)
{
    QTime timeVal;
    timeVal.setHMS(hr,min,0);   
    return timeVal;
}

QTime UtilMethods::addHMToCurrentTime(int hr,int min) {
    int val = (hr*60*60)+(min*60);
    KDateTime now = KDateTime::currentLocalDateTime().addSecs(val);    
    return now.time();
}

QString UtilMethods::getMonth(QDate fromDate)
{
    return QDate::shortMonthName(fromDate.month());
}

QString UtilMethods::getDay(QDate fromDate)
{    
    return fromDate.toString("d");
}


QString UtilMethods::getYear(QDate fromDate)
{   
    return fromDate.toString("yyyy");;
}



int UtilMethods::getHour(QTime fromTime)
{
    return fromTime.hour();
}



int UtilMethods::getMin(QTime fromTime)
{
    return fromTime.minute();
}

bool UtilMethods::datesEqual(QDate date1, QDate date2)
{
    if((date1.day()==date2.day()) && (date1.month()==date2.month()) && (date1.year()==date2.year()))
        return true;
    else
        return false;
}


int UtilMethods::compareDates(QDate date1,QDate date2)
{
    int retVal=0;    
    if(date1 > date2){
        retVal = 2;
    } else if(date1 < date2) {
        retVal = 1;
    } else if(date1==date2) {
        retVal = 0;
    }
    return retVal;
}

int UtilMethods::compareTimes(QTime time1,QTime time2)
{
    int retVal = 0;    
    if(time1 > time2){
        retVal = 2;
    } else if(time1 < time2) {
        retVal = 1;
    } else if(time1==time2) {
        retVal = 0;
    }
    return retVal;
}

QString UtilMethods::getAlarmString(int alarmType)
{
    QString alarmText="";
    switch(alarmType) {
        case ENoAlarm: { alarmText = tr("No reminder"); break; }
        case E10MinB4: { alarmText = tr("10 minutes before"); break; }
        case E15MinB4: { alarmText = tr("15 minutes before"); break; }
        case E30MinB4: { alarmText = tr("30 minutes before"); break; }
        case E1HrB4: { alarmText = tr("1 hour before"); break; }
        case E2HrsB4: { alarmText = tr("2 hours before"); break; }
        case E1DayB4: { alarmText = tr("1 day before"); break; }
        case E2DaysB4: { alarmText = tr("2 days before"); break; }
        case E1WeekB4: { alarmText = tr("1 week before"); break; }
        case EOtherAlarm: { alarmText = tr("Other","Alarm"); break; }
    }
    return alarmText;
}

QString UtilMethods::getRepeatTypeString(int repeatType)
{
    QString repeatText="";
    switch(repeatType) {
        case ENoRepeat: {repeatText = tr("Never"); break;}
        case EEveryDay: {repeatText = tr("Every day"); break;}
        case EEveryWeek:  {repeatText = tr("Every week"); break;}
        case EEvery2Weeks: {repeatText = tr("Every 2 weeks"); break;}
        case EEveryMonth: {repeatText = tr("Every month"); break;}
        case EEveryYear: {repeatText = tr("Every year"); break;}
        case EOtherRepeat: {repeatText = tr("Other","Interval"); break;}
    }
    return repeatText;
}

QString UtilMethods::getRepeatEndTypeString(int repeatEndType)
{
    QString repeatEndText="";
    switch(repeatEndType) {
        case EForever: {repeatEndText = tr("Repeats forever"); break;}
        case EForNTimes: {repeatEndText = tr("Ends after number of times"); break;}
        case EAfterDate:  {repeatEndText = tr("Ends after date"); break;}
    }
    return repeatEndText;
}

QString UtilMethods::getLocalTimeZoneName()
 {
     QString zoneName="";
     zoneName = KDateTime::currentLocalDateTime().timeZone().name();
     return zoneName;
 }

UtilMethods::~UtilMethods ()
{
}

QML_DECLARE_TYPE(UtilMethods);
