/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.App.Calendar 0.1
import MeeGo.Components 0.1

Item {
    id:navHeader
    z: 100
    property string dateVal:qsTr("Date")
    function closeMenu() { optionsMenu.visible = false; }

    signal prevTriggered()
    signal nextTriggered()

    function initHeaderDate(index) {
        console.log("Inside initheaderdata");
        dateVal = utilities.getCurrentDate();
        dateText.text = dateVal;
    }



    UtilMethods {
        id:utilities
    }

    Rectangle {
       color: "lightgray"
       anchors.fill: parent
       opacity: 0.5

    }

    Item {
        id: innerNavigation
        height: 30
        width: (window.inLandscape)? (window.width/2):(2*(window.height/3))
        anchors.centerIn: parent
        anchors.margins: 5
        anchors.top: parent.top
        Image {
            id: prevArrow
            anchors.left: innerNavigation.left
            anchors.top:  innerNavigation.top
            anchors.verticalCenter: parent.verticalCenter
            source: "image://themedimage/images/arrow-left"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Inside prevarrow");
                    navHeader.prevTriggered();
                }
            }
        }


        Text {
            id: dateText
            text: dateVal
            anchors.fill: parent
            anchors.centerIn: parent
            height: parent.height
            width: (window.inLandscape)?200:150
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color:theme_fontColorNormal
            font.pixelSize: theme_fontPixelSizeLarge
        }


        Image {
            id: nextArrow
            anchors.left: innerNavigation.right
            anchors.top:  innerNavigation.top
            anchors.verticalCenter: parent.verticalCenter
            source: "image://themedimage/images/arrow-right"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Inside nextarrow");
                    navHeader.nextTriggered();
                }
            }
        }

    } //end of innerNavigation Buttons

} //end of Item
