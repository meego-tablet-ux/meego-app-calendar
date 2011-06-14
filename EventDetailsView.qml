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

ContextMenu {
    id: viewEventDetails    
    property string eventId
    property string description
    property string summary
    property string location
    property string repeatText
    property int alarmType
    property string eventTime
    property date startDate
    property variant startTime
    property variant endTime
    property int zoneOffset
    property string zoneName
    property bool allDay
    property int xVal:0
    property int yVal:0
    signal close()
    signal back()
    signal closeSearch()
    property bool showBack:false
    property bool showView:false
    property int windowWidth:350

    function displayDetails (mouseX, mouseY) {
        viewEventDetails.setPosition(mouseX,mouseY)
        xVal = mouseX;
        yVal = mouseY;
        if(allDay) {
            eventTime = qsTr("All day");
        } else  {
            //: This is Date, Time range ("Event StartDate, StartTime - EndTime ") %1 is Event StartDate, %2 is StartTime and %3 is EndTime
            eventTime = qsTr("%1, %2 - %3").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFull)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFull));
        }
        viewEventDetails.title = summary;
        visible = true;
    }


    function initEventDetails(viewVisible,backVisible)
    {
        showView=viewVisible;
        showBack=backVisible;
    }

    function showMultipleEventsPopup(xVal,yVal,coreDateVal,popUpParent) {
        multipleEventsPopupLoader.sourceComponent = multipleEventsPopup
        multipleEventsPopupLoader.item.parent = popUpParent
        multipleEventsPopupLoader.item.coreDateVal = coreDateVal;
        multipleEventsPopupLoader.item.displayMultiEvents(xVal,yVal);
        multipleEventsPopupLoader.item.initModel();
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

    content: Item {
            id: eventDetailsBox
            height:titleTimeSpacer.height+locRemSpacer.height+showViewSpacer.height+buttonAreaSpacer.height
            width:windowWidth

            Column {
                Item {
                    id: titleTimeSpacer
                    width:eventDetailsBox.width
                    height:titleTimeArea.height
                    Item {
                        id:titleTimeArea
                        width:parent.width-20
                        height:(timeBox.height+10)
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        Item {
                            id:timeBox
                            width:titleTimeArea.width
                            height:60
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.leftMargin:10
                            Text {
                                id:eventTimeTxt
                                //: This is EventTime followed by GMT offset ("%1 is event time and %2 is GMT offset")
                                text:qsTr("%1 (GMT %2)").arg(eventTime).arg(zoneOffset/(60*60))
                                font.pixelSize: theme_fontPixelSizeMedium
                                color:theme_fontColorNormal
                                width: timeBox.width
                                elide: Text.ElideRight
                            }

                            Text {
                                id:repeatValText
                                //: This corresponds to Repeats frequency text. %1 is frequency of the event and %2 is the translated text for "Repeats"
                                text: qsTr("%1 %2").arg(qsTr("Repeats")).arg(repeatText)
                                anchors.top: eventTimeTxt.bottom
                                font.pixelSize: theme_fontPixelSizeMedium
                                color:theme_fontColorNormal
                                width: timeBox.width
                                elide: Text.ElideRight
                            }
                        }//time

                    }//end titleTimeArea
                }//titleTimeSpacer


                Item {
                    id: locRemSpacer
                    width:eventDetailsBox.width
                    height:locRemBox.height
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
                                height:(location=="")?0:50
                                TextField {
                                    id:eventLocTxt
                                    text:location
                                    anchors.fill: parent
                                    font.bold: true
                                    readOnly: true
                                }

                            }//locBox

                            Item {
                                id:descBox
                                width:locRemBox.width
                                height:(description=="")?0:80
                                clip: true
                                TextField {
                                    id:summaryTxt
                                    text:description
                                    anchors.fill: parent
                                    readOnly: true
                                    width: descBox.width
                                }
                            }//summary

                            Row {
                                id:reminderBox
                                Text {
                                    id:reminderLabel
                                    text: qsTr("Reminder: ")
                                    font.bold: true
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    //width: reminderBox.width/3
                                    //elide: Text.ElideRight
                                }

                                Text {
                                    id:reminderTxt
                                    text:utilities.getAlarmString(alarmType)
                                    font.pixelSize: theme_fontPixelSizeMedium
                                    color:theme_fontColorNormal
                                    //width: 2*reminderBox.width/3
                                    //elide: Text.ElideRight
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
                        source: "image://themedimage/images/menu_item_separator"
                        width: eventDetailsBox.width
                    }
                    Item {
                        id:showViewButton
                        width:parent.width-20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
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
                                window.dateFromOutside = startDate;
                                window.gotoDate=true;
                                window.showToolBarSearch = false;
                                viewEventDetails.visible = false;
                            }
                        }

                    }//showViewButton
                }//showViewSpacer

                Image {
                    id: seperatorImage3
                    source: "image://themedimage/images/menu_item_separator"
                    width: eventDetailsBox.width
                }

                Item {
                    id:buttonAreaSpacer
                    width:eventDetailsBox.width;
                    height:50

                    Button {
                        id: editButton
                        height:40
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        bgSourceUp: "image://themedimage/widgets/common/button/button-default"
                        bgSourceDn: "image://themedimage/widgets/common/button/button-default-pressed"
                        text: qsTr("Edit")
                        hasBackground: true
                        onClicked: {
                            viewEventDetails.hide();
                            window.editEvent(xVal,yVal,eventId);
                        }
                    }//editbutton

                }//buttonAreaSpacer

            }//end column

    }//eventDetailsBox

}//Item
