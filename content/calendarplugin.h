/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef __calendarplugin_h
#define __calendarplugin_h

#include <QObject>

#include <feedplugin.h>

class McaServiceModel;
class McaFeedModel;
class CalendarServiceModel;

class CalendarPlugin: public QObject, public McaFeedPlugin
{
    Q_OBJECT
    Q_INTERFACES(McaFeedPlugin)

public:
    explicit CalendarPlugin(QObject *parent = NULL);
    ~CalendarPlugin();

    QAbstractItemModel *serviceModel();
    QAbstractItemModel *createFeedModel(const QString& service);
    McaSearchableFeed *createSearchModel(const QString& service,
                                         const QString& searchText);

private:
    CalendarServiceModel *m_serviceModel;
};

#endif  // __calendarplugin_h
