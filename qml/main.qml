import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as HH
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0 as Folder
import com.natsu.qrcode 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 860
    height: 680
    title: qsTr("二维码管理工具")

    property int numConvertied: 0
    property int numError: 0

    property var items: []

    property var codeValues: []

    Excel {
        id: excel

        onImportDataChanged: {
            // importData
            contentView.reloadData(importData)
        }
    }

    header: ToolBar {
        background: Rectangle {
            color: "#ddd"
        }
        height: 60
              RowLayout {
                  anchors.fill: parent
                  spacing: 10
                  Item { Layout.fillWidth: true }
                  HH.ToolButton {
                      iconName: "clear"
                      iconSource: "qrc:/images/clear.png"
                      tooltip: "清除"
                      enabled: !gifLoadingView.visible
                      onClicked: {
                          contentView.clearData()
                      }
                  }
                  HH.ToolButton {
                      iconName: "import"
                      iconSource: "qrc:/images/import.png"
                      tooltip: "导入"
                      enabled: !gifLoadingView.visible
                      onClicked: {
                        fileDialog.open()
                      }
                  }
                  HH.ToolButton {
                      iconName: "export"
                      iconSource: "qrc:/images/export.png"
                      tooltip: "导出"
                      enabled: !gifLoadingView.visible
                      onClicked: {
                          if(contentView.selectedRows === 0) {
                              message.text = "请选择要保存的数据"
                              message.type = "info"
                              message.show = true
                              message.openTimer()
                          }else {
                              folderDialog.open()
                          }

                      }
                  }
                  Item { Layout.rightMargin: 5 }
              }
          }

    ContentView {
        id: contentView
        enabled: !gifLoadingView.visible
    }

    AnimatedImage {
        id: gifLoadingView
        source: "qrc:/images/loading.gif"
        anchors.centerIn: parent
        z: 1000
        visible: false
    }

//    Image {
//        id: loadingView
//        source: "../images/loading.png"
//        anchors.centerIn: parent
//        visible: false
//        z: 100
//        property bool finished: true
//        function startRunning() {
//            animatorController.running = true
//            loadingView.visible = true
//            finished = false
//        }
//        function stopRunning() {
//            animatorController.running = false
//            loadingView.visible = false
//            finished = true
//        }

//        RotationAnimator {
//            id: animatorController
//            target: loadingView;
//            from: 0;
//            to: 360;
//            duration: 1000
//            running: false

//            onRunningChanged: {
//                if(!loadingView.finished) {
//                    running = true
//                }
//            }
//        }
//    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.documents
        nameFilters: [ "表格文件 (*.xlsx)", "所有文件 (*)" ]
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
        id: obtainImageTimer
        interval: 500
        running: false
        repeat: true
        onTriggered: {
            if(numConvertied + numError >= items.length) {
                obtainImageTimer.running = false
                numConvertied = 0
                numError = 0
                return
            }
            obtainImage(items[numConvertied+numError])
        }
    }

    Timer {
        id: delayTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            codeValues = contentView.importData.filter(function (element, index) {
                return element.checked
            })
            codeValues = codeValues.map(function (oneRow, index, arr) {
                return oneRow.businessPark+"_"+oneRow.businessType+"_"+oneRow.category+"_"+oneRow.numbers+"_"+oneRow.driverName+
                        "_"+oneRow.truckNo+"_"+oneRow.outTime+"_"+oneRow.applicant+"_"+oneRow.outDate
            })

            for(var n = 0; n < codeValues.length; n++) {
                var imgItem = Qt.createQmlObject('import QtQuick 2.0; InfoView {visible: false; codeValue: \"'+codeValues[n]+'\" }', mainWindow)
                items.push(imgItem)
            }
            obtainImageTimer.running = true

        }
    }
    function obtainImage(obj) {
        var savePath = folderDialog.folder.toString().replace("file:///", "")
        if (savePath.indexOf(":") !== -1) {
            // windows
        }else {
            // mac
            savePath = "/"+savePath
        }

        obj.grabToImage(function (result){
            var name = new Date().toLocaleString(Qt.locale(), "yyyyMMddHHmmsszzz")
            if(result.saveToFile(savePath+"/"+name+".png")) {
                numConvertied ++
            }else {
                numError ++
            }

            console.log("ed:"+numConvertied+" selected:"+contentView.selectedRows)
            if(numConvertied === contentView.selectedRows) {
//                loadingView.stopRunning()
                gifLoadingView.visible = false
                message.text = "保存成功"
                message.type = "success"
                message.show = true
                message.openTimer()

                console.log("--------------------")
            }
            if(numError + numConvertied === contentView.selectedRows) {
                gifLoadingView.visible = false
                  message.text = "保存完成，失败："+ errorNum
                  message.type = "info"
                message.show = true
                  message.openTimer()
                  console.log("----------=====----------")
            }
        })
    }

    MessageBox {
        id: message
        parent: contentView
    }

    Folder.FolderDialog {
        id: folderDialog
        folder: Folder.StandardPaths.writableLocation(Folder.StandardPaths.DocumentsLocation)
        onAccepted: {
            items = []
            delayTimer.running = true
//            loadingView.startRunning()
            gifLoadingView.visible = true
        }
    }


}
