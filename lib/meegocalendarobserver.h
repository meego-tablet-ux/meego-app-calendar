#ifndef MEEGOCALENDAROBSERVER_H
#define MEEGOCALENDAROBSERVER_H

#include <ekcal/ekcal-storage.h>
#include <icalformat.h>
#include <QDebug>

using namespace eKCal;

class MeeGoCalendarObserver :  public QObject, public eKCal::StorageObserver,
    public KCalCore::Calendar::CalendarObserver
{
        Q_OBJECT;

    public:
        MeeGoCalendarObserver();
        MeeGoCalendarObserver(const KCalCore::Calendar::Ptr &calendar,
                           const QString& prefix = "MyCalendarObserver",
                           QDebug (*dbg)() = qDebug);

        void beginIdleWatch(int ms);
        bool isIdle() const;
        void endIdleWatch();

    signals:
        void idle();
        void dbReady();
        void dbChanged();

    public slots:
        void dumpCalendar();

    protected:
        /* storage observer */
        virtual void loadingComplete(bool success, const QString &error);
        virtual void savingComplete(bool success, const QString &error);

        /* calendar observer */
        virtual void calendarIncidenceAdded(const KCalCore::Incidence::Ptr &incidence);
        virtual void calendarIncidenceAdditionCanceled (const KCalCore::Incidence::Ptr &incidence);
        virtual void calendarIncidenceChanged (const KCalCore::Incidence::Ptr &incidence);
        virtual void calendarIncidenceDeleted (const KCalCore::Incidence::Ptr &incidence);
        virtual void calendarModified(bool modified, KCalCore::Calendar *calendar);
        void timerEvent(QTimerEvent *event);

    private:
        KCalCore::ICalFormat m_format;
        KCalCore::Calendar::Ptr m_calendar;
        QString m_prefix;
        QDebug (*m_dbg)();

        qint64 m_lastChange;
        int m_idleDurationMS;
        int m_idleTimer;

} ;



#endif // MEEGOCALENDAROBSERVER_H
