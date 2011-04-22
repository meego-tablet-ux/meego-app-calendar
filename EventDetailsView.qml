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

Labs.AbstractContext {
    id: viewEventDetails    
    z:100
    property string eventId
    property string description
    property string summary
    property string location
    property int alarmType
    property string eventTime
    property date startDate
    //property int xVal:0
   // property int yVal:0
    signal close()
    signal back()
    signal closeSearch()
    property bool showBack:false
    property bool showView:false

    property alias mouseX: viewEventDetails.mouseX
    property alias mouseY: viewEventDetails.mouseY

    function displayDetails (mouseX, mouseY) {
        viewEventDetails.mouseX = mouseX
        viewEventDetails.mouseY = mouseY
        visible = true;
    }


    function initEventDetails(viewVisible,backVisible)
    {
        showBack=backVisible;
        showView=viewVisible;
    }

    function showMultipleEventsPopup(xVal,yVal,coreDateVal,popUpParent) {
        multipleEventsPopupLoader.sourceComponent = multipleEventsPopup
        multipleEventsPopupLoader.item.parent = popUpParent
        multipleEventsPopupLoader.item.coreDateVal = coreDateVal;
        multipleEventsPopupLoader.item.displayMultiEvents(xVal,yVal);
        multipleEventsPopupLoader.item.initModel();
        console.log("Inside showMultipleEventsPopup inside EventDetailsView");
    }

    Loader {
        id:multipleEventsPopupLoader
    }

    Component {
        id:multipleEventsPopup
        MultipleEventsPopup {
            onClose: multipleEventsPopupLoader.sourceComponent = undefined
        }
    }


    CalendarController {
        id:controller
    }

    content: Item {
            id: eventDetailsBox
            height:titleTimeSpacer.height+locRemSpacer.height+showViewSpacer.height+buttonAreaSpacer.height
            width:350

            Column {
                Item {
                    id: titleTimeSpacer
                    width:eventDetailsBox.width
                    height:titleTimeArea.height
                    Item {
                        id:titleTimeArea
                        width:parent.width-20
                        height:(summaryBox.height+timeBox.height+10)
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        Item {
                            id:summaryBox
                            width:titleTimeArea.width
                            height:30
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            Text {
                                id:eventDescTxt
                                text:summary
                                anchors.fill: parent
                                font.pixelSize: theme_fontPixelSizeLarger
                                color:theme_fontColorNormal
                                font.bold: true
                                wrapMode: Text.Wrap
                                width: summaryBox.width
                                elide: Text.ElideRight

                            }
                        }//summaryBox

                        Item {
                            id:timeBox
                            width:titleTimeArea.width
                            height:30
                            anchors.top: summaryBox.bottom
                            anchors.topMargin: 5
                            anchors.leftMargin:10
                            Text {
                                id:eventTimeTxt
                                text:eventTime
                                anchors.fill: parent
                                font.pixelSize: theme_fontPixelSizeMedium
                                color:theme_fontColorNormal
                                width: timeBox.width
                                elide: Text.ElideRight
                            }
                        }//time

                    }//end titleTimeArea
                }//titleTimeSpacer

                Image {
                    id: seperatorImage1
                    source: "image://theme/menu_item_separator"
                    width: eventDetailsBox.width
                }

                Item {
                    id: locRemSpacer
                    width:eventDetailsBox.width
                    height:locRemBox.height
                    //color:"blue"
                    Item {
                        id: locRemBox
                        width:eventDetailsBox.width-20
                        height: locBox.height+descBox.height+reminderBox.height+20
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        Column {
                            spacing:5
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            Item {
                                id:locBox
                                width:locRemBox.width
                                height:(location=="")?0:30
                                //color: "green"
                                Text {
                                    id:eventLocTxt
                                    text:location
                                    anchors.fill: parent
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    font.bold: true
                                    wrapMode: Text.Wrap
                                    width: locBox.width
                                    elide: Text.ElideRight
                                }
                            }//locBox

                            Item {
                                id:descBox
                                width:locRemBox.width
                                height:(description=="")?0:100
                                //color: "purple"
                                clip: true
                                TextEdit {
                                    id:summaryTxt
                                    text:description
                                    anchors.fill: parent
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    wrapMode: Text.Wrap
                                    width: descBox.width
                                    //elide: Text.ElideRight
                                }
                            }//summary

                            Item {
                                id:reminderBox
                                width:locRemBox.width
                                height:40
                                //color: "yellow"
                                Text {
                                    id:reminderLabel
                                    text: qsTr("Reminder: ")
                                    font.bold: true
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    anchors.left: parent.left
                                    width: reminderBox.width
                                    elide: Text.ElideRight
                                }

                                Text {
                                    id:reminderTxt
                                    text:utilities.getAlarmString(alarmType)
                                    anchors.left:parent.left
                                    anchors.top: reminderLabel.bottom
                                    anchors.topMargin: 3
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    width: reminderBox.width
                                    elide: Text.ElideRight
                                }
                            }//reminder
                        }//end of column

                    }//locRemBox

                }//locRemSpacer

                Item {
                    id: showViewSpacer
                    width:eventDetailsBox.width
                    height:(viewEventDetails.showView)?50:0
                    visible:(viewEventDetails.showView)?true:false
                    Image {
                        id: seperatorImage2
                        source: "image://theme/menu_item_separator"
                        width: eventDetailsBox.width
                    }
                    Item {
                        id:showViewButton
                        width:buttonBox.width-20
                        anchors.left: parent.left
                        anchors.leftMargin:10
                        anchors.verticalCenter: parent.verticalCenter
                        height: 30
                        Text {
                            id:showViewTxt
                            text:  qsTr("Show in calendar view")
                            anchors.centerIn: parent
                            font.pixelSize: theme_fontPixelSizeLarge
                            color:theme_fontColorHighlight
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Inside Show in Calendar View mouseArea,startDate="+startDate.toString("dd mmm yyyy"));
                                scene.dateFromOutside = startDate;
                                scene.gotoDate=true;
                                viewEventDetails.closeSearch();
                                viewEventDetails.visible = false;
                            }
                        }

                    }//showViewButton
                }//showViewSpacer

                Image {
                    id: seperatorImage3
                    source: "image://theme/menu_item_separator"
                    width: eventDetailsBox.width
                }

                Item {
                    id:buttonAreaSpacer
                    width:eventDetailsBox.width
                    height:50
                    Item {
                        id:buttonBox
                        width:eventDetailsBox.width -20
                        height: 30
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        property real buttonWidth: (showBack)?(buttonBox.width/(3.5)):(buttonBox.width/(2.5))

                        Row {
                            spacing:5
                            anchors.centerIn: parent
                            Button {
                                id: backButton
                                visible:(viewEventDetails.showBack)?true:false
                                height:(viewEventDetails.showBack)?30:0
                                bgSourceUp: "image://theme/btn_grey_up"
                                bgSourceDn: "image://theme/btn_grey_dn"
                                text: qsTr("Back")
                                hasBackground: true
                                onClicked: {
                                        //showMultipleEventsPopup(viewEventDetails.mouseX,viewEventDetails.mouseY,startDate,scene.container);
                                        viewEventDetails.close();
                                        viewEventDetails.visible = false;
                                }
                            }//backButton


                            Button {
                                id: editButton
                                height:30
                                bgSourceUp: "image://theme/btn_blue_up"
                                bgSourceDn: "image://theme/btn_blue_dn"
                                text: qsTr("Edit")
                                hasBackground: true
                                onClicked: {
                                    scene.editEvent(mouseX,mouseY,eventId);
                                    viewEventDetails.close();
                                    viewEventDetails.visible = false;
                                }
                            }//editbutton


                            Button {
                                id: closeButton
                                height:30
                                bgSourceUp: "image://theme/btn_grey_up"
                                bgSourceDn: "image://theme/btn_grey_dn"
                                text: qsTr("Close")
                                hasBackground: true
                                onClicked: {
                                    viewEventDetails.close();
                                    viewEventDetails.visible = false;
                                }
                            }//closebutton

                        }//end row


                    }//buttonBox


                }//buttonAreaSpacer

            }//end column

    }//eventDetailsBox

}//Item
