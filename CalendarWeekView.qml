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
import Qt.labs.gestures 2.0

AppPage {
    id: centerPane
    pageTitle: qsTr("Week")
    property int offset:0
    property date dateInFocus:initDate()
    property string dateInFocusVal
    property int currDayIndex:0
    property int dayInFocusIndex:0
    property int xVal:0
    property int yVal:0
    actionMenuModel:  [ qsTr("Create new event"), qsTr("Go to today"), qsTr("Go to date")]
    actionMenuPayload: [0,1,2]
    allowActionMenuSignal: true
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
        dateInFocus = window.appDateInFocus;
        var startDate = utilities.getStartDateOfWeek(dateInFocus);
        var endDate = utilities.getEndDateOfWeek(startDate);
        dateInFocusVal = qsTr("%1 - %2","Week's StartDate - Week's EndDate").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFull));
        dayInFocusIndex = dateInFocus.getDay();
        if(dayInFocusIndex==0) {//i.e if day is sunday
            dayInFocusIndex = 7;
        }
        dayInFocusIndex--;
        resetCalendarDayModels(dateInFocus);
    }


    Connections {
        target:window
        onGotoDateChanged: {
            if(window.gotoDate) {
                window.gotoDate=false;
                dateInFocus =  window.dateFromOutside;
                window.appDateInFocus = dateInFocus;
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                var startDate = utilities.getStartDateOfWeek(dateInFocus);
                var endDate = utilities.getEndDateOfWeek(startDate);
                dateInFocusVal = qsTr("%1 - %2","Week's StartDate - Week's EndDate").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFull));
                dayInFocusIndex = dateInFocus.getDay();
                if(dayInFocusIndex==0) {//i.e if day is sunday
                    dayInFocusIndex = 7;
                }
                dayInFocusIndex--;
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
            }
        }

        onGotoTodayChanged: {
            if(window.gotoToday) {
                window.appDateInFocus = utilities.getCurrentDateVal();
                initDate();
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                window.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(window.addedEvent) {
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                window.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(window.deletedEvent) {
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                window.deletedEvent = false;
            }
        }

    }

    function resetCalendarDayModels(coreDateVal) {
        dateInFocus = coreDateVal;
        window.appDateInFocus = dateInFocus;
        var startDate = utilities.getStartDateOfWeek(dateInFocus);
        var endDate = utilities.getEndDateOfWeek(startDate);
        dateInFocusVal = qsTr("%1 - %2","Week's StartDate - Week's EndDate").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFull));
        daysModel.loadGivenWeekValuesFromDate(dateInFocus);
        eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
    }

    function setDateInFocus(coreDateVal)
    {
        dateInFocus = coreDateVal;
        window.appDateInFocus = dateInFocus;
    }

    function resetFocus(offset)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,(offset*7),0,0);
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


    function displayContextMenu(xVal,yVal,uid,component,loader,popUpParent,description,summary,location,alarmType,repeatString,startDate,startTime,endTime,zoneOffset,zoneName,allDay)
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
        loader.item.zoneName = zoneName;
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
            onClose: popUpLoader.sourceComponent = undefined
        }
    }

    UtilMethods {
        id: utilities
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    CalendarWeekModel {
        id:daysModel
        //weekStartIndex:1
    }

    TimeListModel {
        id:timeListModel
    }

    TopItem {
        id:weekViewTopItem
    }

    Column {
        id: weekViewData
        spacing: 2
        anchors.fill:parent
        HeaderComponentView {
            id:navHeader
            width: weekViewTopItem.topWidth
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

        Rectangle {
            id:spacerbox
            height:weekViewTopItem.topHeight - (navHeader.height)
            width: weekViewTopItem.topWidth
            color:"lightgray"

            Rectangle {
                id: calDataBox
                height:weekViewTopItem.topHeight - (navHeader.height)-20
                width: weekViewTopItem.topWidth-20
                anchors.centerIn: parent
                color: "white"
                border.width:2
                border.color: "gray"
                z:100

                Column {
                    id:stacker
                    Item {
                        id:dayBox
                        width:calDataBox.width
                        height:100
                        Row {
                            id:dayRow
                            Repeater {
                                id: dayRepeater
                                property int dayIndex:0
                                property int prevIndex:0
                                model: daysModel
                                Column {
                                    id:allDayColumn
                                    property int topIndex:index

                                    Rectangle {
                                        id:dateValBox
                                        width:(dayBox.width/7)
                                        height: dayBox.height/2
                                        border.width:1
                                        border.color: (isDateInFocus(coreDateVal))?"lightgray":"lightgray"
                                        color:(isDateInFocus(coreDateVal))?"lightgray":"white"

                                        Text {
                                              id: dateValTxt
                                              text:i18nHelper.localDate(coreDateVal,Labs.LocaleHelper.DateWeekdayDayShort)
                                              color:isCurrentDate(coreDateVal,index)?theme_buttonFontColorActive:theme_fontColorNormal
                                              font.pixelSize: (window.inLandscape)?theme_fontPixelSizeLarge:theme_fontPixelSizeMedium
                                              anchors.centerIn: parent
                                              elide: Text.ElideRight
                                         }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                setDateInFocus(coreDateVal);
                                                dayInFocusIndex = index;
                                            }
                                        }
                                    }//end dateValBox

                                    Rectangle {
                                        id:allDayBox
                                        width: dayBox.width/7
                                        height: dayBox.height/2
                                        border.width:1
                                        border.color:(isDateInFocus(coreDateVal))?"lightgray":"lightgray"
                                        property int parentIndex:index
                                        color:(isDateInFocus(coreDateVal))?"lightgray":"white"

                                        DayViewModel {
                                            id:allDayViewModel
                                            modelType:UtilMethods.EAllDay
                                            dateVal:coreDateVal
                                        }

                                        Text {
                                            id:allDayText
                                            text: qsTr("All Day")
                                            color:theme_fontColorNormal
                                            font.pixelSize: theme_fontPixelSizeSmaller
                                            anchors.top:parent.top
                                            anchors.left:parent.left
                                            anchors.leftMargin: 5
                                            anchors.topMargin: 5
                                            elide: Text.ElideRight
                                            visible:(isDateInFocus(coreDateVal))? true:false
                                        }

                                        Item {
                                            id:allDayDisplayBox
                                            height:(allDayViewModel.count>0)?(parent.height-4):0
                                            width: parent.width
                                            anchors.centerIn: parent
                                            z:500
                                            ListView {
                                                id:allDayView
                                                anchors.fill: parent
                                                clip: true
                                                model: allDayViewModel
                                                spacing: 1
                                                property int itemCount: allDayViewModel.count

                                                delegate: Item {
                                                    id: calItemBox
                                                    height: allDayBox.height/3
                                                    width: allDayBox.width-4
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.leftMargin: 2

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
                                                                anchors.leftMargin: 2
                                                                anchors.verticalCenter: parent.verticalCenter
                                                                color:theme_fontColorNormal
                                                                font.pixelSize: theme_fontPixelSizeSmaller
                                                                width:allDayDescBox.width
                                                                elide: Text.ElideRight
                                                            }//end desc
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
                                                                    weekViewTopItem.calcTopParent();
                                                                    var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                                    window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay,false,false);
                                                                }
                                                                onLongPressAndHold: {
                                                                    weekViewTopItem.calcTopParent();
                                                                    var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                                    displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,calItemBox,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay);
                                                                }

                                                            }//ExtendedMouseArea
                                                        }//end allDayDescBox

                                                    }//end allDayImage
                                                }//end calItemBox

                                            }//end listview

                                        }//end allDayDisplayBox

                                        ExtendedMouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                weekViewTopItem.calcTopParent();
                                                var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                window.openNewEventView(map.x,map.y,true);
                                            }
                                        }


                                    }//end alldaybox
                                }//end of allDayColumn
                            }//end of dayRepeater
                        }//end of dayRow
                    }//end dayBox

                    Image {
                        id:headerDivider
                        width: calDataBox.width
                        source: "image://theme/menu_item_separator"
                    } //end of headerDivider

                    Item {
                         id: centerContent
                         height: calDataBox.height-dayBox.height-80
                         width: calDataBox.width
                         property real cellHeight:50
                         property real cellWidth: dayBox.width/7
                         property int timeListCount:timeListModel.count

                         Flickable {
                            id: eventsListView
                            anchors.top: parent.top
                            height: centerContent.height
                            width: centerContent.width
                            contentHeight: (centerContent.timeListCount)*(centerContent.cellHeight)
                            contentWidth: centerContent.width
                            clip: true
                            focus: true
                            boundsBehavior: Flickable.StopAtBounds

                            Row {
                                id:weekDayRow
                                Repeater {
                                    id: weekDayRepeater
                                    model: daysModel
                                    Rectangle {
                                        id:weekDayBox
                                        height: (centerContent.timeListCount)*centerContent.cellHeight
                                        width: centerContent.cellWidth
                                        property int weekDayIndex:index
                                        color:(dayInFocusIndex==weekDayIndex)?"lightgray":"white"
                                        TimeListModel {
                                            id:timeModel
                                            dateVal:coreDateVal
                                        }

                                        ListView {
                                            id:weekDayListView
                                            anchors.fill:parent
                                            contentHeight: weekDayBox.height
                                            contentWidth: weekDayBox.width
                                            clip:true
                                            interactive: false
                                            model:timeModel
                                            delegate: Rectangle {
                                                id: vacantAreaBox
                                                height: centerContent.cellHeight
                                                width: centerContent.cellWidth
                                                border.width:1
                                                border.color: "lightgray"
                                                property int parentIndex:index
                                                color: "transparent"
                                                z:-model.index

                                                Text {
                                                    id:timeValText
                                                    text:(index%2==0)?i18nHelper.localTime(timeVal, Labs.LocaleHelper.TimeFull):""
                                                    anchors.top:parent.top
                                                    anchors.left:parent.left
                                                    anchors.leftMargin: 5
                                                    color:theme_fontColorNormal
                                                    font.pixelSize: (window.inLandscape)?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
                                                    elide: Text.ElideRight
                                                    visible:(dayInFocusIndex==weekDayIndex)?true:false
                                                }

                                                Repeater {
                                                    id:calDataItemsList
                                                    model: dataModel
                                                    focus: true
                                                    delegate:Item {
                                                        id: displayRect
                                                        height: (heightUnits*vacantAreaBox.height)
                                                        width: 9*(widthUnits*vacantAreaBox.width)/10
                                                        x:(xUnits+xUnits*displayRect.width)+1
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
                                                                anchors.leftMargin: 2
                                                                Column {
                                                                    spacing: 2
                                                                    anchors.top: parent.top
                                                                    anchors.topMargin: 2
                                                                    anchors.leftMargin: 2
                                                                    Text {
                                                                          id: eventDescription
                                                                          text:summary
                                                                          font.bold: true
                                                                          color:theme_fontColorNormal
                                                                          font.pixelSize: theme_fontPixelSizeSmall
                                                                          width:descriptionBox.width
                                                                          elide: Text.ElideRight
                                                                     }

                                                                    Text {
                                                                          id: eventTime
                                                                          text: qsTr("%1 - %2","StartTime - EndTime").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFull)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFull));
                                                                          color:theme_fontColorNormal
                                                                          font.pixelSize:theme_fontPixelSizeSmall
                                                                          width:descriptionBox.width
                                                                          elide: Text.ElideRight
                                                                     }
                                                                }
                                                            }


                                                            ExtendedMouseArea {
                                                                anchors.fill: parent
                                                                onClicked: {
                                                                    weekViewTopItem.calcTopParent();
                                                                    var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                                    window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay,false,false);
                                                                }
                                                                onLongPressAndHold: {
                                                                    weekViewTopItem.calcTopParent();
                                                                    var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                                    displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,displayRect,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay);
                                                                }
                                                            }
                                                        }
                                                        z:200
                                                    }
                                                }//end Repeater

                                                GestureArea {
                                                   anchors.fill: parent
                                                   Swipe {
                                                        onFinished: {
                                                            console.log("Swipe Angle="+gesture.swipeAngle);
                                                             if(gesture.horizontalDirection == 1)  { //QSwipeGesture::Right
                                                                  daysModel.loadGivenWeekValuesFromOffset(dateInFocus,1);
                                                                 resetFocus(1);
                                                             } else if(gesture.horizontalDirection == 2)  { //QSwipeGesture::Left
                                                                  daysModel.loadGivenWeekValuesFromOffset(dateInFocus,-1);
                                                                 resetFocus(-1);
                                                             }
                                                        }
                                                    }
                                                }//end GestureArea


                                                ExtendedMouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        window.eventStartHr=startHr;
                                                        window.eventEndHr=endHr;
                                                        weekViewTopItem.calcTopParent();
                                                        var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                        window.openNewEventView(map.x,map.y,false);
                                                    }
                                                    onLongPressAndHold: {
                                                        window.eventStartHr=startHr;
                                                        window.eventEndHr=endHr;
                                                        weekViewTopItem.calcTopParent();
                                                        var map = mapToItem (weekViewTopItem.topItem,mouseX,mouseY);
                                                        window.openNewEventView(map.x,map.y,false);
                                                    }
                                                }

                                            }//end vacantAreaBox
                                        }//end ListView

                                    }//end delegate Item

                                }//end repeater
                            }//end Row

                            Component.onCompleted: {
                                eventsListView.contentY = (window.positionOfView*50);
                                window.positionOfView = UtilMethods.EDayTimeStart;
                            }

                         }//end flickable

                    }//end centerContent

                }//end of Column inside calData


            }//end of calDatabox

        }//end spacerBox


    }//end of weekViewData

}//end Item
