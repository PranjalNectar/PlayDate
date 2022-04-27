//
//  FriendListModel.swift
//  PlayDate
//
//  Created by Pranjal on 21/05/21.
//

import Foundation


struct FriendListModel : Codable {

        let data : [FriendData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([FriendData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct FriendData : Codable, Identifiable {
        var id = UUID()
        let fullName : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?
        var isSelected : Bool = false
        let friendId : String?
    

        enum CodingKeys: String, CodingKey {
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
                case isSelected = "isSelected"
                case friendId = "friendId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
                isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
                friendId = try values.decodeIfPresent(String.self, forKey: .friendId)
        }

}
