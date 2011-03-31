/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.App.Calendar 0.1

Item {
    id: centerPane
    property int offset:0
    property date dateInFocus:initDate()
    property string dateInFocusVal
    property int currDayIndex:0
    property int dayInFocusIndex:0

    function initDate()
    {
        var tmpDate = utilities.getCurrentDateVal();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocusVal = utilities.getWeekHeaderTitle(scene.eventDay,scene.eventMonth,scene.eventYear);
        dayInFocusIndex = tmpDate.getDay();
        if(dayInFocusIndex==0) {//i.e if day is sunday
            dayInFocusIndex = 7;
        }
        dayInFocusIndex--;

    }


    Connections {
        target:scene
        onGotoDateChanged: {
            if(scene.gotoDate) {
                scene.gotoDate=false;
                dateInFocus =  scene.dateFromOutside;
                scene.appDateInFocus = dateInFocus;
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                var tmpDate = dateInFocus;
                dateInFocusVal = utilities.getWeekHeaderTitle(tmpDate.getDate(),(tmpDate.getMonth()+1),tmpDate.getFullYear());
                dayInFocusIndex = dateInFocus.getDay();
                if(dayInFocusIndex==0) {//i.e if day is sunday
                    dayInFocusIndex = 7;
                }
                dayInFocusIndex--;
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
            }
        }

        onGotoTodayChanged: {
            if(scene.gotoToday) {
                initDate();
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                scene.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(scene.addedEvent) {
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                searchList.listModel.refresh();
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                scene.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(scene.deletedEvent) {
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                searchList.listModel.refresh();
                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                scene.deletedEvent = false;
            }
        }

    }

    Connections {
        target:weekPage
        onShowSearchChanged: {
            if(!showSearch) {
                searchList.listModel.filterOut("");
            }
            searchList.visible = !searchList.visible;
            weekViewData.visible = !weekViewData.visible;
            scene.searchResultCount = searchList.listModel.count;
        }

        onSearch: {
            if(!searchList.visible) {
                searchList.visible = true;
                weekViewData.visible = false;
                scene.searchResultCount = searchList.listModel.count;
            }
            if(searchList.visible) {
                searchList.listModel.filterOut(needle);
                searchList.listIndex = 0;
                scene.searchResultCount = searchList.listModel.count;
            }
        }
    }


    function resetCalendarDayModels(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
        dateInFocusVal = utilities.getWeekHeaderTitle(scene.eventDay,scene.eventMonth,scene.eventYear);
        daysModel.loadGivenWeekValuesFromDate(dateInFocus);
        eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
    }

    function setDateInFocus(coreDateVal)
    {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
    }

    function resetFocus(offset)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,(offset*7),0,0);
        scene.appDateInFocus = dateInFocus;
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

    CalendarWeekModel {
        id:daysModel
    }

    TimeListModel {
        id:timeListModel
    }

    CalendarListView {
        id: searchList
        visible:false
        onClose: {
            weekPage.showSearch=false;
        }
    }

    Column {
        id: weekViewData
        spacing: 2
        anchors.top:  parent.top
        HeaderComponentView {
            id:navHeader
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
            height:scene.content.height - (navHeader.height)
            width: scene.content.width
            color:"lightgray"

            Rectangle {
                id: calDataBox
                height:scene.content.height - (navHeader.height)-20
                width: scene.content.width-20
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
                                              text:dateValString
                                              font.bold: true
                                              color:isCurrentDate(coreDateVal,index)?theme_buttonFontColorActive:theme_fontColorNormal
                                              font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarge:theme_fontPixelSizeMedium
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
                                        border.color: (isDateInFocus(coreDateVal))?"lightgray":"lightgray"
                                        property int parentIndex:index
                                        color:(isDateInFocus(coreDateVal))?"lightgray":"white"

                                        DayViewModel {
                                            id:allDayViewModel
                                            modelType:UtilMethods.EAllDay
                                            dateVal:coreDateVal
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
                                                                text: (index==2 && (allDayViewModel.count>3))?qsTr("%1 more events exist").arg(allDayViewModel.count-2):summary
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
                                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                                    scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                }
                                                                onLongPressAndHold: {
                                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                                    displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,calItemBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
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
                                                var map = mapToItem (scene.content, mouseX, mouseY);
                                                scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,true);
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
                         height: calDataBox.height-dayBox.height
                         width: calDataBox.width
                         property real cellHeight:50
                         property real cellWidth: dayBox.width/7
                         property int timeListCount:timeListModel.count

                         Flickable {
                            id: eventsListView
                            anchors.top: parent.top
                            height: centerContent.height
                            width: centerContent.width
                            contentHeight: (centerContent.timeListCount+1)*(centerContent.cellHeight)
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
                                        height: centerContent.timeListCount*centerContent.cellHeight
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
                                                z:2

                                                Text {
                                                    id:timeValText
                                                    text:timeVal
                                                    anchors.top:parent.top
                                                    anchors.left:parent.left
                                                    anchors.leftMargin: 5
                                                    color:theme_fontColorNormal
                                                    font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
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
                                                                          text: qsTr("%1 - %2").arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale))
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
                                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                                    scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                }
                                                                onLongPressAndHold: {
                                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                                    displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,displayRect,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                }
                                                            }
                                                        }
                                                        z:200
                                                    }
                                                }//end Repeater

                                                ExtendedMouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        scene.eventStartHr=startHr;
                                                        scene.eventEndHr=endHr;
                                                        var map = mapToItem (scene.content, mouseX, mouseY);
                                                        scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,false);
                                                    }
                                                    onLongPressAndHold: {
                                                        scene.eventStartHr=startHr;
                                                        scene.eventEndHr=endHr;
                                                        var map = mapToItem (scene.content, mouseX, mouseY);
                                                        scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,false);
                                                    }
                                                }

                                            }//end vacantAreaBox
                                        }//end ListView

                                    }//end delegate Item

                                }//end repeater
                            }//end Row

                            Component.onCompleted: {
                                eventsListView.contentY = (UtilMethods.EDayTimeStart*50);
                            }

                         }//end flickable

                    }//end centerContent

                }//end of Column inside calData


            }//end of calDatabox

        }//end spacerBox


    }//end of weekViewData

}//end Item
