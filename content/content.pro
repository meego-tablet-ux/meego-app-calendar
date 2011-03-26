include(../common.pri)
TARGET = calendarplugin
TEMPLATE = lib

CONFIG += plugin link_pkgconfig

PKGCONFIG += meego-ux-content libmkcal

# use pkg-config paths for include in both g++ and moc
INCLUDEPATH += $$system(pkg-config --cflags meego-ux-content \
    | tr \' \' \'\\n\' | grep ^-I | cut -d 'I' -f 2-)

INCLUDEPATH += ../lib
LIBS += -L../lib -lmeegocalendar

OBJECTS_DIR = .obj
MOC_DIR = .moc

SOURCES += \
    calendarfeedmodel.cpp \
    calendarplugin.cpp \
    calendarservicemodel.cpp

HEADERS += \
    calendarfeedmodel.h \
    calendarplugin.h \
    calendarservicemodel.h

target.path = $$[QT_INSTALL_PLUGINS]/MeeGo/Content
INSTALLS += target
