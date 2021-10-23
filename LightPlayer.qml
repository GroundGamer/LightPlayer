import QtQuick 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.12

import PyGame 1.0
import MusicDAS 1.0

ApplicationWindow {
    title: qsTr("Light Player")
    width: 800
    height: 600
    minimumWidth: 800
    minimumHeight: 600
    visible: true

    Material.theme: Material.Dark
    Material.accent: Material.DeepPurple

    Rectangle {
        id: wrapper
        width: 800
        height: 600
        color: "#0d0d0d"
        anchors.fill: parent

        RowLayout {
            id: layout
            x: 387
            y: 20
            width: wrapper.width/2.1
            height: wrapper.height - 100
            anchors.leftMargin: 30
            anchors.left: currentMusicRow.right
            anchors.bottomMargin: 80
            anchors.bottom: wrapper.bottom

            Rectangle {
                id: listBackground
                x: 357
                y: 20
                Layout.fillHeight: parent
                Layout.fillWidth: parent
                Layout.maximumWidth: 750
                color: "#131313"

                ScrollView {
                    id: scrollView1
                    x: 0
                    y: 0
                    width: listBackground.width
                    height: listBackground.height
                    topPadding: 10
                    leftPadding: 10
                    rightPadding: 10

                    ListView {
                        id: listView
                        x: -555
                        y: 0
                        width: listBackground.width
                        height: listBackground.height

                        spacing: 5

                        delegate: Item {
                            x: 5
                            width: 80
                            height: 40

                            Rectangle {
                                id: myItem
                                color: "#242424"
                                width: listView.width - 10
                                height: 40
                                radius: 10

                                MouseArea {
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    onEntered: myItem.color = "black"
                                    onExited: myItem.color = "#242424"
                                    onClicked: {
                                        controlMusic.printTest(music.get(index).source)
                                        sound.source = music.get(index).source
                                        bandName.text = music.get(index).band
                                        musicName.text = music.get(index).name
                                        play_pause_button.enabled = true
                                        nextMusicBtn.enabled = true
                                        prevMusicBtn.enabled = true
                                        shuffleBtn.enabled = true
                                        repeatBtn.enabled = true
                                        volumeIcon.enabled = true
                                        volumeBar.enabled = true

                                        if(sound.state == PyGameSound.PlayingState){
                                            sound.runningMusic = 0
                                            sound.runningMusicMin = 0
                                            sound.runningStaticMusicMin = 0
                                            sound.runningStaticMusicSec = 0
                                            musicCurrent1.opacity = 0.0
                                            musicCurrent1.enabled = false
                                            musicCurrent.opacity = 1.0
                                            musicCurrent.enabled = true
                                            sound.stop()
                                            play_pause_button.text = "\u25b7"
                                            play_pause_button.font.pointSize = 14
                                        }
                                        else if(sound.state == PyGameSound.PausedState){
                                            sound.runningMusic = 0
                                            sound.runningMusicMin = 0
                                            sound.runningStaticMusicMin = 0
                                            sound.runningStaticMusicSec = 0
                                            sound.stop()
                                            musicCurrent1.opacity = 0.0
                                            musicCurrent1.enabled = false
                                            musicCurrent.opacity = 1.0
                                            musicCurrent.enabled = true
                                            play_pause_button.text = "\u25b7"
                                            play_pause_button.font.pointSize = 14
                                        }
                                    }

                                    Row {
                                        id: row1
                                        spacing: 8
                                        anchors.leftMargin: 8
                                        anchors.fill: parent

                                        Image {
                                            Layout.preferredHeight: 30
                                            Layout.preferredWidth: 30
                                            source: img
                                            Layout.alignment: Qt.AlignVCenter
                                            clip:true
                                        }
                                        Text {
                                            text: band
                                            topPadding: 10
                                            font.bold: true
                                            font.family: "Acme"
                                            font.pointSize: 12
                                            color: "#f2f2f2"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            clip: true
                                            elide: Text.ElideRight
                                            Layout.maximumWidth: 100
                                        }

                                        Text {
                                            text: diveder
                                            topPadding: 12
                                            font.pointSize: 10
                                            font.family: "Acme"
                                            color: "#f2f2f2"
                                            Layout.alignment: Qt.AlignVCenter
                                            elide: Text.ElideRight
                                            clip:true
                                        }

                                        Text {
                                            text: name
                                            topPadding: 12
                                            font.pointSize: 10
                                            font.family: "Acme"
                                            color: "#f2f2f2"
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                            clip: true
                                            elide: Text.ElideRight
                                            Layout.maximumWidth: 100
                                        }
                                    }
                                }
                            }
                        }
                        model: ListModel {
                        id: music
                        }
                    }
                }
            }
        }

        MusicDownloadAndSetup{
            id: controlMusic
            onAddMusicList: {music.append({"indexName": controlMusic.indexName,"band": controlMusic.actorName,
                                                    "diveder":"/", "name": controlMusic.titleName,
                                                    "source":controlMusic.sourceName}), music.sync()}
        }

        PyGameSound{
            id: sound
            notifyInterval: 10
            notifyIntervalTimeMusic: 10
            source: ''
            volume: 1.0
            progress: 0
            runningMusic: 0
            runningMusicMin: 0
            runningStaticMusicMin: 0
            runningStaticMusicSec: 0
            onError: console.log(message)
            onChangedStateFinal: {
                sound.runningMusic = 0
                sound.runningMusicMin = 0
                sound.runningStaticMusicMin = 0
                sound.runningStaticMusicSec = 0
                sound.stop()
                musicCurrent1.opacity = 0.0
                musicCurrent1.enabled = false
                musicCurrent.opacity = 1.0
                musicCurrent.enabled = true
                play_pause_button.text = "\u25b7"
                play_pause_button.font.pointSize = 14
            }
        }

        Rectangle {
            id: bottomCover
            x: 0
            y: 520
            width: wrapper.width
            height: 80
            color: "#151515"
            anchors.bottom: parent.bottom

            Row {
                id: mainBtns
                x: 320
                y: 19
                width: 160
                height: 50
                anchors.verticalCenterOffset: 4
                anchors.horizontalCenterOffset: 6
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                transformOrigin: Item.Center
                spacing: 0

                RoundButton {
                    id: prevMusicBtn
                    width: 55
                    height: 45
                    text: "◁◁"
                    enabled: false
                    font.pointSize: 12
                    font.bold: false
                    font.strikeout: false
                    font.underline: false
                    font.family: "Tahoma"
                    anchors.verticalCenter: parent.verticalCenter
                }

                RoundButton {
                    id: play_pause_button
                    width: 50
                    height: 50
                    text: "\u25b7"
                    enabled: false
                    display: AbstractButton.TextBesideIcon
                    anchors.verticalCenter: parent.verticalCenter

                    font {
                        weight: Font.ExtraBold
                        capitalization: Font.MixedCase
                        strikeout: false
                        pointSize: 14
                        family: "Tahoma"
                        bold: false
                        underline: false
                        italic: false
                    }
                    onClicked: {
                        if(sound.state == PyGameSound.StoppedState){
                            sound.play()
                            play_pause_button.text = "||"
                            play_pause_button.font.pointSize = 7
                        }
                        else if(sound.state == PyGameSound.PlayingState){
                            sound.pause()
                            play_pause_button.text = "\u25b7"
                            play_pause_button.font.pointSize = 14
                        }
                        else if(sound.state == PyGameSound.PausedState){
                            sound.unPause()
                            play_pause_button.text = "||"
                            play_pause_button.font.pointSize = 7
                        }
                    }
                }

                RoundButton {
                    id: nextMusicBtn
                    width: 55
                    height: 45
                    text: "▷▷"
                    enabled: false
                    font.pointSize: 12
                    font.bold: false
                    font.strikeout: false
                    font.underline: false
                    font.family: "Tahoma"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                id: musicLength
                x: 765
                y: 14
                color: "#f2f2f2"
                text: "0:00"
                font.family: "Acme"
                font.bold: false
                font.pixelSize: 14
                anchors.rightMargin: 20
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 45
            }

            Text {
                id: musicCurrent
                x: 10
                y: 14
                opacity: 1.0
                enabled: true
                color: "#f2f2f2"
                text: sound.runningMusicMin+':0'+sound.runningMusic
                font.family: "Acme"
                font.bold: false
                font.pixelSize: 14
                anchors.leftMargin: 20
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 45
                onTextChanged: {
                    if(sound.runningMusic >= 10){
                        musicCurrent.opacity = 0.0
                        musicCurrent.enabled = false
                        musicCurrent1.opacity = 1.0
                        musicCurrent1.enabled = true
                    }
                    if(sound.runningStaticMusicMin != 0){
                        musicLength.text = sound.runningStaticMusicMin+":"+sound.runningStaticMusicSec
                    }
                }
            }

            Text {
                id: musicCurrent1
                x: 10
                y: 14
                opacity: 0.0
                enabled: false
                color: "#f2f2f2"
                text: sound.runningMusicMin+':'+sound.runningMusic
                font.family: "Acme"
                font.bold: false
                font.pixelSize: 14
                anchors.leftMargin: 20
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 45
                onTextChanged: {
                    if(sound.runningMusicMin >= 1){
                        musicCurrent1.opacity = 0.0
                        musicCurrent1.enabled = false
                        musicCurrent.opacity = 1.0
                        musicCurrent.enabled = true
                    }
                }
            }

            Row {
                id: extraBtns
                x: 157
                y: 19
                width: 100
                height: 50

                anchors.horizontalCenterOffset: -160
                anchors.horizontalCenter: parent.horizontalCenter

                RoundButton {
                    id: repeatBtn
                    width: 50
                    height: 50
                    text: "\u27f2"
                    enabled: false
                    checkable: true
                    font.bold: false
                    font.pointSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    topPadding: 8
                }

                RoundButton {
                    id: shuffleBtn
                    width: 50
                    height: 50
                    text: "\u292e"
                    enabled: false
                    checkable: true
                    font.pointSize: 14
                    font.bold: false
                    anchors.verticalCenter: parent.verticalCenter
                    topPadding: 8
                }
            }

            Row {
                id: volumeSlider
                x: 524
                y: 21
                width: 179
                height: 44
                anchors.horizontalCenterOffset: 200
                anchors.horizontalCenter: parent.horizontalCenter

                RoundButton {
                    id: volumeIcon
                    text: "🕪"
                    hoverEnabled: false
                    enabled: false
                    font.weight: Font.Light
                    font.underline: false
                    font.italic: false
                    font.bold: false
                    font.pointSize: 11
                    font.family: "Acme"
                    rotation: -180
                    onClicked: {
                        if(sound.stateVolume == PyGameSound.EnabledSound){
                            sound.disabledVolume()
                            volumeBar.value = 0.0
                            sound.volume = 0.0
                        }
                        else if(sound.stateVolume == PyGameSound.DisabledSound){
                            sound.enabledVolume()
                            volumeBar.value = 0.3
                            sound.volume = 0.3
                        }
                    }
                }

                Slider {
                    id: volumeBar
                    width: 130
                    height: 43
                    value: 0.5
                    enabled: false
                    onMoved: { sound.volume = value }
                }
            }

            ProgressBar {
                id: musicProgressBar
                x: 0
                y: 0
                width: wrapper.width
                height: 5
                indeterminate: false
                value: sound.progress
            }
        }

        ColumnLayout {
            id: currentMusicRow
            anchors.horizontalCenterOffset: wrapper.width / -4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            Rectangle {
                id: currentPicBackground
                x: 273
                y: 20
                width: 260
                height: 260
                color: "#151515"
                Layout.alignment: Qt.AlignHCenter

                    Image {
                        id: currentMusicPic
                        x: 2
                        y: 2
                        anchors.fill: parent
                        anchors.margins: 2
                        source: "images/lightplayer.png"
                        fillMode: Image.Stretch
                    }
                }

            RowLayout {
                id: titleMusicLayout
                width: 220
                height: 30
                spacing: 5
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.bottomMargin: -50
                Layout.maximumWidth: wrapper.width/3

                Text {
                    id: bandName
                    color: "#f2f2f2"
                    text: '---'
                    style: Text.Normal
                    font.capitalization: Font.MixedCase
                    font.italic: false
                    font.weight: Font.Medium
                    font.underline: false
                    font.family: "Acme"
                    font.bold: false
                    font.pixelSize: 22
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    clip: true
                    elide: Text.ElideRight
                    Layout.maximumWidth: 100

                    MouseArea {
                        id: bandMouseArea
                        width: parent.width+2
                        height: parent.height+2
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: 0
                        anchors.centerIn: parent
                        hoverEnabled: true
                    }

                    Popup {
                        id: popup
                        height: 20
                        y: bandName.y +25
                        clip: true
                        modal: true
                        dim: false
                        focus: false
                        closePolicy: Popup.NoAutoClose

                        background: Rectangle {
                            anchors.fill: parent
                            color: "#151515"
                            opacity: 0.9

                        }

                        contentItem: Text {
                            text: bandName.text
                            color: "#f2f2f2"
                            font.family: "Acme"
                            opacity: 0.9
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter

                        }
                    }
                }

                Text {
                    id: diveder
                    color: "#f2f2f2"
                    text: "|"
                    font.bold: false
                    font.pixelSize: 22
                    font.family: "Tahoma"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }

                Text {
                    id: musicName
                    color: "#f2f2f2"
                    text: '---'
                    font.weight: Font.Light
                    font.bold: false
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    clip: true
                    elide: Text.ElideRight
                    Layout.maximumWidth: 100
                    font.family: "Acme"

                    MouseArea {
                        id: musicNameMouseArea
                        width: musicName.width
                        height: musicName.height
                        anchors.centerIn: parent
                        hoverEnabled: true
                    }

                    Popup {
                        id: popup1
                        height: 20
                        y: musicName.y +20
                        clip: true
                        modal: true
                        dim: false
                        focus: false
                        closePolicy: Popup.NoAutoClose

                        background: Rectangle {
                            anchors.fill: parent
                            color: "#151515"
                            opacity: 0.9

                        }

                        contentItem: Text {
                            text: musicName.text
                            color: "#f2f2f2"
                            font.family: "Acme"
                            opacity: 0.9
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter

                        }
                    }
                }
            }

                Text {
                    id: addText
                    x: 37
                    y: 319
                    color: "#f2f2f2"
                    text: qsTr("ADD music")
                    font.capitalization: Font.MixedCase
                    font.underline: false
                    font.italic: false
                    font.strikeout: false
                    font.bold: true
                    opacity: 0.6
                    font.family: "Acme"
                    font.pixelSize: 24
                    Layout.rightMargin: -2
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    Layout.bottomMargin: -100

                    MouseArea {
                        id: addBtnMouseArea
                        x: -12
                        y: -5
                        width: 148
                        height: 28
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: 59
                        anchors.centerIn: parent
                        hoverEnabled: true
                        onClicked: {controlMusic.addMusic()}
                    }
                }


                Text {
                    id: deleteText
                    x: 37
                    y: 365
                    color: "#f2f2f2"
                    text: qsTr("DELETE music")
                    font.underline: false
                    font.bold: true
                    opacity: 0.6
                    font.family: "Acme"
                    font.pixelSize: 24
                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    Layout.rightMargin: 1
                    Layout.bottomMargin: -135

                    MouseArea {
                        id: deleteBtnMouseArea
                        x: -12
                        y: -8
                        width: 176
                        height: 32
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: 73
                        anchors.centerIn: parent
                        hoverEnabled: true
                    }
                }
            }

        /* Конекты */
        Connections {
            target: bandMouseArea
            onExited: {bandName.font.underline = false, popup.visible = false}
        }
        Connections {
            target: bandMouseArea
            onEntered: {bandName.font.underline = true, popup.visible = true}
        }

        Connections {
            target: musicNameMouseArea
            onEntered: {musicName.font.underline = true, popup1.visible =true}
        }

        Connections {
            target: musicNameMouseArea
            onExited: {musicName.font.underline = false, popup1.visible =false}
        }

        Connections {
            target: addBtnMouseArea
            onEntered: {addText.opacity = 1; plusBtn.opacity = 1}
        }

        Connections {
            target: addBtnMouseArea
            onExited: {addText.opacity = 0.6; plusBtn.opacity = 0.6}
        }

        Connections {
            target: deleteBtnMouseArea
            onEntered: {deleteText.opacity = 1; minusBtn.opacity = 1}
        }

        Connections {
            target: deleteBtnMouseArea
            onExited: {deleteText.opacity = 0.6; minusBtn.opacity = 0.6}
        }
    }
}