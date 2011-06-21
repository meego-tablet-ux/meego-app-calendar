include(common.pri)
CONFIG += ordered
TEMPLATE = subdirs
SUBDIRS += lib plugin content

QML_FILES = *.qml

OTHER_FILES += $${QML_FILES}

qmlfiles.files += $${QML_FILES}
qmlfiles.path += $$INSTALL_ROOT/usr/share/$$TARGET

desktop.files += meego-app-calendar.desktop
desktop.path += $$INSTALL_ROOT/usr/share/applications/

INSTALLS += qmlfiles desktop

# dist stuff begins here
TRANSLATIONS += *.qml lib/*.h lib/*.cpp
PROJECT_NAME = meego-app-calendar

dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION} &&
dist.commands += git clone . $${PROJECT_NAME}-$${VERSION} &&
dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION}/.git &&
dist.commands += rm -f $${PROJECT_NAME}-$${VERSION}/.gitignore &&
dist.commands += mkdir -p $${PROJECT_NAME}-$${VERSION}/ts &&
dist.commands += lupdate $${TRANSLATIONS} -ts $${PROJECT_NAME}-$${VERSION}/ts/$${PROJECT_NAME}.ts &&
dist.commands += tar jcpvf $${PROJECT_NAME}-$${VERSION}.tar.bz2 $${PROJECT_NAME}-$${VERSION} &&
dist.commands += rm -fR $${PROJECT_NAME}-$${VERSION}
QMAKE_EXTRA_TARGETS += dist
