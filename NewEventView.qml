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

Labs.AbstractContext {
    id:outer

    property int windowType:0
    property bool initView:false
    property bool editView:false

    property int eventDay
    property int eventMonth
    property int eventYear
    property int eventStartHr
    property int eventEndHr
    property bool isAllDay
    property string editEventId
    property int paintedTextMaxWidth:400

    signal close()

    function displayNewEvent (mouseX, mouseY) {
        outer.mouseX = mouseX
        outer.mouseY = mouseY
        visible = true;
        outer.modalSurfaceItem.autoCenter = true;
        outer.modalSurfaceItem.closeUponFogClicked = false;
    }



    content:Item {
        id: container
        height:400
        width:paintedTextMaxWidth

        property bool initView:outer.initView
        property bool editView:outer.editView

        onInitViewChanged: {
            if(initView) {
                initializeView(eventDay,eventMonth,eventYear,eventStartHr,eventEndHr,isAllDay);
                initView = false;
            }

        }
        onEditViewChanged: {
            if(editView) {
                initializeModifyView(editEventId);
                editView = false;
            }
        }


        property int windowType:outer.windowType

        property alias dateTimeBoxSeen: dateTimeBox.visible
        property alias dTBox: dateTimeBox
        property variant model: undefined
        property int itemHeight: 50
        property bool allDaySet:false
        property string eventTitle
        property string titleBlockText
        property int titleClickCount:0
        property string startDateStr
        property string endDateStr
        property string startTimeStr
        property string endTimeStr
        property date startDate
        property date endDate
        property date repeatEndDate
        property variant startTime
        property variant endTime
        property string uid
        property int gmtOffset
        property variant editEvent
        property string errorMsg:qsTr("Check the date and time inputs")


        function resetValues(date1,time1,date2,time2)
        {
            startDate = date1;
            endDate = date2;
            startTime = time1;
            endTime = time2;
            startDateTxt.text = i18nHelper.localDate(date1, Labs.LocaleHelper.DateFullShort); //utilities.getDateInFormat(date1,UtilMethods.EDefault);
            finishDateTxt.text = i18nHelper.localDate(date2, Labs.LocaleHelper.DateFullShort); //utilities.getDateInFormat(date2,UtilMethods.EDefault);
            startTimeTxt.text = i18nHelper.localTime(time1, Labs.LocaleHelper.TimeFullShort); //utilities.getTimeInFormat(time1,UtilMethods.ETimeSystemLocale);
            finishTimeTxt.text = i18nHelper.localTime(time2, Labs.LocaleHelper.TimeFullShort); //utilities.getTimeInFormat(time2,UtilMethods.ETimeSystemLocale);
        }

        function setEndRepeatDateValues() {
            endRepeatDayText.text = finishDateTxt.text;
        }

        function  validateInputs() {
            var validData = true;

            if(!allDaySet) {
                validData = validateDateTime(startDate,endDate,startTime,endTime);
            }

            if(!validData) {
               //confirmDialog.show();
                showErrorMessage();
            }
            return validData;
        }

        function validateDateTime(date1,date2,time1,time2) {
            var isValid = true;
            if(!allDayCheck.on) {
                var compareDatesVal = utilities.compareDates(date1,date2);
                var compareTimesVal = utilities.compareTimes(time1,time2);

                if(compareDatesVal==2) {
                    isValid=false;
                } else {
                    if(compareTimesVal==2 || compareTimesVal==0) {
                        if(compareDatesVal==1)
                            isValid = true;
                        else
                            isValid = false;
                    } else {
                        isValid = true;
                    }
                }
            }
            return isValid;
        }


        function showErrorMessage()
        {
            messageBoxLoader.sourceComponent = messageBoxcomponent;
            messageBoxLoader.item.parent = scene.container;
            messageBoxLoader.item.show();
         }

        Loader {
            id:messageBoxLoader
        }

        Component {
            id:messageBoxcomponent
            ModalDialog {
                id:confirmDialog
                title :qsTr("Error")
                buttonHeight: 35
                showCancelButton: false
                showAcceptButton: true
                //cancelButtonText: qsTr( "Error" )
                acceptButtonText: qsTr( "OK" )
                autoCenter:true
                alignTitleCenter:true

                content: Item {
                    id: myContent
                    anchors.fill:parent
                    anchors.margins: 10
                    Text {
                        id:confirmMsg
                        text: qsTr("Please check the date and time entered")
                        anchors.fill:parent
                        wrapMode:Text.Wrap
                        font.pixelSize: theme_fontPixelSizeLarge
                    }
                }

                onAccepted: {
                    messageBoxLoader.sourceComponent = undefined
                }

            }
       }

        function createIOObject() {
            //Initialize variables
            var repeatEndDateVal="";
            var repeatCnt = 0;
            var isAllDay = false;
            eventIO.repeatType = UtilMethods.ENoRepeat;
            eventIO.repeatEndType = UtilMethods.EForever;
            eventIO.alarmType = UtilMethods.ENoAlarm;

            //Now actually set the event values
            eventIO.type = UtilMethods.EEvent;
            eventIO.uid = uid;
            eventIO.description = notesInputText.text;
            eventIO.summary = eventTitleText.text;
            eventIO.location = locInputText.text;
            if(allDayCheck.on) {
                isAllDay=true;
            } else {
                isAllDay=false;
            }
            eventIO.allDay = isAllDay;

            if(eventIO.allDay ) {
                eventIO.setStartDateTime(startDate,"",tzCmb.selectedVal);
            } else if(!eventIO.allDay ) {
                eventIO.setStartDateTime(startDate,startTime,tzCmb.selectedVal);
                eventIO.setEndDateTime(endDate,endTime,tzCmb.selectedVal);
            }
            eventIO.zoneOffset = tzCmb.modelVal;

            eventIO.repeatType = repeatCmbBlock.repeatType;
            eventIO.repeatEndType = repeatEndComboBox.repeatEndType;

            if(eventIO.repeatType != UtilMethods.ENoRepeat) {
                if(eventIO.repeatEndType == UtilMethods.EForNTimes) {
                    if(repeatCountText.text!="") {
                        repeatCnt = parseInt(repeatCountText.text);
                        eventIO.repeatCount = repeatCnt;
                    }
                } else if(eventIO.repeatEndType == UtilMethods.EAfterDate) {
                    if(endRepeatDayText.text!="") {
                        eventIO.setRepeatEndDateTime(repeatEndDate, endTime,tzCmb.selectedVal);
                    }
                } else if(eventIO.repeatEndType == UtilMethods.EForever) {

                }
            }

            eventIO.alarmType = alarmCmb.selectedIndex;

            if(windowType == UtilMethods.EAddEvent) {
                controller.addModifyEvent(UtilMethods.EAddEvent,eventIO);
            } else if(windowType == UtilMethods.EModifyEvent) {
                controller.addModifyEvent(UtilMethods.EModifyEvent,eventIO);
            }

            scene.addedEvent = true;
        }


        function initializeView(eventDay,eventMonth,eventYear,eventStartHr,eventEndHr,isAllDay) {
            titleBlockText = qsTr("New event");
            if(eventDay==0 ||eventMonth==0 ||eventYear==0) {
                startDate = utilities.getCurrentDateVal();
                endDate = utilities.getCurrentDateVal();
                startDateStr = i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFullShort);
                endDateStr = i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFullShort);
            } else {
                startDate = utilities.createDateFromVals(eventDay,eventMonth,eventYear);
                startDateStr=i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFullShort);
                endDate = startDate;
                endDateStr = startDateStr;
            }

            if(isAllDay) {
                allDayCheck.on = true;
            } else {
                allDayCheck.on = false;
            }

            if(eventStartHr==-1 || eventEndHr==-1) {
                startTime = utilities.getCurrentTimeVal();
                startTime = utilities.roundTime(startTime);
                startTimeStr = i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort);
                endTime = utilities.addHMToCurrentTime(1,0);
                endTime = utilities.roundTime(endTime);
                endTimeStr = i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort);
            } else {
                startTime = utilities.createTimeFromVals(eventStartHr,0);
                startTimeStr = i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort);

                var eventEndTimeStr = eventEndHr.toString();
                if(eventEndTimeStr.length > 3) {
                    endTime = utilities.createTimeFromVals(parseInt(eventEndTimeStr.substr(0,2)),parseInt(eventEndTimeStr.substr(2,2)));
                } else {
                    endTime = utilities.createTimeFromVals(parseInt(eventEndTimeStr.substr(0,1)),parseInt(eventEndTimeStr.substr(1,2)));
                }
                endTimeStr = i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort);
            }

            startDateTxt.text = startDateStr;
            finishDateTxt.text = endDateStr;
            startTimeTxt.text = startTimeStr;
            finishTimeTxt.text = endTimeStr;
            alarmCmb.selectedIndex=0;
            repeatCmb.selectedIndex=0;
            tzCmb.selectedIndex=0;
        }

        function initializeModifyView(eventId)
        {
            titleBlockText = "";
            uid = eventId;
            editEvent = controller.getEventForEdit(eventId);
            eventTitleText.text = editEvent.summary;
            notesInputText.text = editEvent.description;
            locInputText.text = editEvent.location;
            if(editEvent.allDay) {
                allDayCheck.on = true;
            } else {
                allDayCheck.on = false;
            }

            startDate = editEvent.getStartDateFromKDT();
            endDate = editEvent.getEndDateFromKDT();
            startTime = editEvent.getStartTimeFromKDT();
            endTime = editEvent.getEndTimeFromKDT();

            startDateTxt.text = i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFullShort);
            finishDateTxt.text = i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFullShort);
            startTimeTxt.text = i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort);
            finishTimeTxt.text = i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort);

            allDaySet = allDayCheck.on;
            startDateStr= startDateTxt.text;
            endDateStr = finishDateTxt.text;
            startTimeStr = startTimeTxt.text;
            endTimeStr = finishTimeTxt.text;

            tzCmb.modelVal = editEvent.zoneOffset;
            tzCmb.selectedVal = editEvent.zoneName;

            alarmCmb.selectedVal = utilities.getAlarmString(editEvent.alarmType);
            alarmCmb.modelVal = editEvent.alarmType;

            repeatCmb.selectedIndex = editEvent.repeatType;
            repeatCmb.title = utilities.getRepeatTypeString(editEvent.repeatType);
            repeatEndCmb.selectedIndex = editEvent.repeatEndType;

            if(editEvent.repeatType != UtilMethods.ENoRepeat) {
                if(editEvent.repeatEndType == UtilMethods.EForNTimes) {
                    repeatCountText.text= editEvent.repeatCount.toString();
                }
                else if(editEvent.repeatEndType == UtilMethods.EAfterDate) {
                    endRepeatDayText.text = editEvent.getRepeatEndDateFromKDT(UtilMethods.EDefault);
                }
            }

        }

        function openTimePicker(index,parentVal)
        {
            timePickerLoader.sourceComponent = timePickerComponent;
            timePickerLoader.item.parent = parentVal;
            timePickerLoader.item.fromIndex = index;
            timePickerLoader.item.show();
        }

        function formatInteger(intVal)
        {
            var intValStr="";
            if(intVal<10) {
                intValStr = "0";
            }
            intValStr += intVal.toString();
            return intValStr;
        }

        function setTimeValues(fromIndex,timeVal)
        {
            if(fromIndex==1) {
                startTime = timeVal;
                startTimeTxt.text = i18nHelper.localTime(startTime, Labs.LocaleHelper.TimeFullShort);
            } else if(fromIndex==2) {
                endTime = timeVal;
                finishTimeTxt.text = i18nHelper.localTime(endTime, Labs.LocaleHelper.TimeFullShort);
            }
        }

        function openDatePicker(index,parentVal)
        {
            datePickerLoader.sourceComponent = datePickerComponent;
            datePickerLoader.item.parent = parentVal;
            datePickerLoader.item.fromIndex = index;
            datePickerLoader.item.show();
        }


        function setDateValues(fromIndex,dateVal)
        {
            if(fromIndex == 1) {
                startDate = dateVal;
                startDateTxt.text=i18nHelper.localDate(startDate, Labs.LocaleHelper.DateFullShort);
                console.log("Obtained startDateTxt.text="+startDateTxt.text);
            } else if(fromIndex == 2) {
                endDate = dateVal;
                finishDateTxt.text = i18nHelper.localDate(endDate, Labs.LocaleHelper.DateFullShort);
                console.log("Obtained finishDateTxt.text="+finishDateTxt.text);
            } else if(fromIndex == 3) {
                repeatEndDate = dateVal;
                endRepeatDayText.text = i18nHelper.localDate(repeatEndDate, Labs.LocaleHelper.DateFullShort);
                console.log("Obtained endRepeatDayText.text="+endRepeatDayText.text);
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
                property date dateVal
                property int fromIndex:0

                onDateSelected: {
                    dateVal=datePicker.selectedDate;
                    console.log("Obtained dateVal="+dateVal.toString());
                    setDateValues(fromIndex,dateVal);
                }
            }
        }

        Loader {
            id:timePickerLoader
        }

        Component {
            id:timePickerComponent
            TimePicker {
                id: timePicker
                property int fromIndex:0
                property variant timeVal                
                onAccepted: {
                    timeVal = utilities.createTimeFromVals(hours,minutes);
                    setTimeValues(fromIndex,timeVal);
                    console.log("timeVal changed to: "+timeVal);
                }
                minutesIncrement:5
            }
        }

        CalendarController {
            id: controller
        }

        IncidenceIO {
            id: eventIO
        }

        UtilMethods {
            id:utilities
        }

        Labs.LocaleHelper {
            id:i18nHelper
        }


        Labs.TimezoneListModel {
            id: timezonelist
        }

        Component {
            id: highlighter
            Rectangle {
                color: "darkgray"
            }
        }

        Component {
            id: highlighteroff
            Rectangle {
                color: "transparent"
            }
        }

        Loader {
            id: dateTimePopUpLoader
        }


        Item {
            id: editList
            anchors.fill: parent
            property int innerBoxWidth: width-50
            property bool windowExpanded:false


            MouseArea {
                anchors.fill: parent
                onClicked: {}
            }
            Behavior on opacity {
                PropertyAnimation { duration: 250 }
            }

            //Title Block
            Item {
                id: titleBlock
                width: editList.innerBoxWidth
                height:titleEditArea.height+titleArea.height
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.leftMargin: 25
                Item{
                    id: titleArea
                    width: parent.width
                    anchors.top: parent.top
                    anchors.margins: 5
                    height: (windowType==UtilMethods.EAddEvent)?30:0
                    Text {
                        id: eventTitle
                        text: titleBlockText
                        font.bold: true
                        color:theme_fontColorNormal
                        font.pixelSize: theme_fontPixelSizeLarge
                        width: parent.width
                        anchors.fill: parent
                        elide: Text.ElideRight
                    }
                }
                Item {
                    id:titleEditArea
                    anchors.top: titleArea.bottom
                    anchors.margins: 5
                    width: parent.width
                    height: 30
                    TextEntry {
                        id: eventTitleText
                        defaultText: qsTr("Event title")
                        anchors.fill: parent
                    }
                }

            }//end title item

            //Title divider
            Image {
                id:titleDivBox
                width: parent.width
                anchors.top: titleBlock.bottom
                anchors.left: parent.left
                anchors.topMargin: 30
                source: "image://theme/menu_item_separator"
            } //end of titleDivider


            //Scrollable EditArea
           Flickable {
               id:scrollableEditArea
                flickableDirection: Flickable.VerticalFlick
                width: editList.width
                height: (editList.height-titleBlock.height-50)
                contentWidth: scrollableSection.width
                contentHeight:scrollableSection.height
                anchors.top: titleDivBox.bottom
                anchors.topMargin: 5
                anchors.bottom: buttonDivBox.top
                anchors.left: parent.left
                clip: true
                interactive: false
                property bool flickableExpanded:false

                Item {
                    id: scrollableSection
                    width: editList.width
                    height:(dateTimeBox.height+dateTimeBlock.height+moreBlock.height)
                    anchors.top: parent.top
                    property bool expanded:false

                    Column {
                      id:contents
                      spacing: 10
                      anchors.top: parent.top
                      anchors.bottom: parent.bottom
                      move: Transition {
                               NumberAnimation {
                                   properties: "y"
                                   duration: 250
                                   easing.type: Easing.OutBounce
                               }
                           }
                      add: Transition {
                          NumberAnimation {
                              properties: "opacity"
                              duration: 250
                              easing.type: Easing.OutBounce
                          }
                      }

                      Rectangle{
                          id: dateTimeBox
                          width: editList.width
                          height: 30
                          color: "Gray"
                          z:2

                          Text {
                              id:dateTimeTxt
                              text: qsTr("Date & time")
                              color:theme_fontColorNormal
                              font.pixelSize: theme_fontPixelSizeMedium
                              font.bold: true
                              width: parent.width
                              anchors.left: parent.left
                              anchors.leftMargin: 25
                              anchors.verticalCenter: parent.verticalCenter
                          }

                      }//end of dateTimeBox

                      Item {
                          id:dateTimeBlock
                          width: editList.innerBoxWidth
                          height:(allDayBlock.height+startTimeCmbBlock.height+finishTimeCmbBlock.height+5)
                          anchors.left: parent.left
                          anchors.leftMargin: 25
                          z:2

                          Column {
                              spacing: 3
                              y:0
                              move: Transition {
                                  NumberAnimation { properties: "y"; easing.type:Easing.OutBounce; duration:250 }
                              }

                              add: Transition {
                                  NumberAnimation { properties: "y"; easing.type:Easing.OutQuad; duration:250 }
                              }

                              Item {
                                  id:allDayBlock
                                  width:dateTimeBlock.width
                                  height: 50
                                  property bool allDay:allDayCheck.on

                                  Item {
                                      id: allDayTxtBox
                                      anchors.left:parent.left
                                      width: {
                                          if(parent.width/3<allDayTxt.paintedWidth){
                                              (outer.paintedTextMaxWidth=2*(outer.paintedTextMaxWidth/3)+allDayTxt.paintedWidth+50)
                                          }
                                          return parent.width/3;
                                      }
                                      height: 30
                                      anchors.verticalCenter: parent.verticalCenter
                                      Text {
                                          id:allDayTxt
                                          text: qsTr("All-day")
                                          color:theme_fontColorNormal
                                          font.pixelSize: theme_fontPixelSizeMedium
                                          width:parent.width
                                          anchors.left: parent.left
                                          anchors.leftMargin: 5
                                          anchors.verticalCenter: parent.verticalCenter
                                      }
                                  }

                                  ToggleButton {
                                      id: allDayCheck
                                      anchors.left:  allDayTxtBox.right
                                      anchors.verticalCenter: parent.verticalCenter
                                  }



                                  onAllDayChanged: {
                                        if(allDay) {
                                            allDaySet =  true;
                                            finishTimeBlock.opacity = 0;
                                            finishTimeBox.height = 0;
                                            finishTimeCmbBlock.opacity = 0;
                                            finishTimeCmbBlock.height=0;
                                            startTimeBox.opacity = 0;
                                            startTimeBox.height = 0;
                                        } else {
                                            allDaySet = false;
                                            finishTimeBlock.opacity = 1;
                                            finishTimeBox.height = 30;
                                            finishTimeCmbBlock.opacity = 1;
                                            finishTimeCmbBlock.height=30;
                                            startTimeBox.opacity = 1;
                                            startTimeBox.height = 30;

                                        }
                                  }

                              } //End alldayevent block

                              Row {
                                  Item{
                                      id:startTimeBlock
                                      width: {
                                          if(dateTimeBlock.width/3<startTxt.paintedWidth) {
                                              (outer.paintedTextMaxWidth=2*(outer.paintedTextMaxWidth/3)+startTxt.paintedWidth+50)
                                          }
                                          return dateTimeBlock.width/3;
                                      }
                                      height:50
                                      Text{
                                          id:startTxt
                                          text: qsTr("Start time")
                                          color:theme_fontColorNormal
                                          font.pixelSize: theme_fontPixelSizeMedium
                                          width:parent.width
                                          anchors.left: parent.left
                                          anchors.verticalCenter: parent.verticalCenter                                          
                                      }
                                  }//end starttimeblock

                                  Item {
                                      id:startTimeCmbBlock
                                      width:2*(dateTimeBlock.width/3)
                                      height:50
                                      Rectangle{
                                          id:startDateBox
                                          height:30
                                          width: 2*(parent.width/3)-5
                                          radius:2
                                          border.width: 2
                                          border.color: "Gray"
                                          anchors.left: parent.left
                                          anchors.verticalCenter: parent.verticalCenter
                                          TextInput {
                                                id: startDateTxt
                                                text:""
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10
                                                anchors.verticalCenter: parent.verticalCenter
                                                color:theme_fontColorNormal
                                                font.pixelSize:theme_fontPixelSizeMedium
                                           }
                                          MouseArea {
                                              anchors.fill: parent
                                              onClicked: {
                                                   openDatePicker(1,scene.container);
                                              }
                                              onFocusChanged: {
                                                  startDateStr = startDateTxt.text;
                                                  startDateTxt.cursorVisible=false;
                                              }
                                          }

                                      }

                                      Rectangle {
                                          id:startTimeBox
                                          anchors.right: parent.right
                                          anchors.verticalCenter: parent.verticalCenter
                                          width: parent.width/3
                                          height:30
                                          radius:2
                                          border.width: 2
                                          border.color: "Gray"
                                          TextInput {
                                                id: startTimeTxt
                                                text: ""
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10
                                                anchors.verticalCenter: parent.verticalCenter
                                                color:theme_fontColorNormal
                                                font.pixelSize: theme_fontPixelSizeMedium
                                          }
                                          MouseArea {
                                              anchors.fill: parent
                                              onClicked: {
                                                  openTimePicker(1,scene.container);
                                              }
                                              onFocusChanged: {
                                                  startTimeStr = startTimeTxt.text;
                                                  startTimeTxt.cursorVisible=false;
                                              }
                                          }
                                      }
                                  }//end of startTimeCmbBlock
                              }//startrow

                              Row {
                                  Item{
                                      id:finishTimeBlock
                                      width:{
                                          if(dateTimeBlock.width/3<finishTxt.paintedWidth){
                                              (outer.paintedTextMaxWidth=2*(outer.paintedTextMaxWidth/3)+finishTxt.paintedWidth+50)
                                          }
                                          return dateTimeBlock.width/3;
                                      }
                                      height:30
                                      Text{
                                          id:finishTxt
                                          text: qsTr("End time")
                                          color:theme_fontColorNormal
                                          font.pixelSize: theme_fontPixelSizeMedium
                                          width:parent.width
                                          anchors.left: parent.left
                                          anchors.verticalCenter: parent.verticalCenter
                                      }
                                  }//end finishtimeblock (string val)

                                  Item {
                                      id:finishTimeCmbBlock
                                      width: 2*(dateTimeBlock.width/3)
                                      height:30

                                      Rectangle{
                                          id:finishDateBox
                                          anchors.top: parent.top
                                          anchors.left: parent.left
                                          width: 2*(parent.width/3)-5
                                          height:parent.height
                                          radius:2
                                          border.width: 2
                                          border.color: "Gray"
                                          TextInput {
                                                id: finishDateTxt
                                                text:""
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10
                                                anchors.verticalCenter: parent.verticalCenter
                                                color:theme_fontColorNormal
                                                font.pixelSize: theme_fontPixelSizeMedium
                                           }
                                          MouseArea {
                                              anchors.fill: parent
                                              onClicked: {
                                                   openDatePicker(2,scene.container);
                                              }
                                              onFocusChanged: {
                                                  endDateStr = finishDateTxt.text;
                                                  finishDateTxt.cursorVisible=false;
                                              }
                                          }

                                      }

                                      Rectangle {
                                          id:finishTimeBox
                                          anchors.top: parent.top
                                          anchors.right: parent.right
                                          width: parent.width/3
                                          height:parent.height
                                          radius:2
                                          border.width: 2
                                          border.color: "Gray"
                                          TextInput {
                                                id: finishTimeTxt
                                                text: ""
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10
                                                anchors.verticalCenter: parent.verticalCenter
                                                color:theme_fontColorNormal
                                                font.pixelSize: theme_fontPixelSizeMedium
                                          }
                                          MouseArea {
                                              anchors.fill: parent
                                              onClicked: {
                                                  openTimePicker(2,scene.container);
                                              }
                                              onFocusChanged: {
                                                  endTimeStr = finishTimeTxt.text;
                                                  finishTimeTxt.cursorVisible=false;
                                              }
                                          }
                                      }
                                  }//end of finishTimeCmbBlock

                              }//end finish row

                          }//end of column

                      }//end of datetimeblock


                      Item {
                          id: moreBlock
                          width: editList.width
                          height: 50
                          z:-2

                          Item{
                              id: moreButton
                              height: parent.height
                              width: parent.width
                              anchors.centerIn: parent
                              Image {
                                  id:moreSpacer1
                                  width: parent.width
                                  anchors.top: parent.top
                                  source: "image://theme/menu_item_separator"
                              }
                              Text {
                                  id:moreTxt
                                  text: qsTr("More...")
                                  anchors.fill: parent
                                  horizontalAlignment: Text.AlignHCenter
                                  verticalAlignment: Text.AlignVCenter
                                  color:theme_fontColorHighlight
                                  font.pixelSize: theme_fontPixelSizeLarger
                              }
                              MouseArea {
                                  id:moreMouseArea
                                  anchors.fill:parent
                                  onClicked: {
                                      scrollableEditArea.interactive = true;
                                      moreButton.opacity=0;
                                      moreBlock.height=0;
                                      scrollableSection.expanded=true;
                                      editList.windowExpanded=true;
                                      scrollableEditArea.flickableExpanded=true;
                                  }
                              }
                              Behavior on opacity { NumberAnimation {} }
                              Image {
                                  id:moreSpacer2
                                  width: parent.width
                                  anchors.top: parent.bottom
                                  source: "image://theme/menu_item_separator"
                              }
                          }


                      }//More Button area

                      Item {
                          id: moreDetailsBlock
                          width: editList.width
                          height:moreContents.height
                          opacity: 0
                          z:-2
                          Column {
                              id:moreContents
                              spacing:5
                              y: 0
                              move: Transition {
                                ParallelAnimation {
                                NumberAnimation { properties: "y"; easing.type: Easing.OutQuad; duration:50 }
                                NumberAnimation { properties: "height";duration: 50; easing.type: Easing.OutQuad }
                                NumberAnimation { properties: "opacity";duration: 250; easing.type: Easing.OutQuad }
                                }
                              }
                              add: Transition {
                                  ParallelAnimation {
                                NumberAnimation { properties: "y"; easing.type: Easing.OutQuad; duration:50 }
                                NumberAnimation { properties: "height";duration: 50; easing.type: Easing.OutQuad }
                                NumberAnimation { properties: "opacity";duration: 250; easing.type: Easing.OutQuad }
                                  }
                              }


                              Row {
                                  Item{
                                      id:tzText
                                      width: {
                                          if(dateTimeBlock.width/3<tzTxt.paintedWidth){
                                              (outer.paintedTextMaxWidth=2*(outer.paintedTextMaxWidth/3)+tzTxt.paintedWidth+50)
                                          }
                                          return dateTimeBlock.width/3;
                                      }
                                      height:50
                                      Text{
                                          id:tzTxt
                                          text: qsTr("Time zone")
                                          color:theme_fontColorNormal
                                          font.pixelSize:theme_fontPixelSizeMedium
                                          width:parent.width
                                          anchors.left: parent.left
                                          anchors.leftMargin: 25
                                          anchors.verticalCenter: parent.verticalCenter
                                      }
                                  }//end of tztext block

                                  Item {
                                      id:tzCmbBlock
                                      width: 2*(dateTimeBlock.width/3)
                                      height:50
                                      z:500
                                      DataLoaderCombo {
                                            id: tzCmb
                                            anchors.left: parent.left
                                            anchors.leftMargin: 25
                                            width: parent.width
                                            height:30
                                            type: 1
                                            anchors.verticalCenter: parent.verticalCenter
                                            selectedVal:(windowType==UtilMethods.EAddEvent)?utilities.getLocalTimeZoneName():editEvent.zoneName
                                        }

                                  }//end of tzcmb block

                              }//end timezonerow

                              //Repeat Section
                              Rectangle{
                                  id: repeatTxtBox
                                  width: editList.width
                                  height: 30
                                  color: "Gray"
                                  z:-5
                                  Text {
                                      id:repeatTxt
                                      text: qsTr("Repeat")
                                      color:theme_fontColorNormal
                                      font.pixelSize:theme_fontPixelSizeMedium
                                      font.bold: true
                                      width: parent.width
                                      anchors.left: parent.left
                                      anchors.leftMargin: 25
                                      anchors.verticalCenter: parent.verticalCenter
                                  }

                              }//end of repeatTxtBox

                              Item {
                                  id:repeatCmbBlock
                                  width: editList.innerBoxWidth
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  height:30
                                  property int repeatType:repeatCmb.selectedIndex
                                  z:-5
                                  DropDown {
                                      id: repeatCmb

                                      width: editList.innerBoxWidth
                                      anchors.fill: parent

                                      title: (windowType==UtilMethods.EAddEvent)?qsTr("Never"):utilities.getRepeatTypeString(editEvent.repeatType)
                                      replaceDropDownTitle:true
                                      titleColor: "black"
                                      model: [  qsTr("Never"), qsTr("Every day"), qsTr("Every week") , qsTr("Every 2 weeks"),qsTr("Every 2 weeks"),qsTr("Every month"),qsTr("Every year"),qsTr("Other...")]
                                      payload: [ UtilMethods.ENoRepeat,UtilMethods.ENoRepeat,UtilMethods.EEveryDay,UtilMethods.EEveryWeek,UtilMethods.EEvery2Weeks,UtilMethods.EEveryMonth,UtilMethods.EEveryYear,UtilMethods.EOtherRepeat ]
                                      onTriggered: {
                                          repeatType = payload[index];
                                      }
                                  }

                                  onRepeatTypeChanged: {
                                      if(repeatType != UtilMethods.ENoRepeat) {
                                          repeatEndCmbBlock.opacity=1;
                                          repeatEndCmbBlock.height = 30;
                                      } else {
                                          if(repeatType == UtilMethods.ENoRepeat) {
                                              if(repeatEndCmbBlock.opacity==1) {
                                                  repeatEndCmbBlock.opacity = 0;
                                                  repeatEndCmbBlock.height = 0;
                                              }
                                              if(repeatEndDateBox.opacity == 1) {
                                                  repeatEndDateBox.opacity = 0;
                                                  repeatEndDateBox.height = 0;
                                              }
                                          }
                                      }
                                  }

                              }//end of repeatCmbBlock block


                              Item {
                                  id:repeatEndCmbBlock
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  width: editList.innerBoxWidth
                                  height:0
                                  opacity: 0
                                  z:-5
                                  Row {
                                      spacing: 10
                                      move: Transition {
                                               NumberAnimation { properties: "x"; easing.type:Easing.OutBounce; duration:250 }
                                       }

                                      Item {
                                          id: repeatEndComboBox
                                          width: repeatEndCmbBlock.width
                                          height: repeatEndCmbBlock.height
                                          property int repeatEndType:repeatEndCmb.selectedIndex

                                          DropDown {
                                              id: repeatEndCmb
                                              anchors.top: parent.top
                                              anchors.left: parent.left
                                              width: parent.width
                                              height:30
                                              replaceDropDownTitle:true
                                              titleColor: "black"
                                              model: [  qsTr("Repeats forever"), qsTr("Ends after number of times..."), qsTr("Ends after date...")]
                                              payload: [UtilMethods.EForever,UtilMethods.EForNTimes,UtilMethods.EAfterDate]
                                              onTriggered: {
                                                  repeatEndType = payload[index];
                                              }
                                          }

                                          onRepeatEndTypeChanged: {
                                              if(repeatEndType == UtilMethods.EForNTimes) {
                                                  repeatEndComboBox.width = repeatEndCmbBlock.width -50;
                                                  repeatCountBox.opacity = 1;
                                                  repeatCountBox.height= 30;
                                                  repeatCountBox.width = 30;
                                                  if(repeatEndDateBox.opacity==1) {
                                                      repeatEndDateBox.opacity = 0;
                                                      repeatEndDateBox.height = 0;
                                                  }
                                              } if(repeatEndType == UtilMethods.EAfterDate) {
                                                  repeatEndComboBox.width = repeatEndCmbBlock.width;
                                                  repeatEndDateBox.opacity = 1;
                                                  repeatEndDateBox.height = 30;
                                                  setEndRepeatDateValues();
                                                  if(repeatCountBox.opacity==1) {
                                                      repeatCountBox.opacity = 0;
                                                      repeatCountBox.height = 0;
                                                      repeatCountBox.width = 0;
                                                  }
                                              } else if(repeatEndType == UtilMethods.EForever){
                                                  repeatEndComboBox.width = repeatEndCmbBlock.width;
                                                  repeatEndDateBox.height = 0;
                                                  repeatEndDateBox.opacity = 0;
                                                  repeatCountBox.height = 0;
                                                  repeatCountBox.opacity = 0;
                                              }

                                          }
                                      }//end repeatendcmbbox

                                      Item {
                                          id: repeatCountBox
                                          height: 0
                                          width:0
                                          opacity:0
                                          TextField {
                                              id:repeatCountText
                                              anchors.fill: parent
                                          }
                                      }
                                  }//end row

                              }//repeatEndCmbBlock


                              Item {
                                  id: repeatEndDateBox
                                  width: editList.innerBoxWidth
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  height:0
                                  opacity: 0
                                  z:-5
                                  Row {
                                      spacing: 5
                                      Item {
                                          id: endRepeatDayBox
                                          height: repeatEndDateBox.height
                                          width:2*(repeatEndDateBox.width/3)
                                          TextEntry {
                                                id: endRepeatDayText
                                                text: ""
                                                anchors.fill:parent
                                                readOnly: true
                                                textInput.font.pixelSize:theme_fontPixelSizeMedium
                                          }
                                      }//end repeatendday

                                      Item {
                                          id: endRepeatIconBox
                                          height: repeatEndDateBox.height
                                          width:30
                                          Image {
                                                id: endDatePicker
                                                anchors.fill: parent
                                                source: "image://theme/calendar/icn_monthcalendar_up"
                                          }
                                          MouseArea {
                                              anchors.fill: parent
                                              onClicked: {
                                                   openDatePicker(3,scene.container);
                                              }
                                          }
                                      }//end repeatend icon

                                  }//end of row
                              }//end of end repear date box


                              //Reminders Section
                              Rectangle{
                                  id: alarmTxtBox
                                  width: editList.width
                                  height: 30
                                  color: "Gray"
                                  z:-5
                                  Text {
                                      id:alarmTxt
                                      text: qsTr("Reminders")
                                      color:theme_fontColorNormal
                                      font.pixelSize: theme_fontPixelSizeMedium
                                      font.bold: true
                                      width: parent.width
                                      anchors.left: parent.left
                                      anchors.leftMargin: 25
                                      anchors.verticalCenter: parent.verticalCenter
                                  }

                              }//end of repeatTxtBox


                              Item{
                                  id:alarmCmbBlock
                                  width: editList.innerBoxWidth
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  height:30
                                  z:-5
                                  DropDown {
                                      id: alarmCmb
                                      anchors.top: parent.top
                                      anchors.left: parent.left
                                      width: (parent.width)
                                      height:30
                                      title: (windowType==UtilMethods.EAddEvent)?qsTr("No reminder"):utilities.getAlarmString(editEvent.alarmType)
                                      replaceDropDownTitle:true
                                      titleColor: "black"

                                      model: [  qsTr("No reminder"), qsTr("10 minutes before"), qsTr("15 minutes before"),qsTr("30 minutes before"),qsTr("1 hour before"),qsTr("2 hours before"),qsTr("1 day before"),qsTr("2 days before"),qsTr("1 week before"),qsTr("Other...")]
                                      payload: [UtilMethods.ENoAlarm,UtilMethods.E10MinB4,UtilMethods.E15MinB4,UtilMethods.E30MinB4,UtilMethods.E1HrB4,UtilMethods.E2HrsB4,UtilMethods.E1DayB4,UtilMethods.E2DaysB4,UtilMethods.E1WeekB4,UtilMethods.EOtherAlarm]
                                      onTriggered: {
                                          selectedIndex = payload[index];
                                      }
                                  }

                                  Image {
                                       id: cancelAlarmIcon
                                       source: "image://theme/icn_close_dn"
                                       anchors.right: parent.right
                                       height: 0
                                       width:0
                                       property bool pressed: false
                                       states: [
                                           State {
                                               name: "pressed"
                                               when: cancelAlarmIcon.pressed
                                               PropertyChanges {
                                                   target: cancelAlarmIcon
                                                   source: "image://theme/icn_close_up"
                                               }
                                           }
                                       ]
                                       MouseArea {
                                           anchors.fill: parent
                                           onPressed: cancelAlarmIcon.pressed = true
                                           onReleased: cancelAlarmIcon.pressed = false
                                           onClicked: {

                                           }
                                       }
                                   }
                              }//end of alarmCmbBox

                              //Location Section
                              Rectangle{
                                  id: locTxtBox
                                  width: editList.width
                                  height: 30
                                  anchors.left: parent.left
                                  color: "Gray"
                                  z:-10
                                  Text {
                                      id:locTxt
                                      text: qsTr("Location")
                                      color:theme_fontColorNormal
                                      font.pixelSize: theme_fontPixelSizeMedium
                                      font.bold: true
                                      width: parent.width
                                      anchors.left: parent.left
                                      anchors.leftMargin: 25
                                      anchors.verticalCenter: parent.verticalCenter
                                  }

                              }//end of locTxtBox

                              Item {
                                  id:locInputBlock
                                  width: editList.innerBoxWidth
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  height:100
                                  z:-50
                                  Item {
                                      id: locInnerArea
                                      width:parent.width
                                      height:parent.height
                                      anchors.top: parent.top
                                      clip:true
                                      Item {
                                          id:locInputBox
                                          height: 100
                                          width:editList.innerBoxWidth
                                          TextField {
                                              id: locInputText
                                              text: ""
                                              anchors.fill:parent
                                          }
                                      }


                                  }//end location flickable

                              }//end of locInputBlock

                              //Notes Section
                              Rectangle{
                                  id: notesTxtBox
                                  width: editList.width
                                  height: 30
                                  anchors.left: parent.left
                                  color: "Gray"
                                  z:-2
                                  Text {
                                      id:notesTxt
                                      text: qsTr("Notes")
                                      color:theme_fontColorNormal
                                      font.pixelSize:theme_fontPixelSizeMedium
                                      font.bold: true
                                      width: parent.width
                                      anchors.left: parent.left
                                      anchors.leftMargin: 25
                                      anchors.verticalCenter: parent.verticalCenter
                                  }

                              }//end of notesTxtBox

                              Item {
                                  id:notesBlock
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  width: editList.innerBoxWidth
                                  height:150
                                  z:-2
                                  Item{
                                      id:notesArea
                                      height: 150
                                      width:editList.innerBoxWidth
                                      clip: true
                                      anchors.top: notesBlock.top
                                      Item {
                                          id:notesInputBlock
                                          anchors.fill:parent
                                          width: editList.innerBoxWidth
                                          height:150

                                          TextField {
                                              id: notesInputText
                                              text: ""
                                              anchors.fill:parent
                                          }
                                      }//end of notesInputBlock

                                  }//end of flickable

                              }//end of notesBlock


                              //Delete Event block
                              Item {
                                  id:deleteButtonBox
                                  height:50
                                  width:editList.innerBoxWidth
                                  anchors.left: parent.left
                                  anchors.leftMargin: 25
                                  Button {
                                      id: deleteButton
                                      height:(windowType==UtilMethods.EAddEvent)?0:50
                                      anchors.horizontalCenter: parent.horizontalCenter
                                      text: qsTr("Delete event")
                                      opacity: (windowType==UtilMethods.EAddEvent)?0:1
                                      hasBackground: true
                                      bgSourceUp: "image://theme/btn_grey_up"
                                      bgSourceDn: "image://theme/btn_grey_dn"
                                      onClicked: {
                                          scene.deleteEvent(uid);
                                          outer.close();
                                          outer.visible = false;
                                      }
                                  }

                              }//end of deleteButton

                          }//end of inner column

                          states: [
                              State {
                                  name: "expanded"
                                  PropertyChanges { target: moreDetailsBlock; height:moreContents.height; }
                                  PropertyChanges { target: moreDetailsBlock; visible: true; opacity: 1.0 }
                                  when: (scrollableSection.expanded==true)
                              }
                          ]
                          transitions: [
                              Transition {
                                 ParallelAnimation {
                                      NumberAnimation {
                                          properties: "height"
                                          duration: 50
                                          easing.type: Easing.OutQuad
                                      }
                                      NumberAnimation {
                                          properties: "opacity"
                                          duration: 50
                                          easing.type: Easing.InCubic
                                      }
                                  }
                              }
                          ]


                      }


                    }//end of column

                }//end scrollable edit area
                states: [
                    State {
                        name: "flickableExpanded"
                        PropertyChanges { target: scrollableEditArea; height:editList.height;}
                        when: (scrollableEditArea.flickableExpanded==true)
                    }
                ]
                transitions: [
                    Transition {
                       SequentialAnimation {
                            NumberAnimation {
                                properties: "height"
                                duration: 50
                                easing.type: Easing.OutQuad
                            }

                        }
                    }
                ]
            }//end of flickable


          //Button Div
           Image {
                id:buttonDivBox
                width: parent.width
                anchors.bottom: buttonsArea.top
                anchors.left: parent.left
                anchors.bottomMargin: 5
                source:"image://theme/menu_item_separator"
            }//end button div

            //Save and Cancel buttons
            Item {
                id: buttonsArea
                width: editList.innerBoxWidth
                height: 40
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.leftMargin: 25
                //color:"lightgray"
                Button {
                    id: saveButton
                    height: parent.height
                    //width: (parent.width/3)-10
                    bgSourceUp: "image://theme/btn_blue_up"
                    bgSourceDn: "image://theme/btn_blue_dn"
                    text: qsTr("Save")
                    hasBackground: true
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        if(validateInputs()) {
                            createIOObject();
                            outer.close()
                            outer.visible = false;
                        }
                    }
                }//savebutton

                Button {
                    id: cancelButton
                    height: parent.height
                    //width: (parent.width/3)-10
                    bgSourceUp: "image://theme/btn_grey_up"
                    bgSourceDn: "image://theme/btn_grey_dn"
                    text: qsTr("Cancel")
                    hasBackground: true
                    anchors.right: parent.right
                    anchors.rightMargin:20
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        outer.close()
                        outer.visible = false;
                    }
                }//closebutton

            }//end of buttons area

            states: [
                State {
                    name: "windowExpanded"
                    PropertyChanges { target: container; height:(scene.isLandscapeView())?((scene.height)-100):(2*(scene.width/3)) }
                    PropertyChanges { target: scrollableSection; height:800;}
                    PropertyChanges { target: scrollableEditArea; height:editList.height;}
                    when: (editList.windowExpanded==true)
                }
            ]
            transitions: [
                Transition {
                   SequentialAnimation {
                        NumberAnimation {
                            properties: "height"
                            duration: 500
                            easing.type: Easing.OutQuad
                        }

                    }
                }
            ]

        } //end of rectangle


    } //end of Item

}
