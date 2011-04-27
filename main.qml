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

Labs.Window {
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
            applicationData = parameters;
        }
    }

    onApplicationDataChanged: {
        if(applicationData != undefined)
        {
            var cmd = applicationData[0];
            var cdata = applicationData[1];

            scene.applicationData = undefined;

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
    }

    // callback used when the user touches the statusbar
    onStatusBarTriggered: {
        orientation = (orientation +1)%4;
    }

    UtilMethods {
        id: utilities
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    Loader {
        id: addNewEventLoader
    }

    Component {
        id: addNewEventComponent
        NewEventView {
            onClose: addNewEventLoader.sourceComponent = undefined
        }
    }


    Component {
        id:dayViewComponent
        Labs.ApplicationPage {
            id: dayPage
            anchors.fill:parent
            title:qsTr("Day")
            menuContent: actionsMenu

            Connections {
                target:  dayPage.menuItem
                onCloseActionsMenu: {
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
        Labs.ApplicationPage {
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
        Labs.ApplicationPage {
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
        var tmpDate = utilities.getCurrentDateVal();
        scene.eventDay=tmpDate.getDate();
        scene.eventMonth=(tmpDate.getMonth()+1);
        scene.eventYear=tmpDate.getFullYear();
    }

    function openNewEventView(xVal,yVal,component, loader,isAllDay)
    {
        scene.eventDay=scene.appDateInFocus.getDate();
        scene.eventMonth=(scene.appDateInFocus.getMonth()+1);
        scene.eventYear=scene.appDateInFocus.getFullYear();
        loader.sourceComponent = component
        loader.item.parent = scene.container
        loader.item.windowType = UtilMethods.EAddEvent;
        loader.item.eventDay = eventDay;
        loader.item.eventMonth = eventMonth;
        loader.item.eventYear = eventYear;
        loader.item.eventStartHr = eventStartHr;
        loader.item.eventEndHr = eventEndHr;
        loader.item.isAllDay = isAllDay;
        loader.item.initView=true;
        loader.item.displayNewEvent(xVal,yVal);
    }

    function editEvent(xVal,yVal,uid)
    {
        addNewEventLoader.sourceComponent = addNewEventComponent;
        addNewEventLoader.item.parent = scene.container;
        addNewEventLoader.item.windowType = UtilMethods.EModifyEvent;

        addNewEventLoader.item.editEventId = uid;
        addNewEventLoader.item.editView=true;
        addNewEventLoader.item.displayNewEvent(xVal,yVal);
    }

    function deleteEvent(uid)
    {
        dialogLoader.sourceComponent = confirmDelete;
        dialogLoader.item.parent = scene.container;
        dialogLoader.item.eventId = uid;
        dialogLoader.item.show();
    }


    function openDatePicker(popUpParent)
    {
        datePickerLoader.sourceComponent = datePickerComponent;
        datePickerLoader.item.parent = popUpParent;
        datePickerLoader.item.show();
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
            //eventDetailsLoader.item.eventTime = qsTr("%1, %2").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate)).arg(qsTr("All day"));
            eventDetailsLoader.item.eventTime = qsTr("%1, %2").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(qsTr("All day"));
        } else  {
            //eventDetailsLoader.item.eventTime = qsTr("%1, %2 - %3").arg(utilities.getDateInFormat(startDate,UtilMethods.ESystemLocaleLongDate)).arg(utilities.getTimeInFormat(startTime,UtilMethods.ETimeSystemLocale)).arg(utilities.getTimeInFormat(endTime,UtilMethods.ETimeSystemLocale));
            eventDetailsLoader.item.eventTime = qsTr("%1, %2 - %3").arg(i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFull)).arg(i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort)).arg(i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort));
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
            }
        }
    }


    Loader {
        id:datePickerLoader
    }

    Component {
        id:datePickerComponent
        DatePicker {
            id:datePicker
            height:(scene.isLandscapeView())? scene.container.height:scene.container.width
            width:(scene.isLandscapeView())?scene.container.width/2:scene.container.height/3
            autoCenter:true
            onDateSelected: {
                scene.dateFromOutside = selectedDate;
                scene.appDateInFocus = selectedDate;
                scene.gotoDate = true;
                datePickerLoader.sourceComponent=undefined;
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
            title :qsTr("Delete event?")
            buttonHeight: 35
            showCancelButton: true
            showAcceptButton: true
            cancelButtonText: qsTr( "Cancel" )
            acceptButtonText: qsTr( "Delete" )
            property string eventId
            autoCenter:true
            alignTitleCenter:true

            content: Item {
                id: myContent
                anchors.fill:parent
                anchors.margins: 10
                Text {
                    id:errorMsg
                    text: qsTr("Are you sure you want to delete this event?")
                    anchors.fill:parent
                    wrapMode:Text.Wrap
                    font.pixelSize: theme_fontPixelSizeLarge
                }
            }

            // handle signals:
            onAccepted: {
                controller.deleteEvent(eventId);
                scene.deletedEvent = true;
                dialogLoader.sourceComponent = undefined;
            }
            onRejected: {
                dialogLoader.sourceComponent = undefined;
            }
        }
    }

    Component {
        id: actionsMenu
        ActionMenu {
            id: actionsMenuItem
            signal closeActionsMenu()
            model: [ qsTr("Create new event"), qsTr("Go to today"), qsTr("Go to date")]

            onTriggered: {
                switch (index) {
                    case 0: {
                        actionsMenuItem.closeActionsMenu();
                        scene.openNewEventView(scene.container.width-(actionsMenuItem.contentWidth)/3,(actionsMenuItem.contentHeight)/3, addNewEventComponent, addNewEventLoader,false);
                        break;
                    }
                    case 1: {
                        scene.gotoToday=true;
                        actionsMenuItem.closeActionsMenu();
                        break;
                    }
                    case 2: {
                        actionsMenuItem.closeActionsMenu();
                        openDatePicker(scene.container);
                        break;
                    }
                }
            }
        }
    }//end actionsMenu

}//end Window

