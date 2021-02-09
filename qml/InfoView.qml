import QtQuick 2.0
import QtQuick.Layouts 1.3
//import QtQuick.Controls 1.4
//import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4

Item {
    width: 750/2
    height: 1060/2

    property string codeValue: ""

    function toUtf8(str) {
        var out, i, len, c;
        out = "";
        len = str.length;
        for(i = 0; i < len; i++) {
            c = str.charCodeAt(i);
            if((c >= 0x0001) && (c <= 0x007F)) {
                out += str.charAt(i);
            } else if(c > 0x07FF) {
                out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
                out += String.fromCharCode(0x80 | ((c >> 6) & 0x3F));
                out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
            } else {
                out += String.fromCharCode(0xC0 | ((c >> 6) & 0x1F));
                out += String.fromCharCode(0x80 | ((c >> 0) & 0x3F));
            }
        }
        return out;
    }

    Image {
        id: billView
        anchors.fill: parent
        source: "../images/bill_background.png"

        Column {
            spacing: 20
            anchors.top: parent.top
            anchors.topMargin: 70
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            Rectangle {
                radius: 5
                anchors.left: parent.left
                anchors.leftMargin: 50
                anchors.right: parent.right
                anchors.rightMargin: 50
                height: 60
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF4242" }
                    GradientStop { position: 1.0; color: "#FE5196" }
                }
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 0
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.verticalCenter
                            }

                            text: "北京市"
                            color: "white"
                            font.bold: true
                            font.pointSize: 16
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.verticalCenter
                            }
                            text: "发货人：张三丰"
                            color: "white"
                            font.pointSize: 14
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Image {
                            width: 41
                            height: 5
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -10
                            source: "../images/arrow.png"
                        }
                    }
                    Rectangle {
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.verticalCenter
                            }

                            text: "北京市"
                            color: "white"
                            font.bold: true
                            font.pointSize: 16
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.verticalCenter
                            }
                            text: "收货人：孙国礼"
                            color: "white"
                            font.pointSize: 14
                            horizontalAlignment: Text.AlignHCenter
                        }

                    }
                }

            }
            QRCode {
                id: qrCode
                width: 200
                height: 200
                anchors.left: parent.left
                anchors.leftMargin: (parent.width-qrCode.width)/2+5
                level: "Q"
                value: toUtf8(codeValue)
            }
            Text {
                id: goodsName
                text: "冰箱"
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pointSize: 17
            }
        }
    }
}
