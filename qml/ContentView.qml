import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    z: 10
    id: tableView
    width: parent.width
    height: parent.height

    property bool isAllChecked: false

    anchors {
        top: parent.top
//        topMargin: 88
        left: parent.left
//        leftMargin: 47
    }

    Item {
        id: tableControl
        implicitHeight: parent.height
        implicitWidth: parent.width

        property int headerHeight: 50
        property int rowHeight: 50
        property int tableLeft: 100

        property color scrollBarColor: "#E5E5E5"
        property int scrollBarWidth: 7

        property variant columnWidthArr: [(tableControl.width - tableLeft) /6, (tableControl.width - tableLeft) /6,(tableControl.width - tableLeft) /6,(tableControl.width - tableLeft) /6,(tableControl.width - tableLeft) /6,(tableControl.width - tableLeft) /6]
        property var horHeader: ["发货城市","发货人","收货城市","收货人","货物名称","二维码"]
        property int selected: -1
        property var datas: [{
                "checked": false,
                "fromCity": "from",
                "fromName": "张三",
                "toCity": "to",
                "toName": "里斯",
                "goodsName": "金子",
                "qrcode": "fff"
            },{
                "checked": false,
                "fromCity": "from",
                "fromName": "张三",
                "toCity": "to",
                "toName": "里斯",
                "goodsName": "金子",
                "qrcode": "fff"
            }]

        TableView {
            id: table

            onClicked: {
                print("clicked row " + row)
            }

            anchors {
                fill: parent
//                topMargin: control.rowHeight
//                leftMargin: control.tableLeft
            }
            frameVisible: false

            TableViewColumn {
              role: "checked"
              title: "全选"
              width: 100

              delegate: Rectangle {
                  width: parent.width
                  CheckBox {
                    anchors.verticalCenter: parent.verticalCenter
                  }
              }
            }
            TableViewColumn {
              role: "fromCity"
              title: "发货城市"
              width: 100
            }

            TableViewColumn {
                role: "fromName"
                title: "发货人"
                width: 100
            }
            TableViewColumn {
                role: "toCity"
                title: "收货城市"
                width: 100
            }
            TableViewColumn {
                role: "toName"
                title: "收货人"
                width: 100
            }
            TableViewColumn {
                role: "goodsName"
                title: "货物名称"
                width: 100
            }
            TableViewColumn {
                role: "qrcode"
                title: "二维码"
                width: 100
            }
            clip: true
            model: tableControl.datas

            headerDelegate: Rectangle {
                height: tableControl.headerHeight
                color: "#EFEFEF"
                Text {
                    id: headText
                    text: styleData.value
                    anchors.verticalCenter: parent.verticalCenter
                }

                CheckBox {
                    id: allCheckBox
                    checked: isAllChecked
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: headText.right
                        leftMargin: 10
                    }
                    visible: styleData.column === 0
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        if (styleData.column > 0) {
                            return
                        }
                        isAllChecked = !isAllChecked
                    }
                }
            }
        }
    }
}
