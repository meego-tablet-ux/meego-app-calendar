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
    property int allDayEventsCount:allDayViewModel.count

    function initDate()
    {
        var tmpDate = utilities.getCurrentDateVal();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.EDefault);
    }


    Connections {
        target:scene
        onGotoDateChanged: {
            if(scene.gotoDate) {
                dateInFocus =  scene.dateFromOutside;
                scene.appDateInFocus = dateInFocus;
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                dayEventsModel.loadGivenDayModel(dateInFocus);
                dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.EDefault);
                scene.gotoDate=false;
            }
        }

        onGotoTodayChanged: {
            if(scene.gotoToday) {
                initDate();
                daysModel.loadGivenWeekValuesFromDate(dateInFocus);
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                dayEventsModel.loadGivenDayModel(dateInFocus);
                scene.gotoToday=false;
            }
        }

        onAddedEventChanged: {
            if(scene.addedEvent) {
                console.log("Trigger model change here");
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                dayEventsModel.loadGivenDayModel(dateInFocus);                
                searchList.listModel.refresh();
                scene.addedEvent = false;
            }
        }

        onDeletedEventChanged: {
            if(scene.deletedEvent) {
                console.log("Before changing the model after delete inside DayView");
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                dayEventsModel.loadGivenDayModel(dateInFocus);
                searchList.listModel.refresh();
                scene.deletedEvent = false;
                console.log("Marking deletedEvent is false inside DayView");
            }
        }

        onTriggeredExternallyChanged: {
            if(scene.triggeredExternally) {
                console.log("externally triggered");
                dateInFocus =  scene.dateFromOutside;
                scene.appDateInFocus = dateInFocus;
                dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.EDefault);
                console.log("dateInFocus="+dateInFocusVal);
                daysModel.loadGivenWeekValuesFromDate(dateInFocus)
                allDayViewModel.loadGivenDayModel(dateInFocus);
                allDayEventsCount = allDayViewModel.count;
                dayEventsModel.loadGivenDayModel(dateInFocus);
                scene.triggeredExternally = false;
                console.log("Done externally triggered");
            }
        }
    }

    Connections {
        target:dayPage
        onShowSearchChanged: {
            console.log("dayPage.showSearch="+dayPage.showSearch);
            if(!showSearch) {
                searchList.listModel.filterOut("");
            }
            searchList.visible = !searchList.visible;
            dayViewData.visible = !dayViewData.visible;
            scene.searchResultCount = searchList.listModel.count;
            console.log("3 scene.searchResultCount"+scene.searchResultCount);
        }

        onSearch: {
            console.log("dayPage.showSearch="+dayPage.showSearch);
            console.log("search: " + needle);
            if(!searchList.visible) {
                searchList.visible = true;
                dayViewData.visible = false;
                console.log("1 scene.searchResultCount"+scene.searchResultCount);
            }
            if(searchList.visible) {
                searchList.listModel.filterOut(needle);
                console.log("search: (" + needle+")");
                searchList.listIndex = 0;
                scene.searchResultCount = searchList.listModel.count;
                console.log("2 scene.searchResultCount"+scene.searchResultCount);
            }
        }
    }


    function resetCalendarDayModels(coreDateVal) {
        var tmpDate = new Date(utilities.getLongDate(coreDateVal));
        allDayViewModel.loadGivenDayModel(coreDateVal);
        allDayEventsCount = allDayViewModel.count;
        dayEventsModel.loadGivenDayModel(coreDateVal);
        console.log("allDayViewModel.count="+allDayViewModel.count);
        console.log("dayEventsModel.count="+dayEventsModel.count);
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
        dateInFocus = tmpDate;
        scene.appDateInFocus = dateInFocus;
        dateInFocusVal = utilities.getDateInFormat(dateInFocus,UtilMethods.EDefault);
    }

    function resetFocus(offset)
    {
        dateInFocus = utilities.addDMYToGivenDate(dateInFocus,(offset),0,0);
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

    DayViewModel {
        id:allDayViewModel
        modelType:UtilMethods.EAllDay
        Component.onCompleted: {
            centerPane.allDayEventsCount = allDayViewModel.count;
        }
    }

    DayViewModel {
        id:dayEventsModel
        modelType:UtilMethods.ENotAllDay
    }


    CalendarListView {
        id: searchList
        visible:false
        onClose: {
            dayPage.showSearch=false;
        }
    }

    Column {
        id: dayViewData
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

        Item {
            id:spacerbox
            height:scene.content.height - (navHeader.height)
            width: scene.content.width
            BorderImage {
                    id: spacerImage
                    anchors.fill: parent
                    source: "image://theme/titlebar_l"

                    Rectangle {
                        id: calDataBox
                        height:scene.content.height - (navHeader.height)-20
                        width: scene.content.width-20
                        anchors.centerIn: parent
                        color: "lightgray"
                        border.width:2
                        border.color: "gray"

                        Item {
                            id:calData
                            anchors.fill: parent

                            Column {
                                y:0
                                move: Transition {
                                    NumberAnimation { properties: "y";duration: 250;easing.type: "OutSine" }
                                }
                                Rectangle {
                                    id:dayBox
                                    width:calData.width
                                    height:42
                                    color:"lightgray"
                                    Row {
                                        id:dayRow
                                        anchors.horizontalCenter: dayBox.horizontalCenter
                                        anchors.top: dayBox.top
                                        anchors.topMargin: 2

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
                                                      text:dateValString
                                                      font.bold: true
                                                      color:isCurrentDate(coreDateVal,index)?theme_buttonFontColorActive:theme_fontColorNormal
                                                      font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarge:theme_fontPixelSizeMedium
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
                                }//end of dayBox

                                Rectangle {
                                    id: allDayBox
                                    height: 60
                                    width:calData.width
                                    color:"white"
                                     Row {
                                         anchors.top: allDayBox.top
                                         Item {
                                             id: allDayTextIconBox
                                             height:allDayBox.height
                                             width: allDayBox.width/8
                                             z:1

                                             Item {
                                                 id:allDayTextBox
                                                 width:allDayTextIconBox.width
                                                 height: 30
                                                 anchors.top: allDayTextIconBox.top

                                                 Text {
                                                     id: allDayText
                                                     text: qsTr("All day")
                                                     anchors.centerIn: parent
                                                     font.bold: true
                                                     color:theme_fontColorNormal
                                                     font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarger:theme_fontPixelSizeMedium
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
                                                     var map = mapToItem (scene.content, mouseX, mouseY);
                                                     scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,true);
                                                 }
                                             }
                                         }

                                         //Display the all day events here
                                         Item {
                                            id: allDayEventsDisplayBox
                                            height:allDayBox.height
                                            width: allDayBox.width-allDayTextIconBox.width
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
                                                                     text: (index==2 && (allDayViewModel.count>3))?qsTr("%1 more events exist").arg(allDayViewModel.count-2):summary
                                                                     anchors.left: parent.left
                                                                     anchors.leftMargin: 20
                                                                     anchors.verticalCenter: parent.verticalCenter
                                                                     color:theme_fontColorNormal
                                                                     font.pixelSize:theme_fontPixelSizeMedium
                                                                     width:allDayDescBox.width
                                                                     elide: Text.ElideRight
                                                                 }
                                                             }//end allDayDescBox

                                                        }
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
                                                                 console.log("startDate="+utilities.getDateInFormatString(startDate,"dd MMM yyyy"));
                                                                 var map = mapToItem (scene.content, mouseX, mouseY);
                                                                 scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);

                                                             }
                                                             onLongPressAndHold: {
                                                                 //showPopUp(uid,eventActionsPopup,popUpLoader,allDayEventsDisplayBox,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay)
                                                                 var map = mapToItem (scene.content, mouseX, mouseY);
                                                                 displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,allDayImage,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                             }

                                                     }
                                                    }
                                                }
                                            }
                                            ExtendedMouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    var map = mapToItem (scene.content, mouseX, mouseY);
                                                    scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,true);
                                                }
                                            }

                                         }//end alldayeventsdisplaybox
                                     }

                                 }//end of alldaybox

                                Row {
                                    Rectangle {
                                         id: centerContent
                                         height: calData.height-dayBox.height-allDayBox.height-50
                                         width: calData.width
                                         border.width:2
                                         border.color: "gray"
                                         color:"white"

                                         ListView {
                                             id: timeListView
                                             anchors.top: parent.top
                                             height: centerContent.height
                                             width: centerContent.width
                                             clip: true
                                             model:timeListModel
                                             contentHeight:(timeListModel.count)*(50)
                                             contentWidth: timeListView.width
                                             z:1
                                             focus: true
                                             delegate: Item {
                                                         id: calTimeValBox
                                                         height: 50
                                                         width: centerContent.width
                                                         z:1
                                                         Rectangle {
                                                             id: timeValBox
                                                             height: parent.height
                                                             width:calDataBox.width/12
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
                                                                 font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeMedium:theme_fontPixelSizeSmall
                                                                 //width: timeValBox.width
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
                                                                 model: dayEventsModel
                                                                 focus: true
                                                                 Item {
                                                                     id: displayRect
                                                                     height: (startIndex == vacantAreaBox.parentIndex)?(heightUnits*vacantAreaBox.height):vacantAreaBox.height
                                                                     width: (startIndex == vacantAreaBox.parentIndex)?9*(widthUnits*vacantAreaBox.width)/10:9*(vacantAreaBox.width/10)
                                                                     x:(xUnits+xUnits*displayRect.width)+5
                                                                     z:5
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
                                                                                       text: qsTr("%1 - %2").arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale))
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
                                                                                 //scene.editEvent(uid);
                                                                                 var map = mapToItem (scene.content, mouseX, mouseY);
                                                                                 scene.openView (map.x,map.y,scene.container,uid,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay)
                                                                             }
                                                                             onLongPressAndHold: {
                                                                                 //showPopUp(uid,eventActionsPopup,popUpLoader,regEventImage,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                                 var map = mapToItem (scene.content, mouseX, mouseY);
                                                                                 displayContextMenu (map.x, map.y,uid,eventActionsPopup,popUpLoader,regEventImage,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay);
                                                                             }
                                                                         }
                                                                     }
                                                                     opacity: (startIndex == vacantAreaBox.parentIndex)?1:0
                                                                 }
                                                             }//end repeater

                                                         }//Inner rectangle with delegate to view the cal events

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

                                                     }//end calTimeValBox

                                             Component.onCompleted: {
                                                 timeListView.positionViewAtIndex(UtilMethods.EDayTimeStart,ListView.Beginning);
                                             }

                                         }

                                     }//end centerContent

                                }

                            }//end of Column inside calData

                        }//end of calData

                    }//end of calDatabox

            }//end of spacerImage            
        }
    }//end of top column

}
