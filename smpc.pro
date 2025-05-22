TARGET = smpc
TEMPLATE = lib

CONFIG += staticlib

QT += core network

CONFIG += link_pkgconfig sailfishapp

INCLUDEPATH += src

SOURCES += \
#    src/mpd/serverprofile.cpp \
#    src/mpd/playlistmodel.cpp \
    src/mpd/networkaccess.cpp \
    src/mpd/mpdtrack.cpp \
    src/mpd/mpdoutput.cpp \
    src/mpd/mpdfileentry.cpp \
    src/mpd/mpdartist.cpp \
    src/mpd/mpdalbum.cpp \
#    src/mpd/filemodel.cpp \
#    src/mpd/artistmodel.cpp \
#    src/mpd/albummodel.cpp \
#    src/mpd/serverprofilemodel.cpp \
    src/mpd/mpdplaybackstatus.cpp \
    src/mpd/serverinfo.cpp

HEADERS += \
#    src/mpd/serverprofile.h \
#    src/mpd/playlistmodel.h \
    src/mpd/networkaccess.h \
    src/mpd/mpdtrack.h \
    src/mpd/mpdoutput.h \
    src/mpd/mpdfileentry.h \
    src/mpd/mpdartist.h \
    src/mpd/mpdalbum.h \
#    src/mpd/filemodel.h \
#    src/mpd/artistmodel.h \
#    src/mpd/albummodel.h \
#    src/mpd/serverprofilemodel.h \
    src/mpd/mpdplaybackstatus.h \
    src/mpd/mpdcommon.h \
    src/mpd/serverinfo.h
