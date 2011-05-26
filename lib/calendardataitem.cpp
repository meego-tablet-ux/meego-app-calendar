/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "calendardataitem.h"
#include <inttypes.h>

CalendarDataItem::CalendarDataItem(int index,const IncidenceIO& fromObj, QObject *parent) : QObject(parent)
{
    this->index = index;
    this->type = fromObj.getType();
    this->uid = fromObj.getUid();
    this->description = fromObj.getDescription();
    this->summary = fromObj.getSummary();
    this->location = fromObj.getLocation();
    this->allDay = fromObj.isAllDay();
    this->repeatType = fromObj.getRepeatType();
    this->repeatEndType = fromObj.getRepeatType();
    this->repeatCount = fromObj.getRepeatCount();
    this->startDate = fromObj.getStartDateTime().date();
    this->startTime = fromObj.getStartDateTime().time();
    this->endDate = fromObj.getEndDateTime().date();
    this->endTime = fromObj.getEndDateTime().time();
    this->repeatEndDate = fromObj.getRepeatEndDateTime().date();
    this->repeatEndTime = fromObj.getRepeatEndDateTime().time();
    this->alarmType = fromObj.getAlarmType();
    this->alarmDate = fromObj.getAlarmDateTime().date();
    this->alarmTime = fromObj.getAlarmDateTime().time();
    this->zoneOffset = fromObj.getTimeZoneOffset();
    this->zoneName = fromObj.getTimeZoneName();
    this->xUnits = 0;
    this->yUnits = 0;
    this->widthUnits=0;
    this->heightUnits=0;
    this->dayIndex=0;
}

CalendarDataItem::CalendarDataItem(const CalendarDataItem& fromObj) : QObject(0)
{
    this->index = fromObj.index;
    this->type = fromObj.type;
    this->uid = fromObj.uid;
    this->description = fromObj.description;
    this->summary = fromObj.summary;
    this->location = fromObj.location;
    this->allDay = fromObj.allDay;
    this->repeatType = fromObj.repeatType;
    this->repeatEndType = fromObj.repeatEndType;
    this->repeatCount = fromObj.repeatCount;
    this->startDate = fromObj.startDate;
    this->startTime = fromObj.startTime;
    this->endDate = fromObj.endDate;
    this->endTime = fromObj.endTime;
    this->repeatEndDate = fromObj.repeatEndDate;
    this->repeatEndTime = fromObj.repeatEndTime;
    this->alarmType = fromObj.alarmType;
    this->alarmDate = fromObj.alarmDate;
    this->alarmTime = fromObj.alarmTime;
    this->zoneOffset = fromObj.zoneOffset;
    this->zoneName = fromObj.zoneName;
    this->xUnits = 0;
    this->yUnits = 0;
    this->widthUnits=0;
    this->heightUnits=0;
    this->dayIndex=fromObj.dayIndex;
}

