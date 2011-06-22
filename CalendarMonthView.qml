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
import Qt.labs.gestures 2.0

AppPage {
    id: centerPane
    pageTitle: qsTr("Month")
    property int offset:0
    property date dateInFocus:initDate()
    property string dateInFocusVal
    property string monthInFocusVal
    property int currDayIndex:0
    property int allDayEventsCount:allEventsViewModel.count
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
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
        monthInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateMonthYear);
        resetCalendarModels(dateInFocus);
    }

    function resetFocus(nextVal)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,0,nextVal*1,0);
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
        monthInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateMonthYear);
        window.appDateInFocus = dateInFocus;
        offset = offset+nextVal;
        resetCalendarModels(dateInFocus);
    }

    function resetCalendarModels(coreDateVal) {
        monthModel.loadGivenMonthValuesFromOffset(coreDateVal);
        allEventsViewModel.loadGivenDayModel(coreDateVal);
        dateInFocus = coreDateVal;
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
        monthInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateMonthYear);
    }

    function resetDataModel(coreDateVal) {
        allEventsViewModel.loadGivenDayModel(coreDateVal);
        monthModel.loadGivenMonthValuesFromOffset(coreDateVal);
        dateInFocus = coreDateVal;
        dateInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateFull);
        monthInFocusVal = i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateMonthYear);
    }

    function getDayImage(isCurrentDay,isMonthDay,coreDateVal,index) {
        var imageName = "";
        imageName = isMonthDay?"image://themedimage/images/calendar/calendar_month_eventview_list_p":"image://themedimage/images/calendar/calendar_month_inactiveday_l"
        var now = new Date();
        if(utilities.datesEqual(coreDateVal,now)) {
            imageName = "image://themedimage/images/calendar/calendar_month_today_l";
            currDayIndex = index;
        }
        if(utilities.datesEqual(dateInFocus,coreDateVal)) {
            if(!isCurrentDay) {
                imageName="image://themedimage/images/calendar/calendar_month_pressed_l";
            }
        }

        return imageName;
    }

    function setOpacity(imageIndex,isMonthDay,eventsCount) {
        if(isMonthDay && (imageIndex<=eventsCount))
            return 1;
        else
            return 0;
    }


    Connections {
        target:window
        onGotoDateChanged: {
            if(window.gotoDate) {
                dateInFocus = window.dateFromOutside;
                window.appDateInFocus = dateInFocus;
                resetDataModel(dateInFocus);
                window.gotoDate = false;
            }
        }

        onGotoTodayChanged: {
            if(window.gotoToday) {
                window.appDateInFocus = utilities.getCurrentDateVal();
                initDate();
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                window.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(window.addedEvent) {
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                window.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(window.deletedEvent) {
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                window.deletedEvent = false;
            }
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

    function showMultipleEventsPopup(xVal,yVal,coreDateVal,popUpParent) {
        multipleEventsPopup.coreDateVal = coreDateVal;
        multipleEventsPopup.initModel();
        multipleEventsPopup.displayMultiEvents(xVal,yVal);
        multipleEventsPopup.show();
    }

    Loader {
        id:popUpLoader
    }


    MultipleEventsPopup {
        id:multipleEventsPopup
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

    DayViewModel {
        id:allEventsViewModel
        modelType:UtilMethods.EAllEvents
        dateVal:dateInFocus
    }

    CalendarMonthModel {
        id:monthModel
        weekStartDay: i18nHelper.defaultFirstDayOfWeek
        dateVal:dateInFocus
    }

    CalendarWeekModel {
        id:weekDaysModel
        weekStartDay: i18nHelper.defaultFirstDayOfWeek
        dayInFocus:window.appDateInFocus
    }

    TopItem {
        id:monthViewTopItem
    }

    Column {
        id: monthViewData
        spacing: 2
        anchors.fill:parent
        HeaderComponentView {
            id:navHeader
            width: monthViewTopItem.topWidth
            height: 50
            dateVal: monthInFocusVal
            onNextTriggered: {
                resetFocus(1);
            }
            onPrevTriggered: {
                resetFocus(-1);           
            }
        }
        Item {
            id:spacerbox
            height:monthViewTopItem.topHeight - (navHeader.height)
            width: monthViewTopItem.topWidth
            BorderImage {
                    id: spacerImage
                    anchors.fill: parent
                    source: "image://themedimage/images/titlebar_l"

                    Item {
                        id: calDataBox
                        height:monthViewTopItem.topHeight - (navHeader.height)-20
                        width: monthViewTopItem.topWidth-20
                        anchors.centerIn: parent

                        Flickable {
                            id:centerContent
                            height: calDataBox.height
                            width: calDataBox.width
                            contentHeight: (window.inLandscape)?calDataBox.height:(monthViewBox.height + eventViewBox.height)
                            contentWidth: calDataBox.width
                            property real cellHeight: (monthViewBox.height-weekBox.height)/(6)
                            property real cellWidth: monthViewBox.width/7.0
                            anchors.top: parent.top

                            Item {
                                id:monthViewBox
                                height: (window.inLandscape)?calDataBox.height:(2*(calDataBox.height/3))
                                width:(window.inLandscape)?(3*(calDataBox.width/4)):(calDataBox.width)
                                anchors.top: parent.top
                                Column {
                                    anchors.top: parent.top

                                    Item {
                                        id:weekBox
                                        height: 50
                                        width:centerContent.cellWidth
                                        Row {
                                            id:weekDayRow
                                            anchors.top: parent.top
                                            Repeater {
                                                id: weekDayRepeater
                                                model: weekDaysModel
                                                Rectangle {
                                                    id:dateValBox
                                                    width:centerContent.cellWidth
                                                    height:weekBox.height
                                                    border.width:2
                                                    border.color: "darkgray"
                                                    BorderImage {
                                                        id: weekImage
                                                        source: "image://themedimage/images/calendar/calendar_month_inactiveday_l"
                                                        anchors.fill: parent
                                                    }

                                                    Text {
                                                          id: weekValTxt
                                                          text: i18nHelper.localDate(coreDateVal, Labs.LocaleHelper.DateWeekdayShort)
                                                          color:theme_fontColorNormal
                                                          font.pixelSize:theme_fontPixelSizeLarge
                                                          anchors.centerIn: parent
                                                          elide: Text.ElideRight
                                                     }
                                                }
                                            }//end of repeater
                                        }//end of Row
                                    }//end of weekbox

                                    Grid {
                                        id:daysGrid
                                        rows:6
                                        columns: 7
                                        height: (centerContent.cellHeight*6)
                                        width: (centerContent.cellWidth*7)
                                        Repeater {
                                            id:dayRepeater
                                            model:monthModel
                                            Rectangle{
                                                id:dayBox
                                                height:centerContent.cellHeight
                                                width:centerContent.cellWidth
                                                border.width: 2
                                                border.color:"gray"
                                                BorderImage {
                                                    id:dayImage
                                                    anchors.fill: parent
                                                    source: getDayImage(isCurrentDay,isMonthDay,coreDateVal,index)
                                                }
                                                Column {
                                                    spacing:2
                                                    Item {
                                                        id: dayTextBox
                                                        height:dayBox.height/4
                                                        width: dayBox.width
                                                        Text {
                                                            id:dayText
                                                            text: i18nHelper.localDate(coreDateVal, Labs.LocaleHelper.DateDay)
                                                            font.bold:true
                                                            color:isMonthDay?theme_fontColorNormal:theme_fontColorInactive
                                                            font.pixelSize:theme_fontPixelSizeMedium
                                                            anchors.left: parent.left
                                                            anchors.leftMargin: 5
                                                            anchors.topMargin: 5
                                                        }
                                                    }
                                                    Item {
                                                        id:event1Box
                                                        height:dayBox.height/5
                                                        width:dayBox.width
                                                        opacity:setOpacity(1,isMonthDay,eventsCount)
                                                        BorderImage {
                                                            id:eventImage1
                                                            source:"image://themedimage/widgets/apps/calendar/event"
                                                            width: parent.width-4
                                                            height:parent.height
                                                            anchors.centerIn: parent

                                                            Text {
                                                                id:event1Text
                                                                text: event1
                                                                font.bold:true
                                                                color:theme_fontColorNormal
                                                                font.pixelSize:theme_fontPixelSizeSmall
                                                                anchors.centerIn: parent
                                                                width:parent.width
                                                                elide: Text.ElideRight
                                                            }
                                                        }
                                                    }
                                                    Item {
                                                        id:event2Box
                                                        height:dayBox.height/5
                                                        width:dayBox.width
                                                        opacity:setOpacity(2,isMonthDay,eventsCount)
                                                        BorderImage {
                                                            id:eventImage2
                                                            source:"image://themedimage/widgets/apps/calendar/event"
                                                            width: parent.width-4
                                                            height:parent.height
                                                            anchors.centerIn: parent

                                                            Text {
                                                                id:event2Text
                                                                text: event2
                                                                font.bold:true
                                                                color:theme_fontColorNormal
                                                                font.pixelSize: theme_fontPixelSizeSmall
                                                                anchors.centerIn: parent
                                                                width:parent.width
                                                                elide: Text.ElideRight
                                                            }
                                                        }
                                                    }
                                                    Item {
                                                        id:event3Box
                                                        height:dayBox.height/5
                                                        width:dayBox.width
                                                        opacity:setOpacity(3,isMonthDay,eventsCount)
                                                        BorderImage {
                                                            id:eventImage3
                                                            //The image was supposed to be something else when the count was > 3. Have to revisit this.
                                                            source:(eventsCount>3)?"image://themedimage/widgets/apps/calendar/event":"image://themedimage/widgets/apps/calendar/event"
                                                            width: parent.width-4
                                                            height:parent.height
                                                            anchors.centerIn:parent
                                                            Text {
                                                                id:event3Text
                                                                text: event3
                                                                font.bold:true
                                                                color:theme_fontColorNormal
                                                                font.pixelSize: theme_fontPixelSizeSmall
                                                                anchors.centerIn: parent
                                                                width: parent.width
                                                                elide: Text.ElideRight
                                                            }
                                                        }
                                                    }
                                                }

                                                GestureArea {
                                                    anchors.fill: parent

                                                   Swipe {
                                                        onFinished: {
                                                             if(gesture.horizontalDirection == 1)  { //QSwipeGesture::Right
                                                                 resetFocus(1);
                                                             } else if(gesture.horizontalDirection == 2)  { //QSwipeGesture::Left
                                                                 resetFocus(-1);
                                                             }
                                                        }
                                                    }

                                                }//end GestureArea

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        if(isMonthDay) {
                                                            window.appDateInFocus = coreDateVal;
                                                            resetDataModel(coreDateVal);
                                                        }
                                                    }
                                                    onPressAndHold: {
                                                        if(isMonthDay && eventsCount>0) {
                                                            monthViewTopItem.calcTopParent();
                                                            var map = mapToItem (monthViewTopItem.topItem,mouseX,mouseY);
                                                            showMultipleEventsPopup(map.x,map.y,coreDateVal,window);
                                                        }
                                                    }
                                                }
                                            }

                                        }

                                    }
                                }

                            }//end monthviewbox

                            Rectangle {
                                id:eventViewBox
                                height: (window.inLandscape)?(calDataBox.height):(calDataBox.height/3)
                                width:(window.inLandscape)?(calDataBox.width/4):(calDataBox.width)
                                anchors.left: (window.inLandscape)?monthViewBox.right:parent.left
                                anchors.leftMargin:(window.inLandscape)?5:0
                                anchors.top: (window.inLandscape)?parent.top:monthViewBox.bottom
                                border.width: 2
                                border.color: "gray"

                                Column {
                                    spacing: 3
                                    Item {
                                        id:dateBox
                                        height: 50
                                        width: eventViewBox.width
                                        BorderImage {
                                            id: dateBoxImage
                                            source: "image://themedimage/images/calendar/calendar_month_inactiveday_l"
                                            anchors.fill: parent
                                        }
                                        Text {
                                            id: dateText
                                            text:i18nHelper.localDate(dateInFocus, Labs.LocaleHelper.DateWeekdayMonthDay);
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10
                                            font.bold: true
                                            color:theme_fontColorNormal
                                            font.pixelSize: theme_fontPixelSizeMedium
                                            width: dateBox.width
                                            elide: Text.ElideRight
                                        }
                                    }//end dateBox

                                    Item {
                                        id:eventsListBox
                                        height:eventViewBox.height-dateBox.height-50
                                        width: eventViewBox.width
                                        Rectangle {
                                            id:listViewBox
                                            height: parent.height
                                            width:parent.width
                                            anchors.centerIn: parent

                                            ListView {
                                                id: eventsList
                                                anchors.fill: parent
                                                clip: true
                                                flickableDirection: Flickable.VerticalFlick
                                                model:allEventsViewModel

                                                delegate: Rectangle {
                                                    id:eventBox
                                                    height: 75
                                                    width:parent.width
                                                    border.width: 2
                                                    border.color: "gray"

                                                    Item {
                                                        anchors.top: parent.top
                                                        anchors.topMargin: 20
                                                        anchors.left:parent.left
                                                        anchors.leftMargin: 20

                                                        Column {
                                                            spacing: 5
                                                            anchors.top: parent.top

                                                            Text {
                                                                  id: eventDescription
                                                                  text:summary
                                                                  font.bold: true
                                                                  color:theme_fontColorNormal
                                                                  font.pixelSize:theme_fontPixelSizeMedium
                                                                  width:eventBox.width
                                                                  elide: Text.ElideRight

                                                             }

                                                            Text {
                                                                  id: eventTime
                                                                  //: This is time range ("StartTime - EndTime") %1 is StartTime and %2 is EndTime
                                                                  text: allDay?qsTr("All day"):qsTr("%1 - %2","StartTime - EndTime").arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFull)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFull));
                                                                  color:theme_fontColorNormal
                                                                  font.pixelSize: theme_fontPixelSizeMedium
                                                                  width: eventBox.width
                                                                  elide: Text.ElideRight
                                                             }
                                                        }
                                                    }

                                                    GestureArea {
                                                        anchors.fill: parent

                                                       Swipe {
                                                            onFinished: {
                                                                 if(gesture.horizontalDirection == 1)  { //QSwipeGesture::Right
                                                                     resetFocus(1);
                                                                 } else if(gesture.horizontalDirection == 2)  { //QSwipeGesture::Left
                                                                     resetFocus(-1);
                                                                 }
                                                            }
                                                        }

                                                    }//end GestureArea

                                                    ExtendedMouseArea {
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            //window.editEvent(uid);
                                                            monthViewTopItem.calcTopParent();
                                                            var map = mapToItem (monthViewTopItem.topItem,mouseX,mouseY);
                                                            //console.log("allDayEventsCount="+allDayEventsCount);
                                                            //if(allDayEventsCount>0) {
                                                                window.openView (map.x,map.y,uid,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay,false,false);
                                                            /*} else  {
                                                                window.openNewEventView(map.x,map.y,false);
                                                            }*/
                                                        }
                                                        onLongPressAndHold: {
                                                            monthViewTopItem.calcTopParent();
                                                            var map = mapToItem (monthViewTopItem.topItem,mouseX,mouseY);
                                                            displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,eventBox,description,summary,location,alarmType,utilities.getRepeatTypeString(repeatType),startDate,startTime,endTime,zoneOffset,zoneName,allDay);
                                                        }                                                       
                                                    }

                                                }//end of delegate
                                            }//end listview
                                        }

                                    }//end eventslistbox
                                }
                            }

                        }

                    }//end of calDatabox

            }
        }
    }//end of top column

}
