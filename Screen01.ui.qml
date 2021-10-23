import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Rectangle {
    width: 800
    height: 600
    color: "#0d0d0d"
    property alias roundButton2: roundButton2
    property alias element: element

    Rectangle {
        id: rectangle1
        x: 351
        y: 28
        width: 420
        height: 500
        color: "#131313"

        ScrollView {
            id: scrollView1
            x: 15
            y: 8
            width: 386
            height: 488
            clip: true

            ListView {
                id: listView
                x: -475
                y: -208
                width: 401
                height: 439
                spacing: 5

                delegate: Item {
                    x: 5
                    width: 80
                    height: 40

                    Rectangle {
                        id: myItem
                        color: "#242424"
                        width: 382
                        height: 40
                        radius: 10

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent

                            onEntered: myItem.color = "black"
                            onExited: myItem.color = "#242424"

                            Row {
                                id: row1
                                spacing: 5
                                anchors.leftMargin: 8
                                anchors.fill: parent

                                Image {
                                    width: 30
                                    height: 30
                                    source: img
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: band
                                    font.bold: true
                                    color: "#f2f2f2"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: diveder
                                    font.bold: false
                                    color: "#f2f2f2"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: name
                                    font.bold: false
                                    color: "#f2f2f2"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
                model: ListModel {
                    ListElement {
                        band: "Imagine Dragons"
                        diveder: "/"
                        name: "I'm so soryy"
                        img: "images/volume_icon.png"
                    }

                    ListElement {
                        band: "Imagine Dragons"
                        diveder: "/"
                        name: "I'm so soryy"
                        img: "images/maxresdefault.jpg"
                    }
                    ListElement {
                        band: "Imagine Dragons"
                        diveder: "/"
                        name: "I'm so soryy"
                        img: "images/volume_icon.png"
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 520
        width: 800
        height: 80
        color: "#151515"

        RoundButton {
            id: roundButton2
            x: 370
            y: 15
            width: 50
            height: 50
            text: "\u25b7"
            font.weight: Font.ExtraBold
            font.capitalization: Font.MixedCase
            font.strikeout: false
            font.underline: false
            font.italic: false
            display: AbstractButton.TextBesideIcon
            font.bold: false
            font.pointSize: 14
            font.family: "Tahoma"
            onClicked: {
                con.outputStrMP3("Play")
            }
        }

        RoundButton {
            id: roundButton3
            x: 309
            y: 18
            width: 55
            height: 45
            text: "◁◁"
            font.pointSize: 12
            font.bold: false
            font.strikeout: false
            font.underline: false
            font.family: "Tahoma"
            onClicked: {
                con.outputStrMP3("Prev")
            }
        }

        RoundButton {
            id: roundButton4
            x: 426
            y: 18
            width: 55
            height: 45
            text: "▷▷"
            font.pointSize: 12
            font.bold: false
            font.strikeout: false
            font.underline: false
            font.family: "Tahoma"
            onClicked: {
                con.outputStrMP3("Next")
            }
        }

        Text {
            id: element3
            x: 10
            y: 34
            color: "#f2f2f2"
            text: qsTr("1:18")
            font.bold: false
            font.pixelSize: 12
        }

        Text {
            id: element4
            x: 765
            y: 34
            color: "#f2f2f2"
            text: qsTr("3:12")
            font.bold: false
            font.pixelSize: 12
        }

        RoundButton {
            id: roundButton
            x: 152
            y: 15
            width: 50
            height: 50
            text: "\u27f2"
            checkable: true
            font.bold: false
            font.pointSize: 14
        }

        RoundButton {
            id: roundButton1
            x: 208
            y: 15
            width: 50
            height: 50
            text: "\u292e"
            checkable: true
            font.pointSize: 14
            font.bold: false
        }

        Image {
            id: image
            x: 531
            y: 28
            width: 25
            height: 25
            source: "images/volume_icon.png"
            fillMode: Image.PreserveAspectFit
        }

        Slider {
            id: slider
            x: 562
            y: 32
            width: 120
            height: 17
            value: 0.5
        }

        ProgressBar {
            id: progressBar
            x: 0
            y: 0
            width: 800
            height: 5
            indeterminate: false
            value: 0.3
        }
    }

    Rectangle {
        id: rectangle2
        x: 56
        y: 26
        width: 254
        height: 254
        color: "#151515"

        Image {
            id: image1
            x: 2
            y: 2
            width: 250
            height: 250
            source: "images/maxresdefault.jpg"
            fillMode: Image.Stretch
        }

        RowLayout {
            id: rowLayout
            x: 1
            y: 265
            width: 252
            height: 29

            Text {
                id: element
                width: 155
                height: 28
                color: "#f2f2f2"
                text: qsTr("Glad Valakass")
                font.weight: Font.DemiBold
                style: Text.Normal
                font.underline: false
                font.family: "Tahoma"
                font.bold: false
                font.pixelSize: 22
                MouseArea {
                    id: mouseArea2
                    width: 155
                    height: 28
                    anchors.centerIn: parent
                    hoverEnabled: true
                }
            }

            Text {
                id: element2
                width: 13
                height: 28
                color: "#f2f2f2"
                text: "/"
                font.bold: false
                font.pixelSize: 22
                font.family: "Tahoma"
            }

            Text {
                id: element1
                width: 103
                height: 28
                color: "#f2f2f2"
                text: "relaxation"
                font.weight: Font.Light
                font.bold: false
                font.pixelSize: 22
                font.family: "Arial"
                MouseArea {
                    id: mouseArea3
                    width: 103
                    height: 28
                    anchors.centerIn: parent
                    hoverEnabled: true
                }
            }
        }
    }

    Connections {
        target: mouseArea2
        onEntered: element.font.underline = true
    }

    Connections {
        target: mouseArea2
        onExited: element.font.underline = false
    }

    Connections {
        target: mouseArea3
        onEntered: element1.font.underline = true
    }

    Connections {
        target: mouseArea3
        onExited: element1.font.underline = false
    }
}
