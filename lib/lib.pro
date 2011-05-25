include(../common.pri)
TARGET = meegocalendar
TEMPLATE = lib

CONFIG += link_pkgconfig
PKGCONFIG += libkcalcoren libmkcal meegotouch

OBJECTS_DIR = .obj
MOC_DIR = .moc

SOURCES += \
    alarmlistmodel.cpp \
    calendarcontroller.cpp \
    calendardataitem.cpp \
    calendarlistmodel.cpp \
    calendarmonthmodel.cpp \
    calendarweekmodel.cpp \
    dayviewmodel.cpp \
    incidenceio.cpp \
    repeatlistmodel.cpp \
    timelistmodel.cpp \
    utilmethods.cpp \
    viewcalendarmodel.cpp \
    weekviewmodel.cpp \
    eventsdatamodel.cpp \
    calendardbsingleton.cpp

INSTALL_HEADERS += \
    alarmlistmodel.h \
    calendarcontroller.h \
    calendardataitem.h \
    calendarlistmodel.h \
    calendarmonthmodel.h \
    calendarweekmodel.h \
    dayviewmodel.h \
    incidenceio.h \
    repeatlistmodel.h \
    timelistmodel.h \
    utilmethods.h \
    viewcalendarmodel.h \
    weekviewmodel.h

HEADERS += $$INSTALL_HEADERS \
    eventsdatamodel.h \
    filterterminate.h \
    calendardbsingleton.h

target.path = $$INSTALL_ROOT/usr/lib
INSTALLS += target

headers.files += $$INSTALL_HEADERS
headers.path += $$INSTALL_ROOT/usr/include/meegocalendar
INSTALLS += headers

pkgconfig.files += meegocalendar.pc
pkgconfig.path += $$INSTALL_ROOT/usr/lib/pkgconfig
INSTALLS += pkgconfig
