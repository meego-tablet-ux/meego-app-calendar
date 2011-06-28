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
    id: eventListPopup
    property date coreDateVal
    property int eventCount:0
    signal close()

    property int xVal: 0
    property int yVal: 0

    function displayMultiEvents (mouseX, mouseY) {
        eventListPopup.setPosition(mouseX,mouseY)
        xVal = mouseX
        yVal = mouseY
        visible = true;
    }


    function initModel() {
        selectedDayModel.loadGivenDayModel(coreDateVal);
        console.log("Selected day's event count = "+selectedDayModel.count);
        eventCount = selectedDayModel.count;
        eventsList.height = (eventListPopup.eventCount>3)?300:(eventListPopup.eventCount>3*50)
    }

    UtilMethods {
        id:utilities
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    DayViewModel {
        id:selectedDayModel
        modelType:UtilMethods.EAllEvents
    }

    content:Column {
        id:eventViewBox
        property int itemsCount:selectedDayModel.count
        width:300
        height: dateBox.height+200+buttonBox.height

        Item {
            id:dateBox
            height: 30
            width: eventViewBox.width
            Text {
                id: dateText
                text: i18nHelper.localDate(coreDateVal, Labs.LocaleHelper.DateWeekdayMonthDay)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.bold: true
                color:theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeMedium
                width: dateBox.width
                elide: Text.ElideRight
            }
        }
        Image {
            id: dateSpacer
            source: "image://themedimage/images/menu_item_separator"
            width: eventViewBox.width
        }

        Item {
            id:eventsListBox
            height:eventViewBox.height-dateBox.height-buttonBox.height
            width: eventViewBox.width

            ListView {
                id: eventsList
                anchors.fill: parent
                clip: true
                height: parent.height-20
                width:parent.width-20
                anchors.centerIn: parent
                contentHeight: (50*(selectedDayModel.count+1))
                contentWidth: parent.width
                flickableDirection: Flickable.VerticalFlick
                model:  selectedDayModel
                spacing:5

                delegate: Rectangle {
                    id:eventBox
                    height: 50
                    width:parent.width
                    radius: 5
                    //: This is Events Time range ("StartTime - EndTime ") %1 is StartTime and %2 is EndTime
                    property string timeVal:(allDay)?qsTr("All day"):qsTr("%1 - %2","TimeRange" ).arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFull)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFull))
                    Column {
                        spacing: 5
                        anchors.top: parent.top
                        anchors.topMargin: 3
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        Text {
                              id: eventDescription
                              text:summary
                              font.bold: true
                              color:theme_fontColorNormal
                              font.pixelSize: theme_fontPixelSizeMedium
                              width: eventBox.width
                              elide: Text.ElideRight
                         }

                        Text {
                              id: eventTime
                              text: timeVal
                              color:theme_fontColorNormal
                              font.pixelSize: theme_fontPixelSizeMedium
                              width: eventBox.width
                              elide: Text.ElideRight
                         }
                    }
                    ExtendedMouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //: This is Date, Time range ("Event StartDate, StartTime and EndTime String ") %1 is Event StartDate, %2 is StartTime and EndTime string (already translated and passed as argument)
                            var dateTimeStr = qsTr("%1, %2","DateTimeRange").arg(i18nHelper.localDate(coreDateVal, Labs.LocaleHelper.DateFull)).arg(timeVal)
                            window.openViewFromMonthMultiEvents( eventListPopup.xVal,eventListPopup.yVal,window,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),dateTimeStr,coreDateVal,zoneName,zoneOffset);
                            eventListPopup.close();
                            eventListPopup.visible = false;
                        }
                    }

                }//end of delegate
            }//end listview

        }//end eventslistbox

        Image {
            id: buttonSpacer
            source: "image://themedimage/images/menu_item_separator"
            width: eventViewBox.width
        }

        Item {
            id: buttonBox
            width:eventViewBox.width
            height:70
            Button {
                id: closeButton
                height:50
                anchors.centerIn: parent
                bgSourceUp: "image://themedimage/widgets/common/button/button"
                bgSourceDn: "image://themedimage/widgets/common/button/button-pressed"
                text: qsTr("Close")
                hasBackground: true
                onClicked: {
                    eventListPopup.close();
                    eventListPopup.visible = false;
                }
            }
        }//end buttonBox

    }

}
