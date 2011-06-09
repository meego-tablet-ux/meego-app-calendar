#ifndef MEEGOCALENDAROBSERVER_H
#define MEEGOCALENDAROBSERVER_H


#include "ekcal/ekcal-storage.h"
#include <icalformat.h>
#include <qdebug.h>
using namespace eKCal;

class MeeGoCalendarObserver :  public QObject, public eKCal::StorageObserver, public KCalCore::Calendar::CalendarObserver
{
        Q_OBJECT;
        KCalCore::ICalFormat m_format;
        KCalCore::Calendar::Ptr m_calendar;
        QString m_prefix;
        QDebug (*m_dbg)();

        qint64 m_lastChange;
        int m_idleDurationMS;
        int m_idleTimer;

        /* storage observer */
        virtual void loadingComplete(bool success, const QString &error)
        {
            m_dbg() << m_prefix << "loading completed" <<
                (success ? "successfully" : "with error:") << error;
            qDebug()<<"Inside MeeGoCalendarObserver, loadingComplete before dbReady()";
            emit dbReady();
        }

        virtual void savingComplete(bool success, const QString &error)
        {
            m_dbg() << m_prefix << "saving completed" <<
                (success ? "successfully" : "with error:") << error;
        }

        /* calendar observer */
        virtual void calendarIncidenceAdded(const KCalCore::Incidence::Ptr &incidence)
        {
            m_dbg() << m_prefix << "added:" << m_format.toICalString(incidence);
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        virtual void calendarIncidenceAdditionCanceled (const KCalCore::Incidence::Ptr &incidence)
        {
            m_dbg() << m_prefix << "addition canceled:" << m_format.toICalString(incidence);
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        virtual void calendarIncidenceChanged (const KCalCore::Incidence::Ptr &incidence)
        {
            m_dbg() << m_prefix << "changed:" << m_format.toICalString(incidence);
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        virtual void calendarIncidenceDeleted (const KCalCore::Incidence::Ptr &incidence)
        {
            m_dbg() << m_prefix << "deleted:" << m_format.toICalString(incidence);
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        virtual void calendarModified(bool modified, KCalCore::Calendar *calendar)
        {
            m_dbg() << m_prefix << "calendar modified:" << (modified ? "yes" : "no");
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        void timerEvent(QTimerEvent *event)
        {
            if (isIdle()) {
                endIdleWatch();
                emit idle();
            }
        }

    public:
        MeeGoCalendarObserver() {}

        MeeGoCalendarObserver(const KCalCore::Calendar::Ptr &calendar,

                           const QString prefix = "MyCalendarObserver",
                           QDebug (*dbg)() = qDebug) :
            m_calendar(calendar),
            m_prefix(prefix),
            m_dbg(dbg),
            m_idleTimer(0)
        {}

        /**
         * start watching for changes to the calendar, emit idle() when
         * nothing is seen for the requested period of time
         */
        void beginIdleWatch(int ms)
        {
            m_idleTimer = startTimer(ms);
            m_idleDurationMS = ms;
            m_lastChange = QDateTime::currentMSecsSinceEpoch();
        }

        bool isIdle()
        {
            qint64 now = QDateTime::currentMSecsSinceEpoch();
            return m_lastChange + m_idleDurationMS < now;
        }

        void endIdleWatch()
        {
            if (m_idleTimer) {
                killTimer(m_idleTimer);
                m_idleTimer = 0;
            }
        }

    signals:
        void idle();
        void dbReady();

    public slots:
        void dumpCalendar()
        {
            m_dbg() << m_prefix << m_format.toString(m_calendar);
        }


} ;



#endif // MEEGOCALENDAROBSERVER_H
