/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs
import MeeGo.Components 0.1

DropDown {
      id: tzCmb
      anchors.left: parent.left
      anchors.leftMargin: 25
      width: parent.width
      height:40
      anchors.verticalCenter: parent.verticalCenter
      model: modelArr
      payload: payloadArr
      replaceDropDownTitle:true
      titleColor: "black"
      property int gmtOffset:0
      property string gmtName
      property variant modelArr
      property variant payloadArr
      property variant offsetArr
      property variant gmtNameArr

      onTriggered: {
          gmtOffset = offsetArr[index]*3600;
          gmtName = gmtNameArr[index];
          selectedIndex = index;
      }

      function reInit() {
          var modelArr1 = new Array();
          var payloadArr1 = new Array();
          var offsetArr1 = new Array();
          var gmtNameArr1 = new Array();
          for(var i=0;i<window.addEditTimeZoneList.count;i++) {
              //: This Time zone string  %1 corresponds to cityname, %2 corresponds to GMT offset. Both strings are localized. Translators don't have to do anything here.
              modelArr1[i] = qsTr("%1 (%2)").arg(window.addEditTimeZoneList.getData(i, Labs.TimezoneListModel.Title)).arg(window.addEditTimeZoneList.getData(i, Labs.TimezoneListModel.LongGMTName));
              payloadArr1[i] = i;
              offsetArr1[i] = window.addEditTimeZoneList.getData(i, Labs.TimezoneListModel.GMTOffset);
              gmtNameArr1[i] = window.addEditTimeZoneList.getData(i, Labs.TimezoneListModel.Title);
          }

          tzCmb.modelArr = modelArr1;
          tzCmb.payloadArr = payloadArr1;
          tzCmb.offsetArr = offsetArr1;
          tzCmb.gmtNameArr = gmtNameArr1;

          for (var i=0; i < tzCmb.gmtNameArr.length; i++) {
              if (tzCmb.gmtNameArr[i] == tzCmb.gmtName) {
                  tzCmb.selectedIndex = i;
              }
          }
          tzCmb.title = gmtName;
          tzCmb.selectedTitle = gmtName;
      }


}//end DropDown


