/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include <QDebug>

#include <actions.h>

#include "calendarservicemodel.h"

CalendarServiceModel::CalendarServiceModel(QObject *parent):
        McaServiceModel(parent)
{
}

CalendarServiceModel::~CalendarServiceModel()
{
}

//
// public member functions
//

int CalendarServiceModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    // there is only one calendar for now
    return 1;
}

QVariant CalendarServiceModel::data(const QModelIndex &index, int role) const
{
    // invalid if not the one true calendar
    if (index.row() != 0)
        return QVariant();

    qDebug() << "CalendarServiceModel::data role=" << role;
    switch (role) {
    case CommonDisplayNameRole:
        // the display name for calendar service content
        return tr("Calendar");

    case RequiredCategoryRole:
        // i18n ok
        return "calendar";

    case RequiredNameRole:
        // i18n ok
        return "calendar";

    case CommonConfigErrorRole:
        // assuming we will only show properly configured accounts for now
        return false;

    case CommonActionsRole:
        // until we start sending "true" for CommonConfigErrorRole, not needed
    default:
        qWarning() << "Unhandled data role requested!";
    case CommonIconUrlRole:
        // expect app to have no icon header for calendar, or supply it itself
        return QVariant();
    }
}
