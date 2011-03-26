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

Window {
    id: scene    
    showsearch: false
    title: qsTr("Calendar")
    filterModel: [qsTr("Day"),qsTr("Week"),qsTr("Month")]
    applicationPage: dayViewComponent

    property int animationduration:250
    property int buttonval:1
    property bool addedEvent:false
    property bool deletedEvent:false
    property bool gotoToday:false
    property bool gotoDate:false
    property bool triggeredExternally:false
    property int eventDay:initEventDateVals()
    property int eventMonth:0
    property int eventYear:0
    property int eventStartHr:-1
    property int eventEndHr:-1
    property date dateFromOutside
    property int searchResultCount:0
    property date appDateInFocus


    Connections {
        target: mainWindow
        onCall: {
            console.log("Global onCall: " + parameters);
            applicationData = parameters;
        }
    }

    onApplicationDataChanged: {
        if(applicationData != undefined)
        {
            console.log("Remote Call: " + applicationData);
            var cmd = applicationData[0];
            var cdata = applicationData[1];

            scene.applicationData = undefined;
            console.log("in landing screen");

            if (cmd == "openCalendar")
            {
                scene.applicationPage=dayViewComponent;
                var calData = cdata;
                var calDataList = calData.split(',');
                var uid = calDataList[0];
                var dateVal = new Date(utilities.getLongDate(utilities.getDateFromVal(calDataList[1])));
                dateFromOutside = dateVal;
                triggeredExternally = true;
            }
        }
    }


    onFilterTriggered: {
        if (index == 0) {
            buttonval=0;
            scene.applicationPage=dayViewComponent;
        }else if( index == 1) {
            buttonval=1;
            scene.applicationPage=weekViewComponent;
        }else if(index ==2) {
            buttonval=2;
            scene.applicationPage=monthViewComponent;
        }
    }

    onSearch: {
        searchTriggered = true;
        console.log("search: " + needle);
    }

    // callback used when the user touches the statusbar
    onStatusBarTriggered: {
        orientation = (orientation +1)%4;
    }

    UtilMethods {
        id: utilities
    }

    Loader {
        id: addNewEventLoader
    }

    Component {
        id: addNewEventComponent
        NewEventView {
            //menuWidth:400 //(scene.isLandscapeView())?(scene.width/2):(2*(scene.height/3))
            //menuHeight: 400 //(scene.isLandscapeView())?((scene.height)-100):(scene.width/2)
            onClose: addNewEventLoader.sourceComponent = undefined
        }
    }


    Component {
        id:dayViewComponent
        ApplicationPage {
            id: dayPage
            anchors.fill:parent
            title:qsTr("Day")
            menuContent: actionsMenu

            Connections {
                target:  dayPage.menuItem
                onCloseActionsMenu: {
                    console.log("Inside the onCloseActionsMenu");
                    dayPage.closeMenu();
                }
            }

            Item {
                id: landingScreenItem
                parent: dayPage.content
                anchors.fill: dayPage.content
                CalendarDayView {
                    id:dayPane
                }
            }
        }
    }

    Component {
        id:weekViewComponent
        ApplicationPage {
            id: weekPage
            anchors.fill:parent
            title:qsTr("Week")
            menuContent: actionsMenu
            Connections {
                target:  weekPage.menuItem
                onCloseActionsMenu: {
                    weekPage.closeMenu();
                }
            }
            Item {
                id: landingScreenItem
                parent: weekPage.content
                anchors.fill: weekPage.content
                CalendarWeekView {
                    id:weekPane
                }
            }

        }
    }

    Component {
        id:monthViewComponent
        ApplicationPage {
            id: monthPage
            anchors.fill:parent
            title:qsTr("Month")
            menuContent: actionsMenu
            Connections {
                target:  monthPage.menuItem
                onCloseActionsMenu: {
                    monthPage.closeMenu();
                }
            }
            Item {
                id: landingScreenItem
                parent: monthPage.content
                anchors.fill: monthPage.content
                CalendarMonthView {
                    id:dayPane
                }
            }
        }
    }

    function initEventDateVals()
    {
        console.log("Inside initEventDateVals()");
        var tmpDate = utilities.getCurrentDateVal();
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
    }

    function openNewEventView(xVal,yVal,component, loader,isAllDay)
    {
        loader.sourceComponent = component
        loader.item.parent = scene.container
        loader.item.windowType = UtilMethods.EAddEvent;
        loader.item.eventDay = eventDay;
        loader.item.eventMonth = eventMonth;
        loader.item.eventYear = eventYear;
        loader.item.eventStartHr = eventStartHr;
        loader.item.eventEndHr = eventEndHr;
        loader.item.isAllDay = isAllDay;

        scene.eventDay=scene.appDateInFocus.getDate();
        scene.eventMonth=(scene.appDateInFocus.getMonth()+1);
        scene.eventYear=scene.appDateInFocus.getFullYear();
        loader.item.initView=true;
        loader.item.displayNewEvent(xVal,yVal);

        /*if(loader.item.initializeView!=undefined) {
            loader.item.initializeView(eventDay,eventMonth,eventYear,eventStartHr,eventEndHr,isAllDay);
        }

        var menuContainer = loader.item

        menuContainer.z = 100
        menuContainer.fogOpacity = 0.5
        menuContainer.menuOpacity = 1.0*/
    }

    function editEvent(xVal,yVal,uid)
    {
        console.log("Obtained Uid="+uid);
        addNewEventLoader.sourceComponent = addNewEventComponent;
        addNewEventLoader.item.parent = scene.container;
        addNewEventLoader.item.windowType = UtilMethods.EModifyEvent;

        addNewEventLoader.item.editEventId = uid;
        addNewEventLoader.item.editView=true;
        addNewEventLoader.item.displayNewEvent(xVal,yVal);


        /*addNewEventLoader.item.initializeModifyView(uid);

        var menuContainer = addNewEventLoader.item

        menuContainer.z = 100
        menuContainer.fogOpacity = 0.5
        menuContainer.menuOpacity = 1.0*/

    }

    function deleteEvent(uid)
    {
        console.log("Obtained uid="+uid);
        dialogLoader.sourceComponent = confirmDelete;
        dialogLoader.item.parent = scene.container;
        dialogLoader.item.eventId = uid;
    }


    function openDatePicker(popUpParent,xVal,yVal)
    {
       console.log("From openDatePicker");
        datePickerLoader.sourceComponent = datePickerComponent;
        datePickerLoader.item.parent = popUpParent;
       datePickerLoader.item.show(xVal,yVal);
    }



    function openView (xVal,yVal,popUpParent,eventId,description,summary,location,alarmType,startDate,startTime,endTime,zoneOffset,allDay)
    {
        eventDetailsLoader.sourceComponent = viewDetails
        eventDetailsLoader.item.initEventDetails(false,false);
        eventDetailsLoader.item.parent = popUpParent
        eventDetailsLoader.item.eventId = eventId;
        eventDetailsLoader.item.description = description;
        eventDetailsLoader.item.summary = summary;
        eventDetailsLoader.item.location = location;
        eventDetailsLoader.item.alarmType = alarmType;
        if(allDay) {
            eventDetailsLoader.item.eventTime = qsTr("%1, ").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate))+qsTr("All day");
        } else  {
            eventDetailsLoader.item.eventTime = qsTr("%1, %2 - %3").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate)).arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale));
        }
        eventDetailsLoader.item.displayDetails(xVal,yVal);
    }

    function  openViewFromMonthMultiEvents(xVal,yVal,popUpParent,eventId,description,summary,location,alarmType,timeVal,coreDateVal)
    {
        eventDetailsLoader.sourceComponent = viewDetails
        eventDetailsLoader.item.initEventDetails(false,true);
        eventDetailsLoader.item.parent = popUpParent
        eventDetailsLoader.item.eventId = eventId;
        eventDetailsLoader.item.description = description;
        eventDetailsLoader.item.summary = summary;
        eventDetailsLoader.item.location = location;
        eventDetailsLoader.item.alarmType = alarmType;
        eventDetailsLoader.item.eventTime = timeVal;
        eventDetailsLoader.item.startDate = coreDateVal;
        eventDetailsLoader.item.displayDetails(xVal,yVal);
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
                console.log("Closed EventDetails from main");
            }
        }
    }


    Loader {
        id:datePickerLoader
    }

    Component {
        id:datePickerComponent
        DatePickerDialog {
            id:datePicker
            z:1000
            property bool cancelAction:false
            onClosed: {
                if(cancelAction==false) {
                    scene.gotoDate = true;
                    console.log("Inside onClosed, set scene.gotoDate="+scene.gotoDate);
                   datePickerLoader.sourceComponent=undefined;
                }
            }
            onTriggered: {
                scene.dateFromOutside = date;
                scene.appDateInFocus = date;
                //optionsMenu.visible=false;
                datePicker.cancelAction = false;
                console.log("Inside onTriggered, set scene.gotoDate="+scene.gotoDate);
            }
            onCancel: {
                scene.gotoDate = false;
                datePicker.cancelAction = true;
                console.log("Inside onCancel, set scene.gotoDate="+scene.gotoDate);
                //datePickerLoader.sourceComponent=undefined;
            }
        }
    }



    Loader {
        id:dialogLoader
    }

    CalendarController {
        id: controller
    }

    Component {
        id:confirmDelete
        ModalDialog {
            id:confirmDeleteDialog
            leftButtonText:qsTr("Delete")
            rightButtonText: qsTr("Cancel")
            dialogTitle: qsTr ("Delete event")
            Text {
                id:errorMsg
                text: qsTr("Are you sure you want to delete this event?")
                anchors.centerIn:parent
                color:theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeLarge
                elide: Text.ElideRight
            }
            z:5000
            property string eventId
            onDialogClicked: {
                if(button==1)  {
                    controller.deleteEvent(eventId);
                    scene.deletedEvent = true;
                    console.log(" scene.deletedEvent="+ scene.deletedEvent);
                    dialogLoader.sourceComponent = undefined;
                } else {
                    dialogLoader.sourceComponent = undefined;
                }
            }
        }
    }

    Component {
        id: actionsMenu
        Item {
            id: actionsMenuItem
            width: scene.width/4
            height:(scene.height/4)+2
            signal closeActionsMenu()
            Item {
                id:optionsMenu
                anchors.fill:parent
                Column {
                    Item {
                        id:createEventBox
                        width:optionsMenu.width
                        height:optionsMenu.height/3
                        Text {
                            id:createEventTxt
                            text:qsTr("Create new event")
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 15
                            color:theme_fontColorNormal
                            font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarger:theme_fontPixelSizeLarge
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var map = mapToItem (scene.content, mouseX, mouseY);
                                scene.openNewEventView(map.x,map.y,addNewEventComponent, addNewEventLoader,false);
                                actionsMenuItem.closeActionsMenu();

                            }
                        }
                    }//end of createEvent

                    Rectangle {
                        id:spacer1
                        color: theme_fontColorNormal
                        height: 1
                        width:optionsMenu.width
                    }

                    Item {
                        id:gotoTodayBox
                        width:optionsMenu.width
                        height:optionsMenu.height/3
                        Text {
                            id:gotoTodayTxt
                            text:qsTr("Go to today")
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 15
                            color:theme_fontColorNormal
                            font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarger:theme_fontPixelSizeLarge
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                scene.gotoToday=true;
                                actionsMenuItem.closeActionsMenu();
                                return;
                            }
                        }
                    }//end of gotoToday

                    Rectangle {
                        id:spacer2
                        color: theme_fontColorNormal
                        height: 1
                        width:optionsMenu.width
                    }

                    Item {
                        id:gotoDateBox
                        width:optionsMenu.width
                        height:optionsMenu.height/3
                        Text {
                            id:gotoDateTxt
                            text:qsTr("Go to date...")
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 15
                            color:theme_fontColorNormal
                            font.pixelSize: (scene.isLandscapeView())?theme_fontPixelSizeLarger:theme_fontPixelSizeLarge
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var map = mapToItem (scene.content, mouseX, mouseY);
                                openDatePicker(scene.container,map.x,map.y);
                                actionsMenuItem.closeActionsMenu();
                                return;
                            }
                        }
                    }//end of gotodate
                }

            }

        }
    }

}

