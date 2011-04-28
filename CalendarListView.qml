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
    property int searchCount:scene.searchResultCount
    signal close();

    function openView (xVal,yVal,component,loader,popUpParent,dateVal)
    {
        loader.sourceComponent = component
        loader.item.parent = popUpParent
        loader.item.eventId = uId;
        loader.item.description = eventDescription;
        loader.item.summary = eventSummary;
        loader.item.location = eventLocation;
        loader.item.alarmType = eventAlarmType;
        loader.item.eventTime = eventEventTime;
        loader.item.startDate = dateVal;
        loader.item.initEventDetails(true,false);
        loader.item.displayDetails(xVal,yVal);
    }

    Connections {
        target:scene
        onSearchResultCountChanged: {
            searchCount = scene.searchResultCount;
            results.text = qsTr("%1 results found").arg(searchCount)
        }
    }

    Loader {
        id:eventDetailsLoader
    }

    Component {
        id:viewDetails
        EventDetailsView {
            id:viewEventDetails
            eventId:eventId
            onClose: {
                eventDetailsLoader.sourceComponent = undefined
            }
            onCloseSearch: {
                centerPane.close();
                eventDetailsLoader.sourceComponent = undefined
            }
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
        height:scene.content.height
        width: scene.content.width
        color: "lightgray"

        Item {
            id:searchResultsBox
            width:parent.width
            height:50
            Text {
                id:results
                text: qsTr("%1 results found").arg(searchCount)
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
                            text: allDay?qsTr("All day"):qsTr("%1 - %2").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort));
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
                        uId = uid;
                        eventDescription = description;
                        eventSummary = summary;
                        eventLocation = location;
                        eventAlarmType = alarmType;
                        eventEventTime = allDay?qsTr("%1, ").arg(i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull))+qsTr("All day"):qsTr("%1 - %2").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort));
                        var dateVal = new Date(utilities.getLongDate(startDate));
                        var map = mapToItem (scene.content, mouseX, mouseY);
                        openView (map.x,map.y,viewDetails,eventDetailsLoader,scene.container,dateVal);
                    }
                }
            }//end delegate rectangle
        }//end listview
    }//end Rectangle o listview

}
