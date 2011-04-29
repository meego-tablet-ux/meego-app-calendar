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
        //eventOptionsContextMenu.displayContextMenu(mapX,mapY);
        eventOptionsContextMenu.setPosition( mapX,mapY );
        eventOptionsContextMenu.show();

    }

    function openView (component,loader,popUpParent)
    {
        loader.sourceComponent = component
        loader.item.parent = popUpParent
        loader.item.eventId = eventId;
        loader.item.description = description;
        loader.item.summary = summary;
        loader.item.location = location;
        loader.item.alarmType = alarmType;
        loader.item.eventTime = timeVal;
        loader.item.displayDetails(mapX,mapY);
    }

    Loader {
        id:eventDetailsLoader
    }

    Component {
        id:viewDetails
        EventDetailsView {
            id:viewEventDetails
            eventId:eventId
            onClose: eventDetailsLoader.sourceComponent = undefined
        }
    }

    TopItem { id: topItem }

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
                    openView (viewDetails,eventDetailsLoader,scene.container);
                    eventOptionsContextMenu.hide();
                }
                else if (index == 1)
                {
                    console.log("Uid received is "+eventId);
                    scene.editEvent(mapX,mapY,eventId);
                    eventOptionsContextMenu.hide();
                }
                else if (index == 2)
                {
                    console.log("Uid received is "+eventId);
                    scene.deleteEvent(eventId);
                    eventOptionsContextMenu.hide();
                 }
            }
         }

    }//end ContextMenu

}
