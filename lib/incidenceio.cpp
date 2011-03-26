/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "incidenceio.h"

IncidenceIO::IncidenceIO(QObject *parent) : QObject(parent)
{
    qDebug()<<"*****Inside main constructor\n";
}

IncidenceIO::IncidenceIO(const IncidenceIO& fromObj) : QObject(0)
{
    //qDebug()<<"****Inside copy constructor\n";
    this->type = fromObj.type;
    this->uid = fromObj.uid;
    this->description = fromObj.description;
    this->summary = fromObj.summary;
    this->location = fromObj.location;
    this->allDay = fromObj.allDay;
    this->repeatType = fromObj.repeatType;
    this->repeatEndType = fromObj.repeatEndType;
    this->repeatCount = fromObj.repeatCount;
    this->startDateTime = fromObj.startDateTime;
    this->endDateTime = fromObj.endDateTime;
    this->repeatEndDateTime = fromObj.repeatEndDateTime;
    this->alarmType = fromObj.alarmType;
    this->alarmDateTime = fromObj.alarmDateTime;
    this->zoneOffset = fromObj.zoneOffset;
    this->zoneName = fromObj.zoneName;
    //printIncidence();
}

IncidenceIO::~IncidenceIO()
{
}

//Getters and Setters
int IncidenceIO::getType() const
{
    return type;
}

QString IncidenceIO::getUid() const
{
    return uid;
}

QString IncidenceIO::getDescription() const
{
    return description;
}

QString IncidenceIO::getSummary() const
{
    qDebug()<<"Inside getSummary"<<summary<<"\n";
    return summary;
}

QString IncidenceIO::getLocation() const
{
    return location;
}

bool IncidenceIO::isAllDay() const
{
    return allDay;
}

int IncidenceIO::getRepeatType() const
{
    return repeatType;
}

int IncidenceIO::getRepeatEndType() const
{
    return repeatEndType;
}

int IncidenceIO::getRepeatCount() const
{
    return repeatCount;
}

KDateTime IncidenceIO::getStartDateTime() const
{
    return startDateTime;
}

KDateTime IncidenceIO::getEndDateTime() const
{
    return endDateTime;
}

KDateTime IncidenceIO::getRepeatEndDateTime() const
{
    return repeatEndDateTime;
}


KDateTime IncidenceIO::getAlarmDateTime() const
{
    return alarmDateTime;
}

int IncidenceIO::getAlarmType() const
{
    return alarmType;
}


int IncidenceIO::getTimeZoneOffset() const
{
    return zoneOffset;
}

QString IncidenceIO::getTimeZoneName() const
{
    return zoneName;
}


QDate IncidenceIO::getStartDateFromKDT()
{
    return startDateTime.date();
}

QTime IncidenceIO::getStartTimeFromKDT()
{        
    return startDateTime.time();
}

QDate IncidenceIO::getEndDateFromKDT()
{        
    return endDateTime.date();
}

QTime IncidenceIO::getEndTimeFromKDT()
{
    return endDateTime.time();
}

QDate IncidenceIO::getRepeatEndDateFromKDT()
{       
    return repeatEndDateTime.date();
}

QTime IncidenceIO::getRepeatEndTimeFromKDT()
{
    return repeatEndDateTime.time();
}


void IncidenceIO::setType(const int type)
{
   this->type = type;
}


void IncidenceIO::setUid(const QString  uid)
{
    this->uid =  uid;
}


void IncidenceIO::setDescription(const QString description)
{
    this->description = description;
}


void IncidenceIO::setSummary(const QString summary)
{
   this->summary = summary;
}


void IncidenceIO::setLocation(const QString location)
{
    this->location = location;
}


void IncidenceIO::setAllDay(const bool allDay)
{
    this->allDay = allDay;
}


void IncidenceIO::setRepeatType(const int repeatType)
{
    this->repeatType = repeatType;
}

void IncidenceIO::setRepeatEndType(const int repeatEndType)
{
    this->repeatEndType = repeatEndType;
}

void IncidenceIO::setRepeatCount(const int repeatCount)
{
    this->repeatCount = repeatCount;
}

void IncidenceIO::setStartDateTime(const KDateTime startDateTime)
{
    this->startDateTime = startDateTime;
}

