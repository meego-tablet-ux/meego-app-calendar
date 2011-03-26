/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.Calendar 0.1

Item {
    id: alarmCmbData
    height:100
    signal close()

    AlarmListModel {
        id: alarmsModel
    }



    Rectangle {
        id:dataListRect
        anchors.top: parent.top
        color: "white"
        width: parent.width
        height:100
        radius: 5
        border.width: 2
        border.color: "darkGray"
        z:30
        visible:true
        opacity:1


        ListView {
            id: alarmsModelView
            anchors.fill: parent
            clip: true
            model: alarmsModel
            highlight: highlighter
            highlightMoveDuration: 1
            focus: true
            z:30
            opacity: 1

            delegate: Rectangle {
                id: alarmrect
                property int alarmType: type
                property string alarmDesc: description
                color: "transparent"
                height: 30
                width: parent.width

                Text {
                    id:desc
                    text: description
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

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        modelVal = type;
                        selectedVal = desc.text;
                        selectedIndex = index;
                        alarmsModelView.currentIndex = index;
                        alarmsModelView.highlight = highlighter;
                        alarmCmbData.close();
                    }
                }
            }

        }
        MouseArea {
            onClicked: {}
        }
    }

}



