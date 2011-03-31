/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1
import MeeGo.App.Calendar 0.1

Item {
    id: centerPane
    property int offset:0
    property date dateInFocus:initDate()
    property string dateInFocusVal
    property string monthInFocusVal
    property int currDayIndex:0

    function initDate()
    {
        var tmpDate = utilities.getCurrentDateVal();
        dateInFocus = tmpDate;
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.ESystemLocaleLongDate);
        monthInFocusVal = qsTr("%1 %2").arg(utilities.getDateInFormatString(tmpDate,"MMMM")).arg(utilities.getDateInFormatString(tmpDate,"yyyy"));
    }

    function resetFocus(nextVal)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,0,nextVal*1,0);
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.ESystemLocaleLongDate);
        monthInFocusVal = qsTr("%1 %2").arg(utilities.getDateInFormatString(dateInFocus,"MMMM")).arg(utilities.getDateInFormatString(dateInFocus,"yyyy"));
        offset = offset+nextVal;
        resetCalendarModels(dateInFocus);
    }

    function resetCalendarModels(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        monthModel.loadGivenMonthValuesFromOffset(coreDateVal);
        allEventsViewModel.loadGivenDayModel(coreDateVal);

        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.ESystemLocaleLongDate);
        monthInFocusVal = qsTr("%1 %2").arg(utilities.getDateInFormatString(dateInFocus,"MMMM")).arg(utilities.getDateInFormatString(dateInFocus,"yyyy"));
    }

    function resetDataModel(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        allEventsViewModel.loadGivenDayModel(coreDateVal);
        monthModel.loadGivenMonthValuesFromOffset(coreDateVal);
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.ESystemLocaleLongDate);
        monthInFocusVal = qsTr("%1 %2").arg(utilities.getDateInFormatString(dateInFocus,"MMMM")).arg(utilities.getDateInFormatString(dateInFocus,"yyyy"));
    }

    function getDayImage(isCurrentDay,isMonthDay,coreDateVal,index) {
        var imageName = "";
        imageName = isMonthDay?"image://theme/calendar/calendar_month_eventview_list_p":"image://theme/calendar/calendar_month_inactiveday_l"
        var now = new Date();
        if(utilities.datesEqual(coreDateVal,now)) {
            imageName = "image://theme/calendar/calendar_month_today_l";
            currDayIndex = index;
        }
        if(utilities.datesEqual(dateInFocus,coreDateVal)) {
            if(!isCurrentDay) {
                imageName="image://theme/calendar/calendar_month_pressed_l";
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
        target:scene
        onGotoDateChanged: {
            if(scene.gotoDate) {
                dateInFocus = scene.dateFromOutside;
                resetDataModel(dateInFocus);
                scene.gotoDate = false;
            }
        }

        onGotoTodayChanged: {
            if(scene.gotoToday) {
                initDate();
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                scene.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(scene.addedEvent) {
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                searchList.listModel.refresh();
                scene.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(scene.deletedEvent) {
                allEventsViewModel.loadGivenDayModel(dateInFocus);
                monthModel.loadGivenMonthValuesFromOffset(dateInFocus);
                searchList.listModel.refresh();
                scene.deletedEvent = false;
            }
        }
    }


    Connections {
        target:monthPage
        onShowSearchChanged: {
            if(!showSearch) {
                searchList.listModel.filterOut("");
            }
            searchList.visible = !searchList.visible;
            monthViewData.visible = !monthViewData.visible;
            scene.searchResultCount = searchList.listModel.count;
        }

        onSearch: {
            if(!searchList.visible) {
                searchList.visible = true;
                monthViewData.visible = false;
                scene.searchResultCount = searchList.listModel.count;
            }
            if(searchList.visible) {
                searchList.listModel.filterOut(needle);
                searchList.listIndex = 0;
                scene.searchResultCount = searchList.listModel.count;
            }
        }
    }


    function displayContextMenu(xVal,yVal,uid,component,loader,popUpParent,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay)
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
        loader.item.zoneOffset = zoneOffset;
        loader.item.startDate = startDate;
        if(allDay) {
            loader.item.timeVal = qsTr("All day");
        } else  {
            loader.item.timeVal = qsTr("%1, %2 - %3").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate)).arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale));
        }
        loader.item.initMaps();
    }

    function showMultipleEventsPopup(xVal,yVal,coreDateVal,popUpParent) {
        multipleEventsPopupLoader.sourceComponent = multipleEventsPopup
        multipleEventsPopupLoader.item.parent = popUpParent
        multipleEventsPopupLoader.item.coreDateVal = coreDateVal;
        multipleEventsPopupLoader.item.initModel();
        multipleEventsPopupLoader.item.displayMultiEvents(xVal,yVal);
    }

    Loader {
        id:popUpLoader
    }

    Loader {
        id:multipleEventsPopupLoader
    }

    Component {
        id:multipleEventsPopup
        MultipleEventsPopup {
            onClose: {
                multipleEventsPopupLoader.sourceComponent = undefined
            }
        }
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

    DayViewModel {
        id:allEventsViewModel
        modelType:UtilMethods.EAllEvents
        dateVal:dateInFocus
    }

    CalendarMonthModel {
        id:monthModel
        dateVal:dateInFocus
    }

    CalendarWeekModel {
        id:weekDaysModel
    }

    CalendarListView {
        id: searchList
        visible:false
        onClose: {
            monthPage.showSearch=false;
        }
    }

    Column {
        id: monthViewData
        spacing: 2
        anchors.top:  parent.top
        HeaderComponentView {
            id:navHeader
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
            height:scene.content.height - (navHeader.height)
            width: scene.content.width
            BorderImage {
                    id: spacerImage
                    anchors.fill: parent
                    source: "image://theme/titlebar_l"

                    Item {
                        id: calDataBox
                        height:scene.content.height - (navHeader.height)-20
                        width: scene.content.width-20
                        anchors.centerIn: parent

                        Flickable {
                            id:centerContent
                            height: calDataBox.height
                            width: calDataBox.width
                            contentHeight: (scene.isLandscapeView())?calDataBox.height:(monthViewBox.height + eventViewBox.height)
                            contentWidth: calDataBox.width
                            property real cellHeight: (monthViewBox.height-weekBox.height)/(6.5)
                            property real cellWidth: monthViewBox.width/7.0
                            anchors.top: parent.top

                            Item {
                                id:monthViewBox
                                height: (scene.isLandscapeView())?calDataBox.height:(2*(calDataBox.height/3))
                                width:(scene.isLandscapeView())?(3*(calDataBox.width/4)):(calDataBox.width)
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
                                                        source: "image://theme/calendar/calendar_month_inactiveday_l"
                                                        anchors.fill: parent
                                                    }

                                                    Text {
                                                          id: weekValTxt
                                                          text:utilities.getDateInFormatString(coreDateVal,"ddd")
                                                          font.bold: true
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
                                                            text: dateValString
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
                                                            source:"image://theme/calendar/calendar_event"
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
                                                            source:"image://theme/calendar/calendar_event"
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
                                                            source:(eventsCount>3)?"image://theme/calendar/calendar_event":"image://theme/calendar/calendar_event"
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
                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        if(isMonthDay) {
                                                            scene.appDateInFocus = coreDateVal;
                                                            resetDataModel(coreDateVal);
                                                        }
                                                    }
                                                    onPressAndHold: {
                                                        if(isMonthDay && eventsCount>0) {
                                                             var map = mapToItem (scene.content, mouseX, mouseY);
                                                            showMultipleEventsPopup(map.x,map.y,coreDateVal,scene.container);
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
                                height: (scene.isLandscapeView())?(calDataBox.height):(calDataBox.height/3)
                                width:(scene.isLandscapeView())?(calDataBox.width/4):(calDataBox.width)
                                anchors.left: (scene.isLandscapeView())?monthViewBox.right:parent.left
                                anchors.leftMargin:(scene.isLandscapeView())?5:0
                                anchors.top: (scene.isLandscapeView())?parent.top:monthViewBox.bottom
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
                                            source: "image://theme/calendar/calendar_month_inactiveday_l"
                                            anchors.fill: parent
                                        }
                                        Text {
                                            id: dateText
                                            text: dateInFocusVal
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
                                        height:eventViewBox.height-dateBox.height-buttonBox.height-50
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
                                                                  text: allDay?qsTr("All day"):qsTr("%1 - %2").arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale))
                                                                  color:theme_fontColorNormal
                                                                  font.pixelSize: theme_fontPixelSizeMedium
                                                                  width: eventBox.width
                                                                  elide: Text.ElideRight
                                                             }
                                                        }
                                                    }
                                                    ExtendedMouseArea {
                                                        anchors.fill: parent
                                                        onClicked: {
                                                            //scene.editEvent(uid);
                                                            var map = mapToItem (scene.content, mouseX, mouseY);
                                                            scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                        }
                                                        onLongPressAndHold: {
                                                            //showPopUp(uid,eventActionsPopup,popUpLoader,eventImage,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                            var map = mapToItem (scene.content, mouseX, mouseY);
                                                            displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,eventBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                        }
                                                    }

                                                }//end of delegate
                                            }//end listview
                                        }

                                    }//end eventslistbox

                                    Item {
                                        id:buttonBox
                                        width: eventsListBox.width
                                        height:50
                                        BorderImage {
                                            id: buttonBoxImage
                                            source: "image://theme/calendar/calendar_month_inactiveday_l"
                                            anchors.fill: parent
                                        }
                                        Button {
                                            id: addEventButton
                                            width:parent.width/2
                                            height:30
                                            anchors.centerIn: parent
                                            bgSourceUp: "image://theme/btn_grey_up"
                                            bgSourceDn: "image://theme/btn_grey_dn"
                                            title: qsTr("Add Event")
                                            font.pixelSize: theme_fontPixelSizeLarge
                                            color: theme_buttonFontColor
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                   scene.appDateInFocus = dateInFocus;
                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                    scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,false);
                                                }
                                            }
                                        }//addEventButton

                                    }//end buttonBox
                                }
                            }

                        }

                    }//end of calDatabox

            }
        }
    }//end of top column

}
