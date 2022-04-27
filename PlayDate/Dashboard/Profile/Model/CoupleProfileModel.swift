//
//  CoupleProfileModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 11/06/21.
//


import Foundation

struct CoupleProfileResultModel : Codable {

        let data : [CoupleProfileDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([CoupleProfileDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct CoupleProfileDataModel : Codable {

        let action : String?
        let coupleId : String?
        let profile1 : [Profile1]?
        let profile2 : [Profile2]?
        let status : String?
        let bio : String?

        enum CodingKeys: String, CodingKey {
                case action = "action"
                case coupleId = "coupleId"
                case profile1 = "Profile1"
                case profile2 = "Profile2"
                case status = "status"
                case bio = "bio"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                action = try values.decodeIfPresent(String.self, forKey: .action)
                coupleId = try values.decodeIfPresent(String.self, forKey: .coupleId)
                profile1 = try values.decodeIfPresent([Profile1].self, forKey: .profile1)
                profile2 = try values.decodeIfPresent([Profile2].self, forKey: .profile2)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                bio = try values.decodeIfPresent(String.self, forKey: .bio)
        }

}

struct Profile1 : Codable {

        let age : Int?
        let fullName : String?
        let gender : String?
        let personalBio : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case age = "age"
                case fullName = "fullName"
                case gender = "gender"
                case personalBio = "personalBio"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                age = try values.decodeIfPresent(Int.self, forKey: .age)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                gender = try values.decodeIfPresent(String.self, forKey: .gender)
                personalBio = try values.decodeIfPresent(String.self, forKey: .personalBio)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}


struct Profile2 : Codable {

        let age : Int?
        let fullName : String?
        let gender : String?
        let personalBio : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case age = "age"
                case fullName = "fullName"
                case gender = "gender"
                case personalBio = "personalBio"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                age = try values.decodeIfPresent(Int.self, forKey: .age)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                gender = try values.decodeIfPresent(String.self, forKey: .gender)
                personalBio = try values.decodeIfPresent(String.self, forKey: .personalBio)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}
