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

        console.log("dayInFocusIndex="+dayInFocusIndex);
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
                allDayViewModel.loadGivenWeekModel(dateInFocus);
                weekEventsModel.loadGivenWeekModel(dateInFocus);
                dateInFocusVal = utilities.getWeekHeaderTitle(tmpDate.getDate(),(tmpDate.getMonth()+1),tmpDate.getFullYear());
                dayInFocusIndex = dateInFocus.getDay();
                if(dayInFocusIndex==0) {//i.e if day is sunday
                    dayInFocusIndex = 7;
                }

            }
        }

        onGotoTodayChanged: {
            if(scene.gotoToday) {
                initDate();
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                allDayViewModel.loadGivenWeekModel(dateInFocus);
                weekEventsModel.loadGivenWeekModel(dateInFocus);
                scene.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(scene.addedEvent) {
                console.log("Trigger model change here");
                allDayViewModel.loadGivenWeekModel(dateInFocus);
                weekEventsModel.loadGivenWeekModel(dateInFocus);
                searchList.listModel.refresh();
                scene.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(scene.deletedEvent) {
                console.log("Before changing the model after delete inside DayView");
                allDayViewModel.loadGivenWeekModel(dateInFocus);
                weekEventsModel.loadGivenWeekModel(dateInFocus);
                searchList.listModel.refresh();
                scene.deletedEvent = false;
                console.log("Marking deletedEvent is false inside DayView");
            }
        }

    }

    Connections {
        target:weekPage
        onShowSearchChanged: {
            console.log("weekPage.showSearch="+weekPage.showSearch);
            if(!showSearch) {
                searchList.listModel.filterOut("");
            }
            searchList.visible = !searchList.visible;
            weekViewData.visible = !weekViewData.visible;
            scene.searchResultCount = searchList.listModel.count;
        }

        onSearch: {
            console.log("dayPage.showSearch="+dayPage.showSearch);
            console.log("search: " + needle);
            if(!searchList.visible) {
                searchList.visible = true;
                weekViewData.visible = false;
                scene.searchResultCount = searchList.listModel.count;
            }
            if(searchList.visible) {
                searchList.listModel.filterOut(needle);
                console.log("search: (" + needle+")");
                searchList.listIndex = 0;
                scene.searchResultCount = searchList.listModel.count;
            }
        }
    }


    function resetCalendarDayModels(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        allDayViewModel.loadGivenWeekModel(coreDateVal);
        weekEventsModel.loadGivenWeekModel(coreDateVal);
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
        dateInFocusVal = utilities.getWeekHeaderTitle(scene.eventDay,scene.eventMonth,scene.eventYear);
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
        console.log("AlarmType="+alarmType);
        loader.item.alarmType = alarmType;
        loader.item.zoneOffset = zoneOffset;
        loader.item.startDate = startDate;
        if(allDay) {
            loader.item.timeVal = qsTr("All day");
        } else  {
            loader.item.timeVal = qsTr("%1, %2 - %3").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate)).arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale));
        }
        loader.item.initMaps();
        console.log(loader.item.timeVal);
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

    WeekViewModel {
        id:allDayViewModel
        modelType:UtilMethods.EAllDay
    }

    WeekViewModel {
        id:weekEventsModel
        modelType:UtilMethods.ENotAllDay
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
                    Row {
                        Item {
                            id:spacer1
                            width:scene.content.width/12
                            height:100

                        }//end of spacer1

                        Rectangle {
                            id:dayBox
                            width:calDataBox.width -(spacer1.width)
                            height:100
                            color:"lightgray"
                            border.width: 2
                            border.color: "darkgray"
                            Row {
                                id:dayRow
                                //anchors.centerIn: dayBox
                                Repeater {
                                    id: dayRepeater
                                    property int dayIndex:0
                                    property int prevIndex:0
                                    model: daysModel
                                    Column {
                                        id:allDayColumn

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
                                                  //width: dateValBox.width
                                                  elide: Text.ElideRight
                                             }
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    setDateInFocus(coreDateVal);
                                                }
                                            }
                                        }

                                        Rectangle {
                                            id:allDayBox
                                            width: dayBox.width/7
                                            height: dayBox.height/2
                                            border.width:2
                                            border.color: "lightgray"
                                            property int parentIndex:index
                                            color:"white"
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
                                                    visible: (allDayBox.parentIndex==dayIndex)?true:false

                                                    BorderImage {
                                                        id:allDayImage
                                                        source:"image://theme/calendar/calendar_event"
                                                        anchors.fill: parent
                                                    }

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
                                                            //scene.editEvent(uid);
                                                            var map = mapToItem (scene.content, mouseX, mouseY);
                                                            scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                        }
                                                        onLongPressAndHold: {
                                                            //showPopUp(uid,eventActionsPopup,popUpLoader,weekBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay)
                                                            var map = mapToItem (scene.content, mouseX, mouseY);
                                                            displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,weekBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                        }

                                                    }
                                                }
                                            }
                                        }

                                    }
                                    onDayIndexChanged: {
                                        dayRow.children[prevIndex].color = "white"
                                        if(prevIndex != currDayIndex) {
                                            dayRow.children[currDayIndex].color = "white"
                                        }
                                    }

                                }//end of repeater
                            }//end of Row
                        }//end of dayBox
                    }

                    Rectangle {
                         id: centerContent
                         height: calDataBox.height-dayBox.height
                         width: calDataBox.width
                         color: "lightgray"
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
                            contentY:(UtilMethods.EDayTimeStart*50)
                            clip: true
                            z:100
                            focus: true

                            Row {
                                spacing:2
                                anchors.top: parent.top
                                ListView {
                                     id: timeListView
                                     height: eventsListView.contentHeight
                                     width: scene.content.width/12
                                     contentHeight: eventsListView.contentHeight
                                     contentWidth: scene.content.width/12
                                     clip:true
                                     interactive: false
                                     model:timeListModel
                                     delegate: Rectangle {
                                         id: timeValBox
                                         height: 50
                                         width:scene.content.width/12
                                         color: "white"
                                         border.width: 2
                                         border.color: "lightgray"
                                         Text {
                                             id: timeValText
                                             text: timeVal
                                             anchors.top: parent.top
                                             anchors.horizontalCenter: parent.horizontalCenter
                                             font.bold: true
                                             color:theme_fontColorNormal
                                             font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
                                             elide: Text.ElideRight
                                         }
                                     }//end timeValBox

                                }//end Timeline listview

                                Item {
                                    id:weekBox
                                    height: centerContent.timeListCount*centerContent.cellHeight
                                    width: centerContent.width - timeListView.width
                                    Row {
                                        id:weekDayRow
                                        Repeater {
                                            id: weekDayRepeater
                                            model:7
                                            Item {
                                                id:weekDayBox
                                                height: weekBox.height
                                                width: weekBox.width/7
                                                ListView {
                                                    id:weekDayListView
                                                    anchors.top: parent.top
                                                    height: weekBox.height
                                                    width: weekBox.width/7
                                                    contentHeight: weekBox.height
                                                    contentWidth: weekBox.width/7
                                                    clip:true
                                                    interactive: false
                                                    model:timeListModel
                                                    property int colIndex:index
                                                    delegate: Rectangle {
                                                        id: vacantAreaBox
                                                        height: centerContent.cellHeight
                                                        width: centerContent.cellWidth
                                                        border.width:2
                                                        border.color: "lightgray"
                                                        property int parentIndex:index
                                                        color: "white"
                                                        z:2

                                                        Repeater {
                                                            id:calDataItemsList
                                                            model: weekEventsModel
                                                            focus: true
                                                            delegate:Item {
                                                                id: displayRect
                                                                height: (startIndex == vacantAreaBox.parentIndex && weekDayListView.colIndex==dayIndex)?(heightUnits*vacantAreaBox.height):vacantAreaBox.height
                                                                width: (startIndex == vacantAreaBox.parentIndex && weekDayListView.colIndex==dayIndex)?(widthUnits*vacantAreaBox.width):vacantAreaBox.width
                                                                x:(xUnits+xUnits*displayRect.width)+1
                                                                Image {
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
                                                                            displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,weekBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                        }
                                                                    }
                                                                }
                                                                z:200
                                                                opacity: (startIndex == vacantAreaBox.parentIndex && weekDayListView.colIndex==dayIndex)?1:0
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

                                                }

                                            }
                                        }//end repeater
                                    }//end Row

                                }//end weekBox

                            }//end row

                         }//end flickable

                    }//end centerContent

                }//end of Column inside calData


            }//end of calDatabox

        }


    }//end of top column

}
