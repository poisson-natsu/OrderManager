import QtQuick 2.0

Item {
    id: messageBox
    width: 200
    height: 50
    anchors {
        centerIn: parent
    }
    //提示框内容
    property alias text: msg.text
    property bool show: false
    property var type: "info"
    visible: show
    //执行定时器
    function openTimer() {
        timerId.start()
//        opacity = 0
    }
//    Behavior on opacity {
//        SmoothedAnimation {
//            duration: 2000
//            velocity: 0.1
//        }
//    }
    Timer {
        id: timerId
        interval: 2000
        repeat: false
        onTriggered: {
            show = false
//            opacity = 1
        }
    }

    Rectangle {
        id: msgBox
        clip: true
        anchors.fill: parent
         color:  type=== "info" ? "#fdf6ec" : type=== "success" ? "#f0f9eb" : "#fef0f0"
        border.color:type=== "info" ? "#faecd8" : type=== "success" ? "#e1f3d8" : "#fde2e2"
        radius: 5
        Image {
            id: img
            source: type
                    === "info" ? "qrc:/images/remind.png" : type
                                 === "success" ? "qrc:/images/true.png" : "qrc:/images/error.png"
            width: 24
            height: 24
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 15
            }
        }
        Text {
            id: msg
            color: type=== "info" ? "#e6a23c" : type=== "success" ? "#67c23a" : "#f56c6c"
            font.pixelSize: 16
            anchors {
                verticalCenter: img.verticalCenter
                left: img.right
                leftMargin: 10
            }
        }
    }
}
