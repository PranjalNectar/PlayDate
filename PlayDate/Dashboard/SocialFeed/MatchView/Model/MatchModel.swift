//
//  MatchModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import Foundation

struct LikeDislikeMatchModel:  Decodable {
    var status: Int
    var message: String
}

struct MatchResultModel : Codable {
    
    let data : [MatchData]?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([MatchData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}


struct MatchData : Codable,Identifiable {
    
    let id : String?
    let age : Int?
    let fullName : String?
    let gender : String?
    let interested : [String]?
    let interestedList : [InterestedList]?
    let paymentMode : String?
    let phoneNo : String?
    let profilePicPath : String?
    let profileVideoPath : String?
    let restaurants : [String]?
    let restaurantsList : [RestaurantsList]?
    let status : Bool?
    let username : String?
    let chatStatusFrom : [ChatStatusFrom]?
    let chatStatusTo : [ChatStatusTo]?
    var x: Float = 0.0
    var y: Float = 0.0
    var degree: Double? = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case age = "age"
        case fullName = "fullName"
        case gender = "gender"
        case interested = "interested"
        case interestedList = "interestedList"
        case paymentMode = "paymentMode"
        case phoneNo = "phoneNo"
        case profilePicPath = "profilePicPath"
        case profileVideoPath = "profileVideoPath"
        case restaurants = "restaurants"
        case restaurantsList = "restaurantsList"
        case status = "status"
        case username = "username"
        case chatStatusFrom = "chatStatusFrom"
        case chatStatusTo = "chatStatusTo"
        case x = "x"
        case y = "y"
        case degree = "degree"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        interested = try values.decodeIfPresent([String].self, forKey: .interested)
        interestedList = try values.decodeIfPresent([InterestedList].self, forKey: .interestedList)
        paymentMode = try values.decodeIfPresent(String.self, forKey: .paymentMode)
        phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
        profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
        profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
        restaurants = try values.decodeIfPresent([String].self, forKey: .restaurants)
        restaurantsList = try values.decodeIfPresent([RestaurantsList].self, forKey: .restaurantsList)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        chatStatusFrom = try values.decodeIfPresent([ChatStatusFrom].self, forKey: .chatStatusFrom)
        chatStatusTo = try values.decodeIfPresent([ChatStatusTo].self, forKey: .chatStatusTo)
        x = try values.decodeIfPresent(Float.self, forKey: .x) ?? 0.0
        y = try values.decodeIfPresent(Float.self, forKey: .y) ?? 0.0
        degree = try values.decodeIfPresent(Double.self, forKey: .degree)
    }
    
}

import Foundation

struct RestaurantsList : Codable {

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

import Foundation

struct InterestedList : Codable {

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
