/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1

Item {
    id: tzCmbData
    height:100
    signal close()

    TimezoneListModel {
        id: timezonelist
    }

    Rectangle {
        id:dataListRect
        anchors.top: parent.top
        color: "white"
        width: parent.width
        height:300
        radius: 5
        border.width: 2
        border.color: "darkGray"
        z:30
        visible:true
        opacity:1
        clip: true


        ListView {
            id: listmodel
            anchors.fill: parent
            clip: true
            model: timezonelist
            highlight: highlighter
            highlightMoveDuration: 5
            focus: true
            z:5000
            opacity: 1

            delegate: Rectangle {
                id: timerect
                property int gmt: gmtoffset
                property string clockname: city
                color: "transparent"
                height: 30
                width: parent.width

                Text {
                    id:name
                    text: title
                    anchors.left: parent.left
                    anchors.leftMargin:10
                    anchors.verticalCenter: parent.verticalCenter
                    color:theme_fontColorNormal
                    font.pixelSize:theme_fontPixelSizeMedium
                    font.bold: false
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                Text {
                    id:value
                    text:(gmtoffset < 0)? (qsTr(("(GMT %1%2)").arg(gmtoffset).arg(":00"))):(qsTr(("(GMT +%1%2)").arg(gmtoffset).arg(":00")))
                    anchors.left: name.right
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color:theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeMedium
                    font.bold: false
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        modelVal = gmtoffset*3600
                        selectedVal = name.text;
                        selectedIndex = index;
                        listmodel.currentIndex = index;
                        listmodel.highlight = highlighter;
                        tzCmbData.close();
                    }
                }
            }

        }
        MouseArea {
            onClicked: {}
        }
    }

}



