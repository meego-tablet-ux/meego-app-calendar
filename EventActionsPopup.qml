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
    property string repeatText
    property date startDate
    property variant startTime
    property variant endTime
    property int zoneOffset
    property string zoneName
    property bool allDay
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

    ContextMenu {
        id: eventOptionsContextMenu
        content:  ActionMenu {
            id: actionMenu

            model: [qsTr ("Event details"), qsTr ("Edit event"), qsTr ("Delete event")]
            payload: [ 0,1,2]

            onTriggered: {
                if (index == 0)
                {
                    window.openView(mapX,mapY,eventId,description,summary,location,alarmType,repeatText,startDate,startTime,endTime,zoneOffset,zoneName,allDay,false,false)
                    //Deviating from conventional hide() and using my own signal close() because of the way the PopUp is handled from the calling components
                    eventActionsPopup.close();
                }
                else if (index == 1)
                {
                    window.editEvent(mapX,mapY,eventId);
                    //Deviating from conventional hide() and using my own signal close() because of the way the PopUp is handled from the calling components
                    eventActionsPopup.close();
                }
                else if (index == 2)
                {
                    window.deleteEvent(eventId);
                    //Deviating from conventional hide() and using my own signal close() because of the way the PopUp is handled from the calling components
                    eventActionsPopup.close();
                 }
            }
         }

    }//end ContextMenu

}
