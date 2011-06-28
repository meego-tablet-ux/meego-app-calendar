#include "meegocalendarobserver.h"

MeeGoCalendarObserver::MeeGoCalendarObserver() {}

MeeGoCalendarObserver::MeeGoCalendarObserver(const KCalCore::Calendar::Ptr &calendar,
                                             const QString& prefix,
                                             QDebug (*dbg)()) :
    m_calendar(calendar), m_prefix(prefix), m_dbg(dbg), m_idleTimer(0)
{}

/**
 * start watching for changes to the calendar, emit idle() when
 * nothing is seen for the requested period of time
 */
void MeeGoCalendarObserver::beginIdleWatch(int ms)
{
    m_idleTimer = startTimer(ms);
    m_idleDurationMS = ms;
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
}

bool MeeGoCalendarObserver::isIdle() const
{
    qint64 now = QDateTime::currentMSecsSinceEpoch();
    return m_lastChange + m_idleDurationMS < now;
}

void MeeGoCalendarObserver::endIdleWatch()
{
    if (m_idleTimer) {
        killTimer(m_idleTimer);
        m_idleTimer = 0;
    }
}

void MeeGoCalendarObserver::loadingComplete(bool success, const QString &error)
{
    m_dbg() << m_prefix << "loading completed" <<
        (success ? "successfully" : "with error:") << error;
    qDebug()<<"Inside MeeGoCalendarObserver, loadingComplete before dbReady()";
    emit dbReady();
}

void MeeGoCalendarObserver::savingComplete(bool success, const QString &error)
{
    m_dbg() << m_prefix << "saving completed" <<
        (success ? "successfully" : "with error:") << error;
}

/* calendar observer */
void MeeGoCalendarObserver::calendarIncidenceAdded(const KCalCore::Incidence::Ptr &incidence)
{
    m_dbg() << m_prefix << "added:" << m_format.toICalString(incidence);
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
}

void MeeGoCalendarObserver::calendarIncidenceAdditionCanceled (const KCalCore::Incidence::Ptr &incidence)
{
    m_dbg() << m_prefix << "addition canceled:" << m_format.toICalString(incidence);
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
}

void MeeGoCalendarObserver::calendarIncidenceChanged (const KCalCore::Incidence::Ptr &incidence)
{
    m_dbg() << m_prefix << "changed:" << m_format.toICalString(incidence);
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
}

void MeeGoCalendarObserver::calendarIncidenceDeleted (const KCalCore::Incidence::Ptr &incidence)
{
    m_dbg() << m_prefix << "deleted:" << m_format.toICalString(incidence);
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
}

void MeeGoCalendarObserver::calendarModified(bool modified, KCalCore::Calendar *calendar)
{
    Q_UNUSED(calendar);
    m_dbg() << m_prefix << "calendar modified:" << (modified ? "yes" : "no");
    m_lastChange = QDateTime::currentMSecsSinceEpoch();
    qDebug()<<"Inside MeeGoCalendarObserver, calendarModified before dbChanged()";
    if(modified)  {
        qDebug()<<"Inside MeeGoCalendarObserver, Emitting dbChanged()";
        emit dbChanged();
    }

}

void MeeGoCalendarObserver::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);
    if (isIdle()) {
        endIdleWatch();
        emit idle();
    }
}

void MeeGoCalendarObserver::dumpCalendar()
{
    m_dbg() << m_prefix << m_format.toString(m_calendar);
}
