/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include <QDebug>

#include <QtPlugin>

#include "calendarplugin.h"
#include "calendarservicemodel.h"
#include "calendarfeedmodel.h"

CalendarPlugin::CalendarPlugin(QObject *parent): QObject(parent), McaFeedPlugin()
{
    qDebug("CalendarPlugin constructor");
    m_serviceModel = new CalendarServiceModel(this);
}

CalendarPlugin::~CalendarPlugin()
{
}

QAbstractItemModel *CalendarPlugin::serviceModel()
{
    return m_serviceModel;
}

QAbstractItemModel *CalendarPlugin::createFeedModel(const QString& service)
{
    qDebug() << "CalendarPlugin::createFeedModel: " << service;
    return NULL;
}

McaSearchableFeed *CalendarPlugin::createSearchModel(const QString& service,
                                                     const QString& searchText)
{
    // service ignored currently because there is only one calendar
    qDebug() << "CalendarPlugin::createSearchModel: " << service << searchText;
    return new CalendarFeedModel(searchText, this);
}

Q_EXPORT_PLUGIN2(calendarplugin, CalendarPlugin)