void IncidenceIO::setStartDateTime(const QDate startDateVal, const QTime startTimeVal, QString tzName)
{
    qDebug()<<"Inside IncidenceIO::setStartDateTime, startDateVal="<<startDateVal.toString("dd MMM yyyy");

    qDebug()<<"Inside IncidenceIO::setStartDateTime, startTimeVal="<<startTimeVal.toString("hh:mm");

    if(tzName.isNull()||tzName.isEmpty()) {
        //KDateTime::Spec tzSpec(KDateTime::LocalZone);
        //this->setStartDateTime(KDateTime(startDateVal,startTimeVal,tzSpec));
        KDateTime::Spec tzSpec(KSystemTimeZones::local());
        this->setStartDateTime(KDateTime(startDateVal,startTimeVal,tzSpec));
    } else {
        //KDateTime::Spec tzSpec(KDateTime::LocalZone,gmtOffset);
        //this->setStartDateTime(KDateTime(startDateVal,startTimeVal,tzSpec));
        KDateTime::Spec tzSpec(KSystemTimeZones::zone(tzName));
        this->setStartDateTime(KDateTime(startDateVal,startTimeVal,tzSpec));
    }

    qDebug()<<"*****************Inside overloaded setStartDateTime startDateTime="<<startDateTime.toString()<<"\n";
}


    void IncidenceIO::setEndDateTime(const KDateTime endDateTime)
    {
        this->endDateTime = endDateTime;
    }

    void IncidenceIO::setEndDateTime(const QDate endDateVal, const QTime endTimeVal,QString tzName)
    {
        if(tzName.isNull()||tzName.isEmpty()) {
            //KDateTime::Spec tzSpec(KDateTime::LocalZone);
            //this->setEndDateTime(KDateTime(endDateVal,endTimeVal,tzSpec));
            KDateTime::Spec tzSpec(KSystemTimeZones::local());
            this->setEndDateTime(KDateTime(endDateVal,endTimeVal,tzSpec));
        } else {
            //KDateTime::Spec tzSpec(KDateTime::OffsetFromUTC,gmtOffset);
            //this->setEndDateTime(KDateTime(endDateVal,endTimeVal,tzSpec));
            KDateTime::Spec tzSpec(KSystemTimeZones::zone(tzName));
            this->setEndDateTime(KDateTime(endDateVal,endTimeVal,tzSpec));
        }

        qDebug()<<"Inside overloaded setEndDateTime\n";
    }


    void IncidenceIO::setRepeatEndDateTime(const KDateTime repeatEndDateTime)
    {
        this->repeatEndDateTime = repeatEndDateTime;
    }

    void IncidenceIO::setRepeatEndDateTime(const QDate repeatEndDateVal, const QTime repeatEndTimeVal, QString tzName)
    {
        if(tzName.isNull()||tzName.isEmpty()) {
            //KDateTime::Spec tzSpec(KDateTime::LocalZone);
            //this->setRepeatEndDateTime(KDateTime(repeatEndDateVal,repeatEndTimeVal,tzSpec));
            KDateTime::Spec tzSpec(KSystemTimeZones::local());
            this->setRepeatEndDateTime(KDateTime(repeatEndDateVal,repeatEndTimeVal,tzSpec));
        } else {
            //KDateTime::Spec tzSpec(KDateTime::OffsetFromUTC,gmtOffset);
            //this->setRepeatEndDateTime(KDateTime(repeatEndDateVal,repeatEndTimeVal,tzSpec));
            KDateTime::Spec tzSpec(KSystemTimeZones::zone(tzName));
            this->setRepeatEndDateTime(KDateTime(repeatEndDateVal,repeatEndTimeVal,tzSpec));
        }

        qDebug()<<"Inside overloaded setRepeatEndDateTime\n";
    }


    void IncidenceIO::setAlarmType(const int alarmType)
    {
        this->alarmType = alarmType;
    }


    void IncidenceIO::setAlarmDateTime(const KDateTime alarmDateTime)
    {
        this->alarmDateTime = alarmDateTime;
    }


    void IncidenceIO::setTimeZoneOffset(const int zoneOffset)
    {
        this->zoneOffset = zoneOffset;
    }

    void IncidenceIO::setTimeZoneName(const QString zoneName)
    {
        this->zoneName = zoneName;
    }

    void IncidenceIO::printIncidence()
    {
        ostringstream val;

        val<<"Type="<< this->getType()<<"\n";
        val<<"Uid="<< this->getUid().toStdString()<<"\n";
        val<<"Description="<< this->getDescription().toStdString()<<"\n";
        val<<"Summary="<< this->getSummary().toStdString()<<"\n";
        val<<"Location="<< this->getLocation().toStdString()<<"\n";
        val<<"AllDay="<<this->isAllDay()<<"\n";
        val<<"RepeatType="<< this->getRepeatType()<<"\n";
        val<<"RepeatEndType="<< this->getRepeatEndType()<<"\n";
        val<<"RepeatCount="<< this->getRepeatCount()<<"\n";
        val<<"StartDateTime="<<this->getStartDateTime().toString(KDateTime::LocalDate).toStdString()<<"\n"; //.toString("m:d:Y H:M:S")
        val<<"EndDateTime="<<this->getEndDateTime().toString(KDateTime::LocalDate).toStdString()<<"\n";
        val<<"RepeatEndDateTime="<<this->getRepeatEndDateTime().toString(KDateTime::LocalDate) .toStdString()<<"\n";
        val<<"AlarmType="<<this->getAlarmType()<<"\n";
        val<<"AlarmDateTime="<< this->getAlarmDateTime().toString(KDateTime::LocalDate).toStdString()<<"\n";
        val<<"ZoneOffset="<< this->getTimeZoneOffset()<<"\n";
        val<<"ZoneName="<< this->getTimeZoneName().toStdString()<<"\n";

        qDebug()<<val.str().c_str();

    }

    QML_DECLARE_TYPE(IncidenceIO);

