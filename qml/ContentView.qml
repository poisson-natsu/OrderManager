import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Rectangle {
    z: 10
    id: tableView
    width: parent.width
    height: parent.height

    property bool isAllChecked: false
    property var importData: []

    property int selectedRows: 0

    function clearData() {
        isAllChecked = false
        importData = []
        table.model = importData
        selectedRows = 0
    }

    function reloadData(dataSource) {
        importData = dataSource
        table.model = importData
        table.resizeColumnsToContents()
    }

    anchors {
        top: parent.top
        left: parent.left
    }

    Popup {
        id: popup
        width: infoView.width
        height: infoView.height
        padding: 0
        leftMargin: (parent.width - popup.width)/2
        rightMargin: (parent.width - popup.width)/2
        topMargin: (parent.height - popup.height)/2
        bottomMargin: (parent.height - popup.height)/2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property string codeValue: ""
        InfoView {
            id: infoView
            codeValue: popup.codeValue
            anchors.fill: parent
        }
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

        property int selected: -1

        TableView {
            id: table
            selectionMode: SelectionMode.NoSelection

            onClicked: {
                var beforeChecked = tableView.importData[row].checked
                tableView.importData[row].checked = !beforeChecked
                if(beforeChecked) {
                    selectedRows --
                }else {
                    selectedRows ++
                }

                isAllChecked = tableView.importData.every(function (item, index, array) {
                    return item.checked === true
                })
                table.model = tableView.importData
            }

            anchors {
                fill: parent
            }
            // 去掉边框
            frameVisible: false

            TableViewColumn {
                id: checkColumn
              role: "checked"
              title: "全选"
              width: 100

              delegate: Rectangle {
                  width: parent.width
                  Image {
                      width: 24
                      height: 24
                      anchors.centerIn: parent
                      source: styleData.value ? "../images/checked.png" : "../images/unchecked.png"
                  }
              }
            }
            TableViewColumn {
              role: "businessPark"
              title: "园区"
              width: 80
            }
            TableViewColumn {
              role: "businessType"
              title: "业务类型"
              width: 150
            }
            TableViewColumn {
              role: "category"
              title: "类别"
              width: 80
            }
            TableViewColumn {
              role: "numbers"
              title: "数量"
              width: 50
            }
            TableViewColumn {
              role: "driverName"
              title: "司机姓名"
              width: 80
            }
            TableViewColumn {
              role: "truckNo"
              title: "车牌号"
              width: 80
            }
            TableViewColumn {
              role: "outTime"
              title: "出园申请时间"
              width: 150
            }
            TableViewColumn {
              role: "applicant"
              title: "申请人"
              width: 100
            }
            TableViewColumn {
              role: "outDate"
              title: "二维码有效期（24小时）"
              width: 160
            }

            TableViewColumn {
                role: "qrcode"
                title: "二维码"
                width: 100
                delegate: Rectangle {
                    color: "transparent"
                    Image {
                        width: 24
                        height: 24
                        anchors.centerIn: parent
                        source: "../images/qrcode.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var oneRow = tableView.importData[styleData.row]
                            popup.codeValue = oneRow.businessPark+"_"+oneRow.businessType+"_"+oneRow.category+"_"+
                                    oneRow.numbers+"_"+oneRow.driverName+"_"+oneRow.truckNo+"_"+oneRow.outTime+"_"+
                                    oneRow.applicant+"_"+oneRow.outDate
                            popup.open()
                        }
                    }
                }
            }
            clip: true
            model: tableView.importData

            headerDelegate: Rectangle {
                height: tableControl.headerHeight
                color: "#EFEFEF"
                border.width: 1
                border.color: "#f8f8f8"
                Text {
                    id: headText
                    text: styleData.value ? styleData.value : ""
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    id: allCheckBox
                    width: 24
                    height: 24
                    source: isAllChecked ? "../images/checked.png" : "../images/unchecked.png"
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
                        if (styleData.column !== 0) {
                            return
                        }
                        isAllChecked = !isAllChecked
                        for(var i = 0; i < tableView.importData.length; i++) {
                            tableView.importData[i].checked = isAllChecked
                        }
                        if(isAllChecked) {
                            selectedRows = tableView.importData.length
                        }else {
                            selectedRows = 0
                        }

                        table.model = tableView.importData
                    }
                }
            }
            rowDelegate: Rectangle {
                height: tableControl.rowHeight
            }
            itemDelegate: Rectangle {
                clip: true
                Text {
                    text: {
                        if(typeof styleData.value === "string") {
                            return styleData.value
                        }else {
                            return ""
                        }
                    }
                    anchors.centerIn: parent
                }
            }
        }
    }
}
