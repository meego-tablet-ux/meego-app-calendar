/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.Calendar 0.1
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1

Item {
    id: centerPane

    property alias listModel:eventsListModel
    property int listIndex:0
    property string uId
    property string eventDescription
    property string eventSummary
    property string eventLocation
    property int eventAlarmType:0
    property string eventEventTime
    property bool eventAllDay:false
    property date eventDate
    property int searchCount:window.searchResultCount
    signal close();

    Connections {
        target:window
        onSearchResultCountChanged: {
            searchCount = window.searchResultCount;
            results.text = qsTr("%1 results found","Search result count").arg(searchCount)
        }
    }

    CalendarListModel {
        id:eventsListModel
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    Component {
        id: highlighter
        Rectangle {
            z:50
            color: "green"
            opacity: 0.5
        }
    }

    Component {
        id: highlighteroff
        Rectangle {
            color: "transparent"
        }
    }


    Rectangle {
        id: eventsListBox
        anchors.fill: parent
        color: "lightgray"
        Item {
            id:searchResultsBox
            width:parent.width
            height:50
            Text {
                id:results
                text: qsTr("%1 results found","Search result count").arg(searchCount)
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.bold: true
                color:theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarger
            }
        }

        ListView {
            id: calendarEventsList
            anchors.top: searchResultsBox.bottom
            height:parent.height-searchResultsBox.height
            width:parent.width
            clip: true
            model: eventsListModel
            highlight: highlighteroff
            highlightMoveDuration: 1
            currentIndex: listIndex
            delegate: Rectangle {
                id: displayBox
                height: 75
                width:parent.width
                Column {
                    anchors.top: parent.top
                    Rectangle {
                        id: dateBox
                        height:displayBox.height/3
                        width:displayBox.width
                        color:"gray"
                        Text {
                            id:dateText
                            text:i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFullLong)
                            font.bold: true
                            color:theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeLarge
                            anchors.left:parent.left
                            anchors.leftMargin: 10
                        }
                    }
                    Item {
                        id: titleBox
                        height:displayBox.height/3
                        width:displayBox.width
                        Text {
                            id:titleText
                            text: summary
                            font.bold: true
                            color:theme_fontColorNormal
                            font.pixelSize: theme_fontPixelSizeMedium
                            anchors.left:parent.left
                            anchors.leftMargin: 10
                            Rectangle{
                                anchors.top: parent.top
                                id: highlight
                                color:"green"
                                height:parent.height
                                width:widthUnits*titleText.font.pixelSize
                                x:(xUnits>0)?(xUnits-1)*titleText.font.pixelSize:xUnits*titleText.font.pixelSize
                                z:500
                                opacity:0.5
                            }
                        }
                    }

                    Item {
                        id: timeBox
                        height:displayBox.height/3
                        width:displayBox.width
                        Text {
                            id:timeText
                            text: allDay?qsTr("All day"):qsTr("%1 - %2","StartTime - EndTime").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFull)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFull));
                            font.bold: true
                            font.pixelSize: theme_fontPixelSizeMedium
                            color:theme_fontColorInactive
                            anchors.left:parent.left
                            anchors.leftMargin: 10
                        }
                    }
                }//end column
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        calendarEventsList.currentIndex = index;
                        calendarEventsList.highlight = highlighter;                       
                        var map = mapToItem (window, mouseX, mouseY);
                        window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay,true,false);
                    }
                }
            }//end delegate rectangle
        }//end listview
    }//end Rectangle o listview

}
