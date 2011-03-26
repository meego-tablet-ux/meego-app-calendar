/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef VIEWCALENDARMODEL_H
#define VIEWCALENDARMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>

class ViewItem : QObject{
    Q_OBJECT
public:
    ViewItem(int type, QString desc, QString icon,QObject *parent = 0);

    enum ViewItemRoles {
        Type = Qt::UserRole+1,
        Description = Qt::UserRole+2,
        Icon = Qt::UserRole+3
    };

    int type;
    QString description;
    QString icon;

};

class ViewCalendarModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    ViewCalendarModel(QObject *parent = 0);
    ~ViewCalendarModel();

    int getCount() const
        { return itemsList.count(); }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<ViewItem *> itemsList;

};

#endif // VIEWCALENDARMODEL_H
