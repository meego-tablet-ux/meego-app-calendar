/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1 as Labs

//Model used for this Drop Down is a StringList Model
//Reset the "dataModel" with appropriate values to make this work
Item {
    id:dropDown
    height: 30
    width:200
    z:30
    property int selectedIndex:0
    property string selectedVal
    property int modelVal:0
    property int type
    property bool cmbClosed:false

    //property alias dataListRect: dataListRect
    //Set this property with the appropriate values
    property alias cmbLoader:dataLoader
    signal expandView()
    signal close()

    Component {
        id: highlighter
        Rectangle {
            color: "Gray"
        }
    }

    Component {
        id: highlighteroff
        Rectangle {
            color: "transparent"
        }
    }



    Column {
        spacing: 0
        y:0
        move: Transition {
            NumberAnimation { properties: "y"; easing.type:Easing.OutBounce; duration:100 }
        }

        add: Transition {
            NumberAnimation { properties: "y"; easing.type:Easing.OutQuad }
        }
        Item {
            id: outerBox
            width: dropDown.width
            height: dropDown.height

           Image {
                id: leftIcon
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height
                width:30
                source:"image://themedimage/images/dropdown_white_60px_1"
                property bool pressed: false
                states: [
                    State {
                        name: "pressed"
                        when: leftIcon.pressed
                        PropertyChanges {
                            target: leftIcon
                            source: "image://themedimage/images/dropdown_white_pressed_3"
                        }
                    }
                ]
            }

            Image {
                id: rightIcon
                anchors.top: parent.top
                anchors.right: parent.right
                height: parent.height
                width:30
                source:"image://themedimage/images/dropdown_white_60px_3"
                property bool pressed: false
                states: [
                    State {
                        name: "pressed"
                        when: rightIcon.pressed
                        PropertyChanges {
                            target: rightIcon
                            source: "image://themedimage/images/dropdown_white_pressed_3"
                        }
                    }
                ]
                MouseArea {
                    anchors.fill: parent
                    onPressed: { centerIcon.pressed = true;rightIcon.pressed= true; leftIcon.pressed=true;}
                    onReleased: { centerIcon.pressed = false; rightIcon.pressed=false;leftIcon.pressed=false;}
                    onClicked:  {
                    }
                }

            }



            Image {
                id: centerIcon
                height: parent.height
                source: "image://themedimage/images/dropdown_white_60px_2"
                anchors.top: parent.top
                anchors.left: leftIcon.right
                anchors.right: rightIcon.left
                property bool pressed: false
                states: [
                    State {
                        name: "pressed"
                        when: centerIcon.pressed
                        PropertyChanges {
                            target: centerIcon
                            source: "image://themedimage/images/dropdown_white_pressed_3"
                        }
                    }
                ]

            }

            Text {
                id: inputVal
                text: selectedVal
                anchors.fill: parent
                color:theme_fontColorNormal
                font.pixelSize: theme_fontPixelSizeMedium
                font.bold: false
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    dropDown.cmbClosed=false;
                    if(type == 1) {                        
                        dataLoader.source = "TimeZoneListDelegate.qml";
                    } else if(type == 2) {
                        dataLoader.source = "AlarmListDelegate.qml";
                    } else if(type == 3) {
                        dataLoader.source = "RepeatListDelegate.qml";
                    } else if(type == 4) {
                        dataLoader.source = "RepeatEndListDelegate.qml";
                    }

                    dataLoader.item.width=dropDown.width;
                }
            }


        }//end of dropdown rectangle


        Loader {
           id: dataLoader
        }

        Connections {
            target:  dataLoader.item
            onClose: {
                console.log("Working on close");
                dataLoader.source = "";
                dropDown.cmbClosed = true;
            }
       }

        Connections {
            target: dropDown
            onCmbClosedChanged: {
                if(cmbClosed) {
                    dropDown.close();
                } else {
                    dropDown.expandView();
                }

            }
        }

    }


}
