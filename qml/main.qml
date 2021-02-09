import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0 as Folder
import com.natsu.qrcode 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 860
    height: 680
    title: qsTr("Hello World")

    property int numToConverty: 0
    property int numConvertied: 0
    property int numError: 0

    property var codeValues: []

    Excel {
        id: excel

        onImportDataChanged: {
            // importData
            contentView.reloadData(importData)
        }
    }

    toolBar:ToolBar {
              RowLayout {
                  anchors.fill: parent
                  spacing: 10

                  Item { Layout.fillWidth: true }
                  ToolButton {
                      iconName: "clear"
                      iconSource: "../images/clear.png"
                      tooltip: "清除"
                      onClicked: {
                          contentView.clearData()
                      }
                  }
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
                      onClicked: {
                          folderDialog.open()
                      }
                  }
                  Item { Layout.rightMargin: 5 }
              }
          }
    RowLayout {
        anchors.fill: parent
        ContentView {
            id: contentView
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.documents
        nameFilters: [ "表格文件 (*.xls *.xlsx)", "所有文件 (*)" ]
        Component.onCompleted: visible = false
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            excel.importExcel(fileDialog.fileUrl.toString())
        }
        onRejected: {
            console.log("Canceled")

        }
    }

    Timer {
        id: delayTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            codeValues = contentView.importData.filter(function (element, index) {
                return element.checked
            })
            codeValues = codeValues.map(function (oneRow, index, arr) {
                return oneRow.fromCity+"_"+oneRow.fromName+"_"+oneRow.toCity+"_"+oneRow.toName+"_"+oneRow.goodsName
            })

            var savePath = folderDialog.folder.toString().replace("file://", "")
            for(var i = 0; i < codeValues.length; i++) {
                numToConverty ++
              var imgItem = Qt.createQmlObject('import QtQuick 2.0; InfoView {visible: false; codeValue: \"'+codeValues[i]+'\" }', mainWindow)
              imgItem.grabToImage(function (result){
                  var name = new Date().toLocaleString(Qt.locale(), "yyyyMMddHHmmsszzz")
                  if(result.saveToFile(savePath+"/"+name+".png")) {
                      numConvertied ++
                  }else {
                      numError ++
                  }

//                  console.log("ed:"+numConvertied+" selected:"+contentView.selectedRows)
                  if(numConvertied === contentView.selectedRows) {
//                      $message({
//                               "message": "保存成功",
//                                   "type":"success",
//                                   "show":true
//                               })
                      numToConverty = 0
                      numConvertied = 0
                      numError = 0
                      message.text = "保存成功"
                      message.type = "success"
                      message.show = true
                      message.openTimer()

                      console.log("--------------------")
                  }
                  if(numError + numConvertied === contentView.selectedRows) {
                        message.text = "保存完成，失败："+ errorNum
                        message.type = "info"
                      message.show = true
                        message.openTimer()
                        numToConverty = 0
                        numConvertied = 0
                      numError = 0
                        console.log("----------=====----------")
                  }
              })
            }
        }
    }

    MessageBox {
        id: message
        parent: contentView
    }

    Folder.FolderDialog {
        id: folderDialog
        folder: Folder.StandardPaths.writableLocation(Folder.StandardPaths.DocumentsLocation)
        onAccepted: {
            delayTimer.running = true
        }
    }


}
