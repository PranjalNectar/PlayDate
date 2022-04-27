//
//  SocketIOManager.swift
//  PlayDate
//
//  Created by Pranjal on 24/06/21.
//

import Foundation
import SocketIO
import UIKit

class SocketIOManager : ObservableObject {
    
    static let shared = SocketIOManager()
    var socket: SocketIOClient!
    let manager = SocketManager(socketURL: URL(string: "http://139.59.0.106:3000")!, config: [.log(true), .compress])
    
    init() {
        socket = self.manager.defaultSocket
    }
    
    func establishConnection() {
       socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    func SendMessageData(event : String, dic : [String:Any], completionHandler:() -> Void) {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
            //let jsonData = try JSONEncoder().encode(dic)
            let jsonFormate = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            print(jsonFormate)
            socket.emit(event, jsonFormate as! SocketData)
            completionHandler()
        }catch{
            print("error in json")
        }
    }


    func Online_Offline(){
        do{
            let dic1 = OnlineOffline(
                userId: UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                token: UserDefaults.standard.string(forKey: Constants.UserDefaults.token) ?? ""
            )
            print(dic1)
            let jsonData = try JSONEncoder().encode(dic1)
            let apiData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
           // let jsonString = String(data: jsonData, encoding: .utf8)!
            print(apiData)
           // socket.emit(EventName.online.rawValue, with: [jsonString])
            socket.emit(EventName.online.rawValue, apiData as! SocketData)
        }catch{
            print("error in json")
        }
    }
    
    func ChatMessageRead(chatID : String){
        let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                   "chatId": chatID,
        ]
        print(dic)
        do{
            let jsonData = try JSONEncoder().encode(dic)
            let apiData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            print(apiData)
            print(jsonData)
            socket.emit(EventName.chat_message_read.rawValue,apiData as! SocketData)
        }catch{
            print("error in json")
        }
    }
    
    func AddChatRoom(toUserid : String){
        let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                    "token": UserDefaults.standard.string(forKey: Constants.UserDefaults.token) ?? "",
                    "toUserId" : toUserid
        ]
        print(dic)
        do{
            let jsonData = try JSONEncoder().encode(dic)
            let apiData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            print(apiData)
            print(jsonData)
           socket.emit(EventName.chat_room.rawValue,apiData as! SocketData)
        }catch{
            print("error in json")
        }
    }
    
    func HandledEventdate(_ completionHandler: @escaping ( _ event : String, _ Getdata: [Any]) -> Void) {
        
       socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
       
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("disconnetd")
        }
        
        socket.on(clientEvent: .error) {data, ack in
            print("socket error")
        }
        socket.on(clientEvent: .ping) {data, ack in
            print("socket connected")
        }
       
        socket.on(EventName.Data.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.Data.rawValue, data)
        }
        
        socket.on(EventName.online.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.online.rawValue, data)
        }
        
        socket.on(EventName.chat_room.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.chat_room.rawValue, data)
        }
        
        socket.on(EventName.chat_message_room.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.chat_message_room.rawValue, data)
        }
        
        socket.on(EventName.typing.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.typing.rawValue, data)
        }
        
        socket.on(EventName.chat_question_answer.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.chat_question_answer.rawValue, data)
        }
        
        socket.on(EventName.user_status.rawValue) { (data, ack) in
            print("------- receive data -----------")
            print(data)
            completionHandler(EventName.user_status.rawValue, data)
        }
    }
}



struct OnlineOffline : Codable{
    var userId : String
    var token : String
}


enum EventName : String {
    case online
    case chat_room
    case chat_message_room
    case typing
    case chat_question_answer
    case chat_message_read
    case user_status
    case Data
}

