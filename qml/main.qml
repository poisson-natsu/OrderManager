import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    toolBar:ToolBar {
              RowLayout {
                  anchors.fill: parent
                  spacing: 10
                  Item { Layout.fillWidth: true }
                  ToolButton {
                      iconName: "import"
                      iconSource: "../images/import.png"
                      tooltip: "导入"
                      onClicked: {
                        fileDialog.open()
                      }
                  }
                  ToolButton {
                      iconName: "export"
                      iconSource: "../images/export.png"
                      tooltip: "导出"
                  }
                  Item { Layout.rightMargin: 5 }
              }
          }
    RowLayout {
        anchors.fill: parent
//        spacing: 3

//        Rectangle {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            color: "#eee"
//        }
        ContentView {

        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.documents
        nameFilters: [ "表格文件 (*.xls *.xlsx)", "All files (*)" ]
        Component.onCompleted: visible = false
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)

        }
        onRejected: {
            console.log("Canceled")

        }
    }




}
