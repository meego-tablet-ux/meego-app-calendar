/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.Calendar 0.1
import MeeGo.Components 0.1
import MeeGo.Labs.Components 0.1 as Labs

AppPage {
    id: centerPane
    pageTitle: qsTr("Day")
    property int offset:0
    property date dateInFocus:initDate()
    property string dateInFocusVal
    property int currDayIndex:0    
    property int allDayEventsCount:allDayViewModel.count
    property int xVal:0
    property int yVal:0
    actionMenuModel:  [ qsTr("Create new event"), qsTr("Go to today"), qsTr("Go to date")]
    actionMenuPayload: [0,1,2]
    onActionMenuIconClicked: {
        xVal = mouseX;
        yVal = mouseY;
    }

    onActionMenuTriggered: {
        switch (selectedItem) {
            case 0: {
                window.openNewEventView(xVal,yVal,false);
                break;
            }
            case 1: {
                window.gotoToday=true;
                break;
            }
            case 2: {
                window.openDatePicker();
                break;
            }
        }
    }

    function initDate()
    {
        var tmpDate = utilities.getCurrentDateVal();
        dateInFocus = tmpDate;
        window.appDateInFocus = dateInFocus;
        window.eventDay=tmpDate.getDate();
        window.eventMonth=(tmpDate.getMonth()+1);
        window.eventYear=tmpDate.getFullYear();
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
    }


    Connections {
        target:window
        onGotoDateChanged: {
            if(window.gotoDate) {
                dateInFocus =  window.dateFromOutside;
                window.appDateInFocus = dateInFocus;
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                timeListModel.loadGivenDayModel(dateInFocus);
                dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
                timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                window.gotoDate=false;
            }
        }

        onGotoTodayChanged: {
            if(window.gotoToday) {
                initDate();
                daysModel.loadGivenWeekValuesFromDate(dateInFocus);
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                timeListModel.loadGivenDayModel(dateInFocus);
                timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                window.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(window.addedEvent) {
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                timeListModel.loadGivenDayModel(dateInFocus);
                timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                window.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(window.deletedEvent) {
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                timeListModel.loadGivenDayModel(dateInFocus);
                timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                window.deletedEvent = false;
            }
        }

        onTriggeredExternallyChanged: {
            if(window.triggeredExternally) {
                dateInFocus =  window.dateFromOutside;
                window.appDateInFocus = dateInFocus;
                dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                timeListModel.loadGivenDayModel(dateInFocus);
                timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                window.triggeredExternally = false;
            }
        }
    }


    function resetCalendarDayModels(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        allDayViewModel.loadGivenDayModel(coreDateVal);
        allDayEventsCount = allDayViewModel.count;
        timeListModel.loadGivenDayModel(coreDateVal);
        window.eventDay=tmpDate.getDate();
        window.eventMonth=(tmpDate.getMonth()+1);
        window.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        window.appDateInFocus = dateInFocus;
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
        timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
    }

    function resetFocus(offset)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,(offset),0,0);
        window.appDateInFocus = dateInFocus;
        resetCalendarDayModels(dateInFocus);
    }

    function isDateInFocus(coreDateVal)
    {
       return utilities.datesEqual(coreDateVal,dateInFocus);
    }

    function isCurrentDate(coreDateVal,index)
    {
        var now = new Date();
        var refDate = new Date(utilities.getLongDate(coreDateVal))
        if((now.getDate()==refDate.getDate()) && (now.getMonth()==refDate.getMonth()) && (now.getFullYear()==refDate.getFullYear())) {
            currDayIndex = index;
            return true;
        } else {
            return false;
        }
    }

    function displayContextMenu(xVal,yVal,uid,component,loader,popUpParent,description,summary,location,alarmType,repeatString,startDate,startTime,endTime,zoneOffset,allDay)
    {
        loader.sourceComponent = component
        loader.item.parent = popUpParent
        loader.item.mapX = xVal;
        loader.item.mapY = yVal;
        loader.item.eventId = uid;
        loader.item.description = description;
        loader.item.summary = summary;
        loader.item.location = location;
        loader.item.alarmType = alarmType;
        loader.item.repeatText = repeatString;
        loader.item.zoneOffset = zoneOffset;
        loader.item.startDate = startDate;
        loader.item.startTime = startTime;
        loader.item.endTime = endTime;
        loader.item.allDay = allDay;
        loader.item.initMaps();
    }

    Loader {
        id:popUpLoader
    }

    Component {
        id: eventActionsPopup
        EventActionsPopup {
            onClose: {
                popUpLoader.sourceComponent = undefined;
            }
        }
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    UtilMethods {
        id: utilities
    }

    CalendarWeekModel {
        id:daysModel
    }

    TimeListModel {
        id:timeListModel
        dateVal:dateInFocus
    }

    DayViewModel {
        id:allDayViewModel
        modelType:UtilMethods.EAllDay
        dateVal:dateInFocus
        Component.onCompleted: {
            centerPane.allDayEventsCount = allDayViewModel.count;
        }
    }

    TopItem {
        id:dayViewTopItem
    }

    Column {
        id: dayViewData
        spacing: 2
        anchors.fill:parent

        HeaderComponentView {
            id:navHeader
            width: dayViewTopItem.topWidth
            height: 50
            dateVal: dateInFocusVal
            onNextTriggered: {
                daysModel.loadGivenWeekValuesFromOffset(dateInFocus,1);
                resetFocus(1);
            }
            onPrevTriggered: {
                daysModel.loadGivenWeekValuesFromOffset(dateInFocus,-1);
                resetFocus(-1);
            }
        }

        BorderImage {
            id: spacerImage
            height:dayViewTopItem.topHeight - (navHeader.height)
            width: dayViewTopItem.topWidth
            source: "image://theme/titlebar_l"

            Rectangle {
                id: calData
                height:dayViewTopItem.topHeight - (navHeader.height)-20
                width: dayViewTopItem.topWidth-20
                anchors.centerIn: parent
                color: "lightgray"
                border.width:2
                border.color: "gray"

                Column {
                    id:stacker

                    Item {
                        id:dayBox
                        width:calData.width
                        height:100
                        Row {
                            id:dayRow
                            anchors.horizontalCenter: dayBox.horizontalCenter
                            anchors.top: dayBox.top

                            Repeater {
                                id: dayRepeater
                                property int dayIndex:0
                                property int prevIndex:0
                                model: daysModel
                                Rectangle {
                                    id:dateValBox
                                    width:dayBox.width/(7)
                                    height: 40
                                    border.width:2
                                    border.color: (isDateInFocus(coreDateVal))?"white":"gray"
                                    color:(isDateInFocus(coreDateVal))?"white":"lightgray"

                                    Text {
                                          id: dateValTxt
                                          text:i18nHelper.localDate(coreDateVal,Labs.LocaleHelper.DateWeekdayDayShort) //dateValString
                                          font.bold: true
                                          color:isCurrentDate(coreDateVal,index)?theme_buttonFontColorActive:theme_fontColorNormal
                                          font.pixelSize: (window.inLandscape)?theme_fontPixelSizeLarge:theme_fontPixelSizeMedium
                                          anchors.verticalCenter: parent.verticalCenter
                                          anchors.horizontalCenter: parent.horizontalCenter
                                          elide: Text.ElideRight
                                     }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dayRepeater.prevIndex = dayRepeater.dayIndex;
                                            dayRepeater.dayIndex = index;
                                            dateValBox.color = "white"
                                            resetCalendarDayModels(coreDateVal);
                                        }
                                    }
                                }
                                onDayIndexChanged: {
                                    dayRow.children[prevIndex].color = "lightgray"
                                    if(prevIndex != currDayIndex) {
                                        dayRow.children[currDayIndex].color = "lightgray"
                                    }
                                }

                            }//end of repeater
                        }//end of Row

                        Rectangle {
                            id: allDayBox
                            height: 60
                            width:calData.width
                            anchors.top:dayRow.bottom
                            color:"white"
                             Row {
                                 id:allDayRow
                                 anchors.top: allDayBox.top
                                 anchors.left: allDayBox.left
                                 anchors.margins: 10
                                 Item {
                                     id: allDayTextIconBox
                                     height:allDayBox.height
                                     width: allDayText.width+allDayIconBox.width
                                     z:1

                                     Item {
                                         id:allDayTextBox
                                         width:allDayText.width
                                         height: 30
                                         anchors.top: allDayTextIconBox.top
                                         Text {
                                             id: allDayText
                                             text: qsTr("All day")
                                             //anchors.centerIn: parent
                                             font.bold: true
                                             color:theme_fontColorNormal
                                             font.pixelSize: (window.inLandscape)?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
                                             elide: Text.ElideRight
                                         }
                                     }//end alldaytextbox

                                     Item {
                                         id: allDayIconBox
                                         height:20
                                         width:30
                                         anchors.bottom: allDayTextIconBox.bottom
                                         anchors.bottomMargin: 5
                                         anchors.horizontalCenter: parent.horizontalCenter
                                         visible:(allDayEventsCount>1)?1:0
                                         z:500
                                         BorderImage {
                                             id:allDayIcon
                                             source:"image://theme/popupbox_arrow_bottom"
                                             anchors.fill: parent
                                         }

                                         MouseArea {
                                             anchors.fill: parent
                                             onClicked: {
                                                 allDayIcon.source="";
                                                 allDayBox.height=100
                                             }
                                         }
                                     }//end of alldayiconbox
                                     ExtendedMouseArea {
                                         anchors.fill: parent
                                         onClicked: {
                                             dayViewTopItem.calcTopParent();
                                             var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                             window.openNewEventView(map.x,map.y,true);
                                         }
                                     }
                                 }//allDayTextIconBox

                                 //Display the all day events here
                                 Item {
                                    id: allDayEventsDisplayBox
                                    height:allDayBox.height
                                    width: allDayBox.width-allDayTextIconBox.width-2*allDayRow.anchors.margins
                                    z:1

                                    Item {
                                        id:allDayDisplayBox
                                        height:(allDayEventsCount>0)?(parent.height-5):0
                                        width: parent.width-20
                                        anchors.centerIn:parent
                                        z:500
                                        ListView {
                                            id:allDayView
                                            anchors.fill: parent
                                            clip: true
                                            model: allDayViewModel
                                            spacing: 3
                                            delegate: Item {
                                                id: calItemBox
                                                height: 30
                                                width: allDayDisplayBox.width
                                                BorderImage {
                                                     id:allDayImage
                                                     source:"image://theme/calendar/calendar_event"
                                                     anchors.fill: parent
                                                     Item {
                                                         id: allDayDescBox
                                                         height: parent.height
                                                         width:parent.width
                                                         anchors.top: parent.top
                                                         Text {
                                                             id: allDayDescText
                                                             text: (index==2 && (allDayViewModel.count>3))?qsTr("%1 more events exist","Events count").arg(allDayViewModel.count-2):summary
                                                             anchors.left: parent.left
                                                             anchors.leftMargin: 20
                                                             anchors.verticalCenter: parent.verticalCenter
                                                             color:theme_fontColorNormal
                                                             font.pixelSize:theme_fontPixelSizeMedium
                                                             width:allDayDescBox.width
                                                             elide: Text.ElideRight
                                                         }
                                                     }//end allDayDescBox

                                                     ExtendedMouseArea {
                                                          anchors.fill:parent
                                                          onPressedAndMoved: {
                                                               allDayDescText.text = summary;
                                                          }

                                                          onClicked: {
                                                              allDayDescBox.focus = true;
                                                              if(index ==2 && (allDayViewModel.count>3)) {
                                                                  allDayDescText.text = summary;
                                                              }
                                                              var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                              window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,allDay,false,false);

                                                          }
                                                          onLongPressAndHold: {
                                                              var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                              displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,allDayImage,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,allDay);
                                                          }

                                                  }//ExtendedMouseArea

                                                }

                                            }
                                        }
                                    }
                                    ExtendedMouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            dayViewTopItem.calcTopParent();
                                            var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                            window.openNewEventView(map.x,map.y,true);
                                        }
                                    }

                                 }//end alldayeventsdisplaybox
                             }

                         }//end of alldaybox


                    }//end of dayBox


                    Image {
                        id:headerDivider
                        width: calData.width
                        source: "image://theme/menu_item_separator"
                    } //end of headerDivider

                    Rectangle {
                         id: centerContent
                         height: calData.height-dayBox.height-50
                         width: calData.width
                         border.width:2
                         border.color: "gray"
                         color:"white"

                         ListView {
                             id: timeListView
                             anchors.fill: parent
                             clip: true
                             model:timeListModel
                             contentHeight:(timeListModel.count)*(50)
                             contentWidth: timeListView.width
                             cacheBuffer: (timeListModel.count)*50-timeListView.height // Set cacheBuffer to remain the scroll area content.
                             z:1
                             focus: true
                             boundsBehavior: Flickable.StopAtBounds
                             delegate: Item {
                                         id: calTimeValBox
                                         height: 50
                                         width: centerContent.width
                                         z:-model.index
                                         Rectangle {
                                             id: timeValBox
                                             height: parent.height
                                             width:calData.width/12
                                             color: "transparent"
                                             anchors.left: parent.left
                                             border.width:2
                                             border.color: "lightgray"

                                             Text {
                                                 id: timeValText
                                                 text: timeVal
                                                 anchors.top:parent.top
                                                 anchors.horizontalCenter:parent.horizontalCenter
                                                 font.bold: true
                                                 color:theme_fontColorNormal
                                                 font.pixelSize: (window.inLandscape)?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
                                                 elide: Text.ElideRight
                                             }
                                         }//end timeValBox
                                         Rectangle {
                                             id: vacantAreaBox
                                             height: parent.height
                                             width: parent.width-timeValBox.width
                                             anchors.left: timeValBox.right
                                             color:"transparent"
                                             border.width:2
                                             border.color: "lightgray"
                                             property int parentIndex:index
                                             z:2

                                             Repeater {
                                                 id:calDataItemsList
                                                 model: dataModel
                                                 focus: true
                                                 delegate:Item {
                                                     id: displayRect
                                                     height: (heightUnits*vacantAreaBox.height)
                                                     width: 9*(widthUnits*vacantAreaBox.width)/10
                                                     x:(xUnits+xUnits*displayRect.width)+5
                                                     BorderImage {
                                                         id:regEventImage
                                                         source:"image://theme/calendar/calendar_event"
                                                         anchors.fill: parent
                                                         z:1000
                                                         Item {
                                                             id:descriptionBox
                                                             width: 8*(displayRect.width/9)
                                                             height:displayRect.height
                                                             anchors.left: parent.left
                                                             anchors.leftMargin: 5
                                                             Column {
                                                                 spacing: 2
                                                                 anchors.top: parent.top
                                                                 anchors.topMargin: 3
                                                                 anchors.leftMargin: 3
                                                                 Text {
                                                                       id: eventDescription
                                                                       text:summary
                                                                       font.bold: true
                                                                       color:theme_fontColorNormal
                                                                       font.pixelSize: theme_fontPixelSizeMedium
                                                                       width: descriptionBox.width
                                                                       elide: Text.ElideRight
                                                                  }

                                                                 Text {
                                                                       id: eventTime
                                                                       text: qsTr("%1 - %2","StartTime - EndTime").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort));
                                                                       color:theme_fontColorNormal
                                                                       width: descriptionBox.width
                                                                       font.pixelSize:theme_fontPixelSizeMedium
                                                                       elide: Text.ElideRight
                                                                  }
                                                             }
                                                         }

                                                         ExtendedMouseArea {
                                                             anchors.fill: parent
                                                             onClicked: {
                                                                 var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                                 window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,allDay,false,false)
                                                             }
                                                             onLongPressAndHold: {
                                                                 var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                                 displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,regEventImage,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,allDay);
                                                             }
                                                         }
                                                     }
                                                 }
                                             }//end repeater

                                         }//Inner rectangle with delegate to view the cal events

                                         ExtendedMouseArea {
                                             anchors.fill: parent
                                             onClicked: {
                                                 window.eventStartHr=startHr;
                                                 window.eventEndHr=endHr;
                                                 dayViewTopItem.calcTopParent();
                                                 var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                 window.openNewEventView(map.x,map.y,false);
                                             }
                                             onLongPressAndHold: {
                                                 window.eventStartHr=startHr;
                                                 window.eventEndHr=endHr;
                                                 dayViewTopItem.calcTopParent();
                                                 var map = mapToItem (dayViewTopItem.topItem, mouseX, mouseY);
                                                 window.openNewEventView(map.x,map.y,false);
                                             }
                                         }

                                     }//end calTimeValBox

                             Component.onCompleted: {
                                 timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                             }

                         }

                     }//end centerContent

                }//end of Column inside calData


            }//end of calData

        }//end of spacerImage
    }//end of top column

}
