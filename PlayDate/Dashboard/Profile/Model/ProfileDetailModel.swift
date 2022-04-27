//
//  ProfileDetailModel.swift
//  PlayDate
//
//  Created by Pranjal on 26/05/21.
//

import Foundation

struct ProfileDetailModel : Codable {

        let data : [ProfileDetailData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([ProfileDetailData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct ProfileDetailData : Codable {

        let id : String?
        let address : String?
        let age : Int?
        let birthDate : String?
        let email : String?
        let fullName : String?
        let gender : String?
        let interested : [Interested]?
        let interestedIn : String?
        let inviteCode : Int?
        let inviteLink : String?
        let onlineStatus : String?
        let paymentMode : String?
        let personalBio : String?
        let phoneNo : String?
        let profilePicPath : String?
        let profileVideoPath : String?
        let restaurants : [Restaurantlist]?
        let status : Bool?
        let totalFriends : Int?
        let totalPosts : Int?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case address = "address"
                case age = "age"
                case birthDate = "birthDate"
                case email = "email"
                case fullName = "fullName"
                case gender = "gender"
                case interested = "interested"
                case interestedIn = "interestedIn"
                case inviteCode = "inviteCode"
                case inviteLink = "inviteLink"
                case onlineStatus = "onlineStatus"
                case paymentMode = "paymentMode"
                case personalBio = "personalBio"
                case phoneNo = "phoneNo"
                case profilePicPath = "profilePicPath"
                case profileVideoPath = "profileVideoPath"
                case restaurants = "restaurants"
                case status = "status"
                case totalFriends = "totalFriends"
                case totalPosts = "totalPosts"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                address = try values.decodeIfPresent(String.self, forKey: .address)
                age = try values.decodeIfPresent(Int.self, forKey: .age)
                birthDate = try values.decodeIfPresent(String.self, forKey: .birthDate)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                gender = try values.decodeIfPresent(String.self, forKey: .gender)
                interested = try values.decodeIfPresent([Interested].self, forKey: .interested)
                interestedIn = try values.decodeIfPresent(String.self, forKey: .interestedIn)
                inviteCode = try values.decodeIfPresent(Int.self, forKey: .inviteCode)
                inviteLink = try values.decodeIfPresent(String.self, forKey: .inviteLink)
                onlineStatus = try values.decodeIfPresent(String.self, forKey: .onlineStatus)
                paymentMode = try values.decodeIfPresent(String.self, forKey: .paymentMode)
                personalBio = try values.decodeIfPresent(String.self, forKey: .personalBio)
                phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
                restaurants = try values.decodeIfPresent([Restaurantlist].self, forKey: .restaurants)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
                totalFriends = try values.decodeIfPresent(Int.self, forKey: .totalFriends)
                totalPosts = try values.decodeIfPresent(Int.self, forKey: .totalPosts)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}

struct Interested : Codable {

        let id : String?
        let name : String?

        enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                name = try values.decodeIfPresent(String.self, forKey: .name)
        }

}
