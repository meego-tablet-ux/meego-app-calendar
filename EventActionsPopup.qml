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

Item {
    id: eventActionsPopup
    width: eventOptionsContextMenu.width

    property string eventId
    property string description
    property string summary
    property string location
    property int alarmType:0
    property date startDate
    property date startTime
    property int zoneOffset
    property string eventTime
    property string timeVal
    property int mapX:0
    property int mapY:0
    signal close()

    function initMaps()
    {
        eventOptionsContextMenu.setPosition( mapX,mapY );
        eventOptionsContextMenu.show();

    }

    function openView (component,popUpParent)
    {
        viewEventDetails.eventId = eventId;
        viewEventDetails.description = description;
        viewEventDetails.summary = summary;
        viewEventDetails.location = location;
        viewEventDetails.alarmType = alarmType;
        viewEventDetails.eventTime = timeVal;
        viewEventDetails.displayDetails(mapX,mapY);
        viewEventDetails.show();
        console.log("showing the details window")

    }


    EventDetailsView {
        id:viewEventDetails
        eventId:eventId
    }


    ContextMenu {
        id: eventOptionsContextMenu
        content:  ActionMenu {
            id: actionMenu

            model: [qsTr ("Event details"), qsTr ("Edit event"), qsTr ("Delete event")]
            payload: [ 0,1,2]

            onTriggered: {
                if (index == 0)
                {
                    console.log("Uid received is "+eventId);
                    eventOptionsContextMenu.hide();
                    openView (viewEventDetails,window);
                }
                else if (index == 1)
                {
                    console.log("Uid received is "+eventId);
                    eventOptionsContextMenu.hide();
                    window.editEvent(mapX,mapY,eventId);
                }
                else if (index == 2)
                {
                    console.log("Uid received is "+eventId);
                    eventOptionsContextMenu.hide();
                    window.deleteEvent(eventId);
                 }
            }
         }

    }//end ContextMenu

}
