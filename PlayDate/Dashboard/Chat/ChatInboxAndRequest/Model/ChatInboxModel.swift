//
//  ChatInboxModel.swift
//  PlayDate
//
//  Created by Pranjal on 28/06/21.
//

import Foundation


struct ChatInboxModel : Codable {

        let data : [InboxUserListData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([InboxUserListData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }
}

struct InboxUserListData : Codable, Identifiable {
    
        var id = UUID()
        let chatId : String?
        let chatMessage : [LastChatMessage]?
        let fromUser : [FromUser]?
       // let toUser : [ToUser]?
        let toUserId : String?
        let userId : String?
        let unreadChat : Int?

        enum CodingKeys: String, CodingKey {
                case chatId = "chatId"
                case chatMessage = "chatMessage"
                case fromUser = "fromUser"
                //case toUser = "toUser"
                case toUserId = "toUserId"
                case userId = "userId"
                case unreadChat = "unreadChat"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
                chatMessage = try values.decodeIfPresent([LastChatMessage].self, forKey: .chatMessage)
                fromUser = try values.decodeIfPresent([FromUser].self, forKey: .fromUser)
                //toUser = try values.decodeIfPresent([ToUser].self, forKey: .toUser)
                toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                unreadChat = try values.decodeIfPresent(Int.self, forKey: .unreadChat)
        }

}

struct FromUser : Codable {

        let fullName : String?
        let onlineStatus : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case fullName = "fullName"
                case onlineStatus = "onlineStatus"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                onlineStatus = try values.decodeIfPresent(String.self, forKey: .onlineStatus)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}


struct LastChatMessage : Codable {
    
    
    let id = UUID()
    let chatId : String?
    let entryDate : String?
    let message : String?
    let messageId : String?
    let status : Bool?
    let userId : String?
    let userInfo : [messageUserInfo]?
    let lat : String?
    let longField : String?
    let mediaId : String?
    let mediaInfo : [MediaLastchat]?
    let messageType : String?
    let questionId : String?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chatId"
        case entryDate = "entryDate"
        case message = "message"
        case messageId = "messageId"
        case status = "status"
        case userId = "userId"
        case userInfo = "UserInfo"
        case lat = "lat"
        case longField = "long"
        case mediaId = "mediaId"
        case mediaInfo = "media"
        case messageType = "messageType"
        case questionId = "questionId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
        entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        messageId = try values.decodeIfPresent(String.self, forKey: .messageId)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userInfo = try values.decodeIfPresent([messageUserInfo].self, forKey: .userInfo)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        longField = try values.decodeIfPresent(String.self, forKey: .longField)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        mediaInfo = try values.decodeIfPresent([MediaLastchat].self, forKey: .mediaInfo)
        messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
        questionId = try values.decodeIfPresent(String.self, forKey: .questionId)
    }
    
}


struct MediaLastchat : Codable {

        let mediaFullPath : String?
        let mediaId : String?
        let mediaThumbName : String?
        let mediaType : String?

        enum CodingKeys: String, CodingKey {
                case mediaFullPath = "mediaFullPath"
                case mediaId = "mediaId"
                case mediaThumbName = "mediaThumbName"
                case mediaType = "mediaType"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                mediaFullPath = try values.decodeIfPresent(String.self, forKey: .mediaFullPath)
                mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
                mediaThumbName = try values.decodeIfPresent(String.self, forKey: .mediaThumbName)
                mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        }

}
