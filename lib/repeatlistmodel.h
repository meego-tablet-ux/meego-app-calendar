/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#ifndef REPEATLISTMODEL_H
#define REPEATLISTMODEL_H

#include <QtCore/QtCore>
#include <QtCore/QObject>
#include <QAbstractListModel>
#include "utilmethods.h"

class RepeatItem : QObject{
    Q_OBJECT
public:
    RepeatItem(int type, QString desc, QObject *parent = 0);

    enum RepeatItemRoles {
        Type = Qt::UserRole+1,
        Description = Qt::UserRole+2
    };

    int type;
    QString description;

};

class RepeatListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    RepeatListModel(QObject *parent = 0);
    ~RepeatListModel();

    int getCount() const
        { return itemsList.count(); }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<RepeatItem *> itemsList;

};

class RepeatEndListModel:public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount);

public:
    RepeatEndListModel(QObject *parent = 0);
    ~RepeatEndListModel();

    int getCount() const
        { return itemsList.count(); }

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(int index) const;
    QVariant data(const QModelIndex &index, int role) const;
    void clearData();

protected:
    QList<RepeatItem *> itemsList;

};


#endif // REPEATLISTMODEL_H
