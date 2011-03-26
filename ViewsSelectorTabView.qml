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
    id: container

    property int topicHeight: 35
    property alias model: listView.model
    signal topicTriggered(int index)
    property alias currentTopic: listView.currentIndex
    property alias interactive: listView.interactive

    ViewCalendarModel {
        id:viewCalModel
    }

    ListView {
        id: listView
        anchors.fill: parent

        onCurrentIndexChanged: container.topicTriggered(currentIndex)

        model: viewCalModel
        highlight: Rectangle {
            width: listView.width;
            height: container.topicHeight;
            color: "#281832"
        }
        highlightMoveDuration: 1
        delegate: Item {
            id: contentItem
            width: container.width
            height: container.topicHeight

            property int index: type


            Image {
                id: leftImage
                width:  parent/4
                height: container.topicHeight
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                source: icon
            }


            Text {
                id: contentLabel
                height: container.topicHeight
                width: container.width - leftImage.width
                text: description
                font.pointSize: 12
                color: "white"
                elide:Text.ElideRight
                anchors.left: leftImage.right
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
            }


            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("before selection "+listView.currentIndex)
                    listView.currentIndex = index
                    console.log("After selection "+listView.currentIndex)
                }
            }
        }
    }
}
