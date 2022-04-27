//
//  AcceptDateListModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/06/21.
//


import Foundation

struct AcceptDateResultListModel : Codable {

        let data : [AcceptDateListDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([AcceptDateListDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct AcceptDateListDataModel : Codable ,Identifiable{
        var id = UUID()
        let action : String?
        let entryDate : String?
        let fullName : String?
        let profilePicPath : String?
        let requestId : String?
        let status : String?
        let toUserId : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case action = "action"
                case entryDate = "entryDate"
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case requestId = "requestId"
                case status = "status"
                case toUserId = "toUserId"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                action = try values.decodeIfPresent(String.self, forKey: .action)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                toUserId = try values.decodeIfPresent(String.self, forKey: .toUserId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}
