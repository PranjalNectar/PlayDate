//
//  SocialSuggestionsHorizontalModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import Foundation

struct SocialSuggestionResultModel : Codable {
    
    let data : [SocialSuggestionDataModel]?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([SocialSuggestionDataModel].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}


struct SocialSuggestionDataModel : Codable,Identifiable {
    
    let id : String?
    let friendRequest : [FriendRequest]?
    let chatStatusFrom : [ChatStatusFrom]?
    let chatStatusTo : [ChatStatusTo]?
    let fullName : String?
    let phoneNo : String?
    let profilePicPath : String?
    let profileVideoPath : String?
    let status : Bool?
    let username : String?
    var show = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case friendRequest = "friendRequest"
        case chatStatusFrom = "chatStatusFrom"
        case chatStatusTo = "chatStatusTo"
        case fullName = "fullName"
        case phoneNo = "phoneNo"
        case profilePicPath = "profilePicPath"
        case profileVideoPath = "profileVideoPath"
        case status = "status"
        case username = "username"
        case show = "show"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        friendRequest = try values.decodeIfPresent([FriendRequest].self, forKey: .friendRequest)
        chatStatusFrom = try values.decodeIfPresent([ChatStatusFrom].self, forKey: .chatStatusFrom)
        chatStatusTo = try values.decodeIfPresent([ChatStatusTo].self, forKey: .chatStatusTo)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
        profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
        profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        show = try values.decodeIfPresent(Bool.self, forKey: .show) ?? false
    }
    
}
struct FriendRequest : Codable {
    
    let id : String?
    let requestId : String?
    let status : String?
    let userID : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case requestId = "requestId"
        case status = "status"
        case userID = "userID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        userID = try values.decodeIfPresent(String.self, forKey: .userID)
    }
    
}

struct ChatStatusFrom : Codable {
    
    let activeStatus : String?
    let userId : String?
    let toUserId : String?
    let chatId : String?
    
    enum CodingKeys: String, CodingKey {
        case activeStatus = "activeStatus"
        case userId = "userId"
        case toUserId = "toUserId"
        case chatId = "chatId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activeStatus = try values.decodeIfPresent(String.self, forKey: .activeStatus)
        toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
        chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
    }
    
}

struct ChatStatusTo : Codable {
    
    let activeStatus : String?
    let userId : String?
    let toUserId : String?
    let chatId : String?
    
    enum CodingKeys: String, CodingKey {
        case activeStatus = "activeStatus"
        case userId = "userId"
        case toUserId = "toUserId"
        case chatId = "chatId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activeStatus = try values.decodeIfPresent(String.self, forKey: .activeStatus)
        toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
        chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
    }
    
}
