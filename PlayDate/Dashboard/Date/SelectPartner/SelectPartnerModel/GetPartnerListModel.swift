//
//  GetPartnerListModel.swift
//  PlayDate
//
//  Created by Pranjal on 11/06/21.
//

import Foundation

struct GetAllPertnerListModel : Codable {

        let data : [PartnerData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([PartnerData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct PartnerData : Codable, Identifiable {

        let id : String?
        let currentPoints : Int?
        let fullName : String?
        let phoneNo : String?
        let profilePicPath : String?
        let profileVideoPath : String?
        let status : Bool?
        let totalPoints : Int?
        let username : String?
        var show = false

        enum CodingKeys: String, CodingKey {
                case currentPoints = "currentPoints"
                case fullName = "fullName"
                case id = "id"
                case phoneNo = "phoneNo"
                case profilePicPath = "profilePicPath"
                case profileVideoPath = "profileVideoPath"
                case status = "status"
                case totalPoints = "totalPoints"
                case username = "username"
                case show = "show"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                currentPoints = try values.decodeIfPresent(Int.self, forKey: .currentPoints)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
                totalPoints = try values.decodeIfPresent(Int.self, forKey: .totalPoints)
                username = try values.decodeIfPresent(String.self, forKey: .username)
                show = try values.decodeIfPresent(Bool.self, forKey: .show) ?? false
        }

}

