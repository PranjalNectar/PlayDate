//
//  LoginModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import Foundation
struct LoginResultModel : Codable {

        let data :  LoginDataModel?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
          
                          //data = try LoginDataModel(from: decoder)//Datum(from: decoder)
            data = try values.decodeIfPresent(LoginDataModel.self, forKey: .data)
              //  data =   try values.decodeIfPresent(LoginDataModel.self, forKey: .data)//LoginDataModel(from: decoder)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


import Foundation

struct LoginDataModel : Codable {

        let age : Int?
        let birthDate : String?
        let email : String?
        let fullName : String?
        let gender : String?
        let id : String?
        let interested : [LoginDataInterested]?
        let interestedIn : String?
        let inviteCode : Int?
        let inviteLink : String?
        let paymentMode : String?
        let personalBio : String?
        let phoneNo : String?
        let profilePic : String?
        let profilePicPath : String?
        let profileVideoPath : String?
        let profileVideoThumb : String?
        let relationship : String?
        let restaurants : [LoginDataRestaurant]?
        let sourceSocialId : String?
        let sourceType : String?
        let status : Bool?
        let token : String?
        let userId : String?
        let username : String?
        let userType : String?
        let businessImage : String?
    
        enum CodingKeys: String, CodingKey {
                case age = "age"
                case birthDate = "birthDate"
                case email = "email"
                case fullName = "fullName"
                case gender = "gender"
                case id = "id"
                case interested = "interested"
                case interestedIn = "interestedIn"
                case inviteCode = "inviteCode"
                case inviteLink = "inviteLink"
                case paymentMode = "paymentMode"
                case personalBio = "personalBio"
                case phoneNo = "phoneNo"
                case profilePic = "profilePic"
                case profilePicPath = "profilePicPath"
                case profileVideoPath = "profileVideoPath"
                case profileVideoThumb = "profileVideoThumb"
                case relationship = "relationship"
                case restaurants = "restaurants"
                case sourceSocialId = "sourceSocialId"
                case sourceType = "sourceType"
                case status = "status"
                case token = "token"
                case userId = "userId"
                case username = "username"
                case userType = "userType"
                case businessImage = "businessImage"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                age = try values.decodeIfPresent(Int.self, forKey: .age)
                birthDate = try values.decodeIfPresent(String.self, forKey: .birthDate)
                email = try values.decodeIfPresent(String.self, forKey: .email)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                gender = try values.decodeIfPresent(String.self, forKey: .gender)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                interested = try values.decodeIfPresent([LoginDataInterested].self, forKey: .interested)
                interestedIn = try values.decodeIfPresent(String.self, forKey: .interestedIn)
                inviteCode = try values.decodeIfPresent(Int.self, forKey: .inviteCode)
                inviteLink = try values.decodeIfPresent(String.self, forKey: .inviteLink)
                paymentMode = try values.decodeIfPresent(String.self, forKey: .paymentMode)
                personalBio = try values.decodeIfPresent(String.self, forKey: .personalBio)
                phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
                profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
                profileVideoThumb = try values.decodeIfPresent(String.self, forKey: .profileVideoThumb)
                relationship = try values.decodeIfPresent(String.self, forKey: .relationship)
                restaurants = try values.decodeIfPresent([LoginDataRestaurant].self, forKey: .restaurants)
                sourceSocialId = try values.decodeIfPresent(String.self, forKey: .sourceSocialId)
                sourceType = try values.decodeIfPresent(String.self, forKey: .sourceType)
                status = try values.decodeIfPresent(Bool.self, forKey: .status)
                token = try values.decodeIfPresent(String.self, forKey: .token)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
                userType = try values.decodeIfPresent(String.self, forKey: .userType)
                businessImage = try values.decodeIfPresent(String.self, forKey: .businessImage)
        }

}

struct LoginDataRestaurant : Codable {

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

struct LoginDataInterested : Codable {

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


struct RegisterErrorModel : Codable{

        let data : [RegisterErrorData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([RegisterErrorData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct RegisterErrorData : Codable {

        let location : String?
        let msg : String?
        let param : String?
        let value : String?

        enum CodingKeys: String, CodingKey {
                case location = "location"
                case msg = "msg"
                case param = "param"
                case value = "value"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                location = try values.decodeIfPresent(String.self, forKey: .location)
                msg = try values.decodeIfPresent(String.self, forKey: .msg)
                param = try values.decodeIfPresent(String.self, forKey: .param)
                value = try values.decodeIfPresent(String.self, forKey: .value)
        }

}

