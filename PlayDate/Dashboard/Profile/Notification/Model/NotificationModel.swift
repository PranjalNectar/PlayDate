//
//  NotificationModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/05/21.
//

import Foundation

struct NotiResultModel : Codable {

        let data : [NotiDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([NotiDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

class NotiDataModel : Codable ,Identifiable {

        let id : String?
        let entityID : String?
        let entryDate : String?
        let friendRequest : [NotiFriendRequest]?
        let notificationId : String?
        let notificationMessage : String?
        let notificationText : String?
        let patternID : String?
        let postInfo : [NotiPostInfo]?
        let readStatus : Bool?
        let relationRequest : [NotiRelationRequest]?
        let status : String?
        let toUserID : String?
        let userID : String?
        let userInformation : [NotiUserInformation]?
        let chatRequest : [ChatRequest]?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case entityID = "entityID"
                case entryDate = "entryDate"
                case friendRequest = "friendRequest"
                case notificationId = "notificationId"
                case notificationMessage = "notificationMessage"
                case notificationText = "notificationText"
                case patternID = "patternID"
                case postInfo = "PostInfo"
                case readStatus = "readStatus"
                case relationRequest = "relationRequest"
                case status = "status"
                case toUserID = "toUserID"
                case userID = "userID"
                case userInformation = "UserInformation"
                case chatRequest = "chatRequest"
        }
    
    required init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                entityID = try values.decodeIfPresent(String.self, forKey: .entityID)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                friendRequest = try values.decodeIfPresent([NotiFriendRequest].self, forKey: .friendRequest)
                notificationId = try values.decodeIfPresent(String.self, forKey: .notificationId)
                notificationMessage = try values.decodeIfPresent(String.self, forKey: .notificationMessage)
                notificationText = try values.decodeIfPresent(String.self, forKey: .notificationText)
                patternID = try values.decodeIfPresent(String.self, forKey: .patternID)
                postInfo = try values.decodeIfPresent([NotiPostInfo].self, forKey: .postInfo)
                readStatus = try values.decodeIfPresent(Bool.self, forKey: .readStatus)
                relationRequest = try values.decodeIfPresent([NotiRelationRequest].self, forKey: .relationRequest)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                toUserID = try values.decodeIfPresent(String.self, forKey: .toUserID)
                userID = try values.decodeIfPresent(String.self, forKey: .userID)
                userInformation = try values.decodeIfPresent([NotiUserInformation].self, forKey: .userInformation)
                chatRequest = try values.decodeIfPresent([ChatRequest].self, forKey: .chatRequest)
        }

}

struct NotiRelationRequest : Codable {

        let id : String?
        let action : String?
        let requestId : String?
        let status : String?
        let toUserId : String?
        let userId : String?
        let userInfo : [UserInfo]?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case action = "action"
                case requestId = "requestId"
                case status = "status"
                case toUserId = "toUserId"
                case userId = "userId"
                case userInfo = "UserInfo"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                action = try values.decodeIfPresent(String.self, forKey: .action)
                requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                userInfo = try values.decodeIfPresent([UserInfo].self, forKey: .userInfo)
        }

}

struct NotiUserInformation : Codable {

        let fullName : String?
        let id : String?
        let profilePicPath : String?
        let profileVideoPath : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case fullName = "fullName"
                case id = "id"
                case profilePicPath = "profilePicPath"
                case profileVideoPath = "profileVideoPath"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}

struct NotiPostInfo : Codable {

        let media : [NotiMedia]?
        let mediaId : String?
        let postId : String?
        let postType : String?

        enum CodingKeys: String, CodingKey {
                case media = "media"
                case mediaId = "mediaId"
                case postId = "postId"
                case postType = "postType"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                media = try values.decodeIfPresent([NotiMedia].self, forKey: .media)
                mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
                postId = try values.decodeIfPresent(String.self, forKey: .postId)
                postType = try values.decodeIfPresent(String.self, forKey: .postType)
        }

}

struct NotiMedia : Codable {

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


struct NotiFriendRequest : Codable,Identifiable {

        let id : String?
        let action : String?
        let requestId : String?
        let status : String?
        let toUserID : String?
        let userID : String?
        let userInfo : [UserInfo]?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case action = "action"
                case requestId = "requestId"
                case status = "status"
                case toUserID = "toUserID"
                case userID = "userID"
                case userInfo = "UserInfo"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                action = try values.decodeIfPresent(String.self, forKey: .action)
                requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                toUserID = try values.decodeIfPresent(String.self, forKey: .toUserID)
                userID = try values.decodeIfPresent(String.self, forKey: .userID)
                userInfo = try values.decodeIfPresent([UserInfo].self, forKey: .userInfo)
        }

}

struct UserInfo : Codable {

        let id : String?
        let profilePicPath : String?
        let profileVideoPath : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case profilePicPath = "profilePicPath"
                case profileVideoPath = "profileVideoPath"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}


struct NotificationUpdatetModel:  Decodable {
    var status: Int
    var message: String
}


struct ChatRequest : Codable {

        let id : String?
        let activeStatus : String?
        let requestId : String?
        let toUserId : String?
        let userId : String?
        let userInfo : [UserInfo]?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case activeStatus = "activeStatus"
                case requestId = "requestId"
                case toUserId = "toUserId"
                case userId = "userId"
                case userInfo = "UserInfo"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                activeStatus = try values.decodeIfPresent(String.self, forKey: .activeStatus)
                requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
                toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                userInfo = try values.decodeIfPresent([UserInfo].self, forKey: .userInfo)
        }

}





