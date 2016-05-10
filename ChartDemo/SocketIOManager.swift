//
//  SocketIOManager.swift
//  ChartDemo
//
//  Created by 三斗 on 5/9/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
  static let sharedInstance = SocketIOManager()
  var socket:SocketIOClient = SocketIOClient(socketURL: NSURL(string:"http://192.168.100.26:3000")!)
  override init() {
    super.init()
  }
  
  func establishConnect(){
    socket.connect()
  }
  
  func disConnect(){
    socket.disconnect()
  }
  
  func connectToServerWithNickname(nickname:String,handle:([[String:AnyObject]])! -> Void){
    socket.emit("connectUser", nickname)
    socket.on("userList") { (dataArray, ack) -> Void in
      print(dataArray)
      handle((dataArray[0]) as! [[String:AnyObject]])
    }
    //listenForOtherMessages()
  }
  
  func exitToServerWithNickName(nickname: String, completionHandler: () -> Void){
    socket.emit("exitUser", nickname)
    completionHandler()
  }
  
  func sendMessage(message:String,nickname:String){
    socket.emit("chatMessage", nickname, message)
  }
  
  func getChartMessage(handle:[String:AnyObject] -> Void){
    socket.on("newChatMessage") { (data, ack) -> Void in
      if let dictionary = data as? [String]{
        var messageDictonory = [String:String]()
        messageDictonory["nickname"] = dictionary[0]
        messageDictonory["message"] = dictionary[1]
        //messageDictonory["sendtime"] = dictionary[3]
        handle(messageDictonory)
      }
    }
  }
}
