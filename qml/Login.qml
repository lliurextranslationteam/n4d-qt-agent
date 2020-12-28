
import Edupals.N4D.Agent 1.0 as N4DAgent

import QtQuick 2.6
import QtQuick.Layouts 1.1 as Layouts
import QtQuick.Controls 2.6 as QQC2
import org.kde.plasma.core 2.0 as PlasmaCore

QQC2.StackView {
    id: root
    width: 400
    height: 200
    
    initialItem: firstPage
    
    property alias server: serverField.text
    property int port: 9800
    property alias user: userField.text
    property alias showServer: rowServer.visible
    
    signal logged(var ticket)
    signal canceled()
    signal failed(int code,string what)
    
    N4DAgent.Proxy {
        id: n4dAgent
    }
    
    Connections {
        target: n4dAgent
        
        function onTicket(code,value) {
            btnLogin.enabled=true;
            if (code==0) {
                console.log("ticket granted!");
                console.log("value:"+value);
                root.push(secondPage);
            }
            else {
                console.log("Error ",code);
                console.log(value);
            }
        }
    }
    
    QQC2.Pane {
        id: firstPage
        width: 400
        height: 200
        
        Column {
            anchors.fill:parent
            
            spacing: units.smallSpacing
            
            QQC2.Label {
                id: labelCustomText
                text: "Put N4D credentials"
            }
            
            Row {
                id: rowServer
                anchors.horizontalCenter:parent.horizontalCenter
                spacing: units.smallSpacing
                visible: false
                
                QQC2.Label {
                    text:"Server"
                    anchors.verticalCenter: serverField.verticalCenter
                }
                
                QQC2.TextField {
                    id: serverField
                    text: "localhost"
                }
            }
            
            Row {
                id: rowUser
                spacing: units.smallSpacing
                
                anchors.right: rowServer.right
                QQC2.Label {
                    text:"User"
                    anchors.verticalCenter: userField.verticalCenter
                }
                
                QQC2.TextField {
                    id: userField
                    text: n4dAgent.userName
                }
            }
            
            Row {
                id:rowPassword
                spacing: units.smallSpacing
                
                anchors.right: rowServer.right
                QQC2.Label {
                    anchors.verticalCenter: passwordField.verticalCenter
                    text:"Password"
                }
                
                QQC2.TextField {
                    id: passwordField
                    echoMode: TextInput.Password
                }
            }
            
            Row {
                id: rowButtons
                topPadding: units.largeSpacing
                anchors.right: parent.right
                spacing: units.smallSpacing
                
                QQC2.Button {
                    id: btnCancel
                    text:"Cancel"
                    
                    onClicked: {
                        canceled();
                    }
                }
                
                QQC2.Button {
                    id: btnLogin
                    text:"Login"
                    
                    onClicked: {
                        
                        n4dAgent.requestTicket(serverField.text,root.port,userField.text,passwordField.text);
                        btnLogin.enabled=false;
                        //root.push(secondPage);
                    }
                }
                
            }
        }
    }
    
    QQC2.Pane {
        id: secondPage
        width: 400
        height: 200
        visible: false
        
        Column {
            anchors.fill:parent
            spacing: units.largeSpacing
            
            QQC2.Label {
                anchors.horizontalCenter:parent.horizontalCenter
                text: "Logged as:"
            }
            QQC2.Label {
                anchors.horizontalCenter:parent.horizontalCenter
                text: userField.text
            }
            
            QQC2.Button {
                anchors.horizontalCenter:parent.horizontalCenter
                
                text: "Back"
                
                onClicked: {
                    root.pop();
                }
            }
        }
    }
}
