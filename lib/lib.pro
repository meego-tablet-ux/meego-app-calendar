include(../common.pri)
TARGET = meegocalendar
TEMPLATE = lib

INCLUDEPATH += ../lib
LIBS += -L../lib
CONFIG += link_pkgconfig
PKGCONFIG += libkcalcoren libekcal

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
    calendardbsingleton.cpp \
    meegocalendarobserver.cpp

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
    eventsdatamodel.h \
    filterterminate.h \
    calendardbsingleton.h

HEADERS += $$INSTALL_HEADERS \
    meegocalendarobserver.h

target.path = $$INSTALL_ROOT/usr/lib
INSTALLS += target

headers.files += $$INSTALL_HEADERS
headers.path += $$INSTALL_ROOT/usr/include/meegocalendar
INSTALLS += headers

pkgconfig.files += meegocalendar.pc
pkgconfig.path += $$INSTALL_ROOT/usr/lib/pkgconfig
INSTALLS += pkgconfig
