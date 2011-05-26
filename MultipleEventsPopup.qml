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

    content:Item {
        id:eventViewBox
        property int itemsCount:selectedDayModel.count
        width:300
        height: popupTitleBox.height+dateBox.height+300+buttonBox.height

        Column {
            anchors.top: parent.top
            Item {
                id: popupTitleBox
                width:eventViewBox.width
                height: 50
                Text {
                    id:popupTitleText
                    text: qsTr("Selected events")
                    font.bold: true
                    color:theme_fontColorNormal
                    font.pixelSize: theme_fontPixelSizeMedium
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: popupTitleBox.width
                    elide: Text.ElideRight
                }
            }

            Image {
                id: titleSpacer
                source: "image://theme/menu_item_separator"
                width: eventViewBox.width
            }

            Item {
                id:dateBox
                height: 50
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
                source: "image://theme/menu_item_separator"
                width: eventViewBox.width
            }

            Item {
                id:eventsListBox
                height:eventViewBox.height-popupTitleBox.height-dateBox.height-buttonBox.height
                width: eventViewBox.width
                Item {
                    id:listViewBox
                    height: parent.height-20
                    width:parent.width-20
                    anchors.centerIn: parent
                    ListView {
                        id: eventsList
                        anchors.fill: parent
                        clip: true
                        height:parent.height
                        width:parent.width
                        contentHeight: (75*(selectedDayModel.count+1))
                        contentWidth: parent.width
                        flickableDirection: Flickable.VerticalFlick
                        model:  selectedDayModel
                        spacing:5

                        delegate: Rectangle {
                            id:eventBox
                            height: 75
                            width:parent.width
                            radius: 5
                            property string timeVal:(allDay)?qsTr("All day"):qsTr("%1 - %2","StartTime - EndTime").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort))
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
                                    var dateTimeStr = qsTr("%1, %2","Event StartDate, Start and End Time String").arg(i18nHelper.localDate(coreDateVal, Labs.LocaleHelper.DateFull)).arg(timeVal)
                                    window.openViewFromMonthMultiEvents( eventListPopup.xVal,eventListPopup.yVal,window,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),dateTimeStr,coreDateVal,zoneName,zoneOffset);
                                    eventListPopup.close();
                                    eventListPopup.visible = false;
                                }
                            }

                        }//end of delegate
                    }//end listview
                }

            }//end eventslistbox

            Image {
                id: buttonSpacer
                source: "image://theme/menu_item_separator"
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
                    bgSourceUp: "image://theme/btn_grey_up"
                    bgSourceDn: "image://theme/btn_grey_dn"
                    text: qsTr("Close")
                    hasBackground: true
                    onClicked: {
                        eventListPopup.close();
                        eventListPopup.visible = false;
                    }

                }

            }

        }//end column        

    }

}
