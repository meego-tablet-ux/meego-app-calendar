include(../common.pri)
TARGET = meegocalendar
TEMPLATE = lib

CONFIG += link_pkgconfig
PKGCONFIG += libkcalcoren libmkcal

OBJECTS_DIR = .obj
MOC_DIR = .moc

SOURCES += \
    calendarcontroller.cpp \
    calendardataitem.cpp \
    calendarlistmodel.cpp \
    calendarmonthmodel.cpp \
    calendarweekmodel.cpp \
    dayviewmodel.cpp \
    incidenceio.cpp \
    timelistmodel.cpp \
    utilmethods.cpp \
    eventsdatamodel.cpp \
    calendardbsingleton.cpp

INSTALL_HEADERS += \
    calendarcontroller.h \
    calendardataitem.h \
    calendarlistmodel.h \
    calendarmonthmodel.h \
    calendarweekmodel.h \
    dayviewmodel.h \
    incidenceio.h \
    timelistmodel.h \
    utilmethods.h \
    viewcalendarmodel.h \

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
