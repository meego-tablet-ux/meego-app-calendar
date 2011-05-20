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

Window {
    id: window
    toolBarTitle: qsTr("Calendar")
    bookMenuModel: [qsTr("Day"),qsTr("Week"),qsTr("Month")]
    bookMenuPayload: [dayViewComponent,weekViewComponent,monthViewComponent]

    overlayItem:  Item {
        id: globalSpaceItems
        anchors.fill: parent

        Connections {
            target:window
            onSearch: {
                if(!searchList.visible) {
                    searchList.listModel.refresh();
                    window.searchResultCount = searchList.listModel.count;
                    searchList.visible = true;

                } else {
                    searchList.listModel.filterOut(needle);
                    searchList.listIndex = 0;
                    window.searchResultCount = searchList.listModel.count;
                }
            }
            onSearchExpanded: {
                searchList.listModel.refresh();
                window.searchResultCount = searchList.listModel.count;
            }

            onSearchRetracted: {
                if(searchList.visible)
                    searchList.visible = false;
            }
        }

        CalendarListView {
            id: searchList
            anchors.fill: parent
            visible:false

            MouseArea {
                anchors.fill: parent
                z:-1
            }
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

        EventDetailsView {
            id:viewEventDetails
            eventId:eventId
        }

        DatePicker {
            id:datePicker
            onDateSelected: {
                window.dateFromOutside = selectedDate;
                window.appDateInFocus = selectedDate;
                window.gotoDate = true;
            }
        }

        ModalDialog {
            id:confirmDeleteDialog
            title :qsTr("Delete event?")
            buttonHeight: 35
            showCancelButton: true
            showAcceptButton: true
            cancelButtonText: qsTr( "Cancel" )
            acceptButtonText: qsTr( "Delete" )
            property string eventId
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
                window.deletedEvent = true;
                confirmDeleteDialog.hide();
            }
            onRejected: {
                confirmDeleteDialog.hide();
            }
        }

    }



    Component.onCompleted: {
        switchBook(dayViewComponent)
    }

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
            var cmd = parameters[0];
            var cdata = parameters[1];

            if (cmd == "openCalendar") {
                var calData = cdata;
                var calDataList = calData.split(',');
                var uid = calDataList[0];
                var dateVal = new Date(utilities.getLongDate(utilities.getDateFromVal(calDataList[1])));
                dateFromOutside = dateVal;
                triggeredExternally = true;
                switchBook(dayViewComponent);

            }
        }
    }


    UtilMethods {
        id: utilities
    }

    Labs.LocaleHelper {
        id:i18nHelper
    }

    Component {
        id:dayViewComponent
        CalendarDayView {
            id: dayPage
            anchors.fill:parent            
        }
    }

    Component {
        id:weekViewComponent
        CalendarWeekView {
            id: weekPage
            anchors.fill:parent
        }
    }

    Component {
        id:monthViewComponent
        CalendarMonthView {
            id: monthPage
            anchors.fill:parent            
        }
    }

    function initEventDateVals()
    {
        var tmpDate = utilities.getCurrentDateVal();
        window.eventDay=tmpDate.getDate();
        window.eventMonth=(tmpDate.getMonth()+1);
        window.eventYear=tmpDate.getFullYear();
    }

    function openNewEventView(xVal,yVal,isAllDay)
    {        
        window.eventDay=window.appDateInFocus.getDate();
        window.eventMonth=(window.appDateInFocus.getMonth()+1);
        window.eventYear=window.appDateInFocus.getFullYear();
        addNewEventLoader.sourceComponent = addNewEventComponent
        addNewEventLoader.item.windowType = UtilMethods.EAddEvent;
        addNewEventLoader.item.eventDay = eventDay;
        addNewEventLoader.item.eventMonth = eventMonth;
        addNewEventLoader.item.eventYear = eventYear;
        addNewEventLoader.item.eventStartHr = eventStartHr;
        addNewEventLoader.item.eventEndHr = eventEndHr;
        addNewEventLoader.item.isAllDay = isAllDay;
        addNewEventLoader.item.initView=true;
        addNewEventLoader.item.setPosition(xVal,yVal);
        addNewEventLoader.item.show();
        addNewEventLoader.item.newEvent();
    }

    function editEvent(xVal,yVal,uid)
    {        
        addNewEventLoader.sourceComponent = addNewEventComponent;
        addNewEventLoader.item.windowType = UtilMethods.EModifyEvent;
        addNewEventLoader.item.editEventId = uid;
        addNewEventLoader.item.editView=true;
        addNewEventLoader.item.setPosition(xVal,yVal);
        addNewEventLoader.item.show();
        addNewEventLoader.item.editEvent();
    }

    function deleteEvent(uid)
    {
        confirmDeleteDialog.eventId = uid;
        confirmDeleteDialog.show();
    }


    function openDatePicker()
    {
        datePicker.show();
    }



    function openView (xVal,yVal,eventId,description,summary,location,alarmType,repeatString,startDate,startTime,endTime,zoneOffset,allDay,viewVisible,backVisible)
    {
        viewEventDetails.initEventDetails(viewVisible,backVisible);
        viewEventDetails.eventId = eventId;
        viewEventDetails.description = description;
        viewEventDetails.summary = summary;
        viewEventDetails.location = location;
        viewEventDetails.alarmType = alarmType;
        viewEventDetails.repeatText = repeatString;
        viewEventDetails.startDate = startDate;
        viewEventDetails.startTime = startTime;
        viewEventDetails.endTime = endTime;
        viewEventDetails.allDay = allDay;
        viewEventDetails.zoneOffset = zoneOffset;
        viewEventDetails.displayDetails(xVal,yVal);
        viewEventDetails.show();
    }

    function  openViewFromMonthMultiEvents(xVal,yVal,popUpParent,eventId,description,summary,location,alarmType,repeatString,timeVal,coreDateVal)
    {
        viewEventDetails.initEventDetails(false,true);
        viewEventDetails.eventId = eventId;
        viewEventDetails.description = description;
        viewEventDetails.summary = summary;
        viewEventDetails.location = location;
        viewEventDetails.alarmType = alarmType;
        viewEventDetails.repeatText = repeatString;
        viewEventDetails.eventTime = timeVal;
        viewEventDetails.startDate = coreDateVal;
        viewEventDetails.displayDetails(xVal,yVal);
        viewEventDetails.show();
    }

    CalendarController {
        id: controller
    }
}//end Window

