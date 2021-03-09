import QtQuick 2.0
import QtQuick.Layouts 1.3

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

    function getDataArray(index) {
        var splitData = codeValue.split("_")
        if (splitData.length > index) {
            return splitData[index]
        }else {
            return "--"
        }
    }

    Image {
        id: billView
        anchors.fill: parent
        source: "../images/bill_background.png"

        Column {
            spacing: 20
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            QRCode {
                id: qrCode
                width: 228
                height: 228
                anchors.left: parent.left
                anchors.leftMargin: (parent.width-qrCode.width)/2
                level: "Q"
                value: toUtf8(codeValue)
            }
            Text {
                id: goodsName
                text: "姓名：" + getDataArray(7) + " 车牌号：" + getDataArray(5)
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pointSize: 17
            }
        }
    }
}
