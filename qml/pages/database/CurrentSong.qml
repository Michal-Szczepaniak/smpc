import QtQuick 2.2
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentSongPage
    property string title: ctl.player.playbackStatus.title
    property string album: mAlbum
    property string artist: mArtist
    //property int lengthtextcurrent:lengthTextcurrent.text;
    property bool shuffle
    property bool repeat
    property bool playing
    property int fontsize: Theme.fontSizeMedium
    property int fontsizegrey: Theme.fontSizeSmall
    property bool detailsvisible: true
    property bool pageactive: false

    Component.onDestruction: {
        mCurrentSongPage = null
    }

    Drawer {
        id: mainDrawer
        dock: (orientation === Orientation.Portrait
               || orientation === Orientation.PortraitInverted) ? Dock.Bottom : Dock.Right
        anchors.fill: parent
        open: true

        SilicaFlickable {
            id: infoFlickable
            anchors.fill: parent
            BackgroundItem {
                id: drawerOpenBackgroundItem
                anchors.fill: parent
                onClicked: {
                    if (currentSongPage.state == "landscape"
                            && mainDrawer.open) {
                        mainDrawer.hide()
                    } else if (currentSongPage.state == "landscape"
                               && !mainDrawer.open) {
                        mainDrawer.show()
                        // volumeControl.state = "slideVisible"
                        drawerCloseTimer.start()
                    }
                }
            }
            PullDownMenu {
                visible: album !== "" ? true : artist !== "" ? true : false
                MenuItem {
                    text: qsTr("Show all tracks from album")
                    visible: album === "" ? false : true
                    onClicked: {
                        albumClicked("", album)
                        pageStack.push(Qt.resolvedUrl("AlbumTracksPage.qml"), {
                                           "artistname": "",
                                           "albumname": mAlbum
                                       })
                    }
                }
                MenuItem {
                    text: qsTr("Show albums from artist")
                    visible: artist === "" ? false : true
                    onClicked: {
                        artistClicked(artist)
                        pageStack.push(Qt.resolvedUrl("AlbumListPage.qml"), {
                                           "artistname": mArtist
                                       })
                    }
                }
            }
            contentHeight: contentColumn.height
            clip: true
            Column {
                id: contentColumn

                clip: true
                anchors {
                    right: parent.right
                    left: parent.left
                }

                // Spacing hack
                Rectangle {
                    opacity: 0.0
                    // Center landscapeimages
                    height: (currentSongPage.height - landscapeImageRow.height) / 2
                    width: parent.width
                    visible: landscapeImageRow.visible
                }

                Column {
                    id: subColumn
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: listPadding
                        rightMargin: listPadding
                    }

                    ToggleImage {
                        enabled: showCoverNowPlaying
                        visible: showCoverNowPlaying
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                        id: coverImage
                        property int calcheight: (infoFlickable.height
                                                  - (titleText.height + albumText.height
                                                     + artistText.height))
                        height: showCoverNowPlaying ? (calcheight > (contentColumn.width - listPadding * 2) ? (contentColumn.width - listPadding * 2) : calcheight) : 0
                        width: height
                        fillMode: Image.PreserveAspectFit
                        sourceprimary: coverimageurl
                        sourcesecondary: artistimageurl
                        active: visible
                        Rectangle {
                            color: Theme.rgba(Theme.highlightBackgroundColor,
                                              Theme.highlightBackgroundOpacity)
                            anchors.fill: parent
                            visible: (!coverImage.ready && showCoverNowPlaying)
                            Image {
                                anchors.fill: parent
                                source: "qrc:images/pictogram.svg"
                                sourceSize.width: Screen.width / 2
                                sourceSize.height: Screen.width / 2
                            }
                        }
                    }
                    Item {
                        id: landscapeImageRow
                        width: parent.width
                        height: albumImgLandscape.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        Image {
                            id: albumImgLandscape
                            source: coverimageurl
                            width: (parent.width / 2)
                            height: width
                            anchors {
                                top: parent.top
                                left: parent.left
                            }
                            cache: false
                            fillMode: Image.PreserveAspectCrop
                            Rectangle {
                                color: Theme.rgba(
                                           Theme.highlightBackgroundColor,
                                           Theme.highlightBackgroundOpacity)
                                anchors.fill: parent
                                visible: albumImgLandscape.status != Image.Ready
                                Image {
                                    anchors.fill: parent
                                    source: "qrc:images/pictogram.svg"
                                    sourceSize.width: Screen.width / 2
                                    sourceSize.height: Screen.width / 2
                                }
                            }
                        }
                        Image {
                            id: artistImgLandscape
                            source: artistimageurl
                            width: (parent.width / 2)
                            height: width
                            anchors {
                                top: parent.top
                                left: albumImgLandscape.right
                                leftMargin: Theme.paddingSmall
                            }
                            cache: false
                            fillMode: Image.PreserveAspectCrop
                            Rectangle {
                                color: Theme.rgba(
                                           Theme.highlightBackgroundColor,
                                           Theme.highlightBackgroundOpacity)
                                anchors.fill: parent
                                visible: artistImgLandscape.status != Image.Ready
                                Image {
                                    anchors.fill: parent
                                    source: "qrc:images/pictogram.svg"
                                    sourceSize.width: Screen.width / 2
                                    sourceSize.height: Screen.width / 2
                                }
                            }
                        }
                        Rectangle {
                            anchors.fill: parent
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.5
                                    color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
                                }
                                GradientStop {
                                    position: 0.7
                                    color: Qt.rgba(0.0, 0.0, 0.0, 0.3)
                                }
                                GradientStop {
                                    position: 1.0
                                    color: Qt.rgba(0.0, 0.0, 0.0, 1.0)
                                }
                            }
                        }

                        Column {
                            id: landscapeTextScrollColumn
                            anchors {
                                bottom: parent.bottom
                            }
                            width: landscapeImageRow.width

                            ScrollLabel {
                                id: titleTextLC
                                text: title
                                color: Theme.highlightColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: albumTextLC
                                text: album
                                color: Theme.primaryColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: artistTextLC
                                text: artist
                                color: Theme.primaryColor
                                font.pixelSize: fontsize
                                width: parent.width
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                        }
                    }
                    // Spacing hack
                    Rectangle {
                        opacity: 0.0
                        // Center landscapeimages
                        height: (currentSongPage.height - landscapeImageRow.height) / 2
                        width: parent.width
                        visible: landscapeImageRow.visible
                    }

                    ScrollLabel {
                        id: titleText
                        text: title
                        color: Theme.highlightColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                    ScrollLabel {
                        id: albumText
                        text: album
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                    ScrollLabel {
                        id: artistText
                        text: artist
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        spacing: (width / 2) * 0.1
                        Label {
                            id: nrText
                            width: (parent.width / 2) * 0.95
                            text: qsTr("Track nr: ") + mTrackNr
                            color: Theme.primaryColor
                            font.pixelSize: fontsize
                            wrapMode: "WordWrap"
                        }

                        Label {
                            id: playlistnrText
                            width: (parent.width / 2) * 0.95
                            text: qsTr("Playlist nr: ") + (lastsongid + 1) + "/" + mPlaylistlength
                            color: Theme.primaryColor
                            font.pixelSize: fontsize
                            wrapMode: "WordWrap"
                            horizontalAlignment: Text.AlignRight
                        }
                    }

                    ScrollLabel {
                        id: bitrateText
                        text: mBitrate + ", " + mAudioProperties
                        color: Theme.secondaryColor
                        font.pixelSize: fontsize
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                    // Label {
                    //     id: audiopropertiesText
                    //     text: qsTr("Properties: " + mAudioProperties)
                    //     color: Theme.primaryColor
                    //     font.pixelSize: fontsize
                    //     wrapMode: "WordWrap"
                    // }
                    Label {
                        id: fileText
                        text: qsTr("URI: " + mUri)
                        color: Theme.primaryColor
                        font.pixelSize: fontsize
                        wrapMode: "WrapAnywhere"

                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                }
            }
        }

        backgroundSize: volumeControl.height + positionSlider.height + playbackControls.height
        background: Column {
            id: backgroundColumn
            anchors.fill: parent
            Item {
                id: volumeControl
                width: parent.width
                height: volumeSlider.height
                state: "sliderInvisible"
                states: [
                    State {
                        name: "sliderVisible"
                        PropertyChanges {
                            target: volumeSlider
                            enabled: true
                            opacity: 1.0
                        }
                        PropertyChanges {
                            target: volumeButton
                            enabled: false
                            opacity: 0.0
                        }
                    },
                    State {
                        name: "sliderInvisible"
                        PropertyChanges {
                            target: volumeSlider
                            enabled: false
                            opacity: 0.0
                        }
                        PropertyChanges {
                            target: volumeButton
                            enabled: true
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        NumberAnimation {
                            properties: "opacity"
                            duration: 500
                        }
                    }
                ]

                IconButton {
                    id: volumeButton
                    anchors.centerIn: parent
                    icon.source: "image://theme/icon-m-speaker"
                    onClicked: {
                        volumeControl.state = "sliderVisible"
                        volumeSliderFadeOutTimer.start()
                    }
                    icon.onStatusChanged: {
                        if (icon.status == Image.Error) {
                            // Try old icon name before Sailfish 2.0
                            icon.source = "image://theme/icon-status-volume-max"
                        }
                    }
                }

                VolumeSlider {
                    id: volumeSlider
                    anchors.fill: parent
                }

                Timer {
                    id: volumeSliderFadeOutTimer
                    interval: 3000
                    repeat: false
                    onTriggered: {
                        volumeControl.state = "sliderInvisible"
                    }
                }
            }

            PositionSlider {
                id: positionSlider
                width: parent.width
                onPressedChanged: {
                    mPositionSliderActive = pressed
                }
            }

            PlaybackControls {
                id: playbackControls
            }
        }
    }

    onStatusChanged: {
        if ((status === PageStatus.Activating)
                || (status === PageStatus.Active)) {
            pageactive = true
            quickControlPanel.hideControl = true
        } else {
            quickControlPanel.hideControl = false
            pageactive = false
        }
    }

    states: [
        State {
            name: "portrait"
            PropertyChanges {
                target: coverImage
                visible: true
            }
            PropertyChanges {
                target: titleText
                visible: true
            }
            PropertyChanges {
                target: artistText
                visible: true
            }
            PropertyChanges {
                target: albumText
                visible: true
            }
            PropertyChanges {
                target: mainDrawer
                open: true
            }
            PropertyChanges {
                target: landscapeImageRow
                visible: false
            }
            PropertyChanges {
                target: drawerCloseTimer
                running: false
            }
            PropertyChanges {
                target: drawerOpenBackgroundItem
                enabled: false
            }
            PropertyChanges {
                target: playbackControls.shuffleButton
                visible: true
            }
            PropertyChanges {
                target: playbackControls.repeatButton
                visible: true
            }
        },
        State {
            name: "landscape"
            PropertyChanges {
                target: coverImage
                visible: false
            }
            PropertyChanges {
                target: titleText
                visible: false
            }
            PropertyChanges {
                target: artistText
                visible: false
            }
            PropertyChanges {
                target: albumText
                visible: false
            }
            PropertyChanges {
                target: mainDrawer
                open: false
            }
            PropertyChanges {
                target: landscapeImageRow
                visible: true
            }
            PropertyChanges {
                target: drawerOpenBackgroundItem
                enabled: true
            }
            PropertyChanges {
                target: playbackControls.shuffleButton
                visible: false
            }
            PropertyChanges {
                target: playbackControls.repeatButton
                visible: false
            }
        }
    ]
    state: ((orientation === Orientation.Portrait)
            || (orientation === Orientation.PortraitInverted)) ? "portrait" : "landscape"

    Timer {
        id: drawerCloseTimer
        interval: 5000
        repeat: false
        onTriggered: {
            mainDrawer.hide()
        }
    }
}
