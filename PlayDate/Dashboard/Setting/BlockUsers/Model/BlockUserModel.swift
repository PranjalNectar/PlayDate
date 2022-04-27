//
//  BlockUserModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//


import Foundation

struct BlockUserListModelClass : Codable {

        let data : [BlockUserDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([BlockUserDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct BlockUserDataModel : Codable ,Identifiable{
        var id = UUID()
        let action : String?
        let fullName : String?
        let profilePicPath : String?
        let toUserId : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case action = "action"
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case toUserId = "toUserId"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                action = try values.decodeIfPresent(String.self, forKey: .action)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}

struct UnBlockUserModel:  Decodable {
    var status: Int
    var message: String
}
