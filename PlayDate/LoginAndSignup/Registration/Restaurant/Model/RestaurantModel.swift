//
//  RestaurantModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/05/21.
//


//Restaurant Model
import Foundation

struct MyRestaurantDataModel: Decodable,Identifiable {
  
    let id: String
    let image: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case businessImage = "businessImage"
        case fullName = "fullName"
        case isProfile = "isProfile"
        case phoneNo = "phoneNo"
        case profilePicPath = "profilePicPath"
        case profileVideoPath = "profileVideoPath"
        case status = "status"
        case userId = "userId"
        case username = "username"
        case userType = "userType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .businessImage) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .username) ?? ""
//                   fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
//                   isProfile = try values.decodeIfPresent(String.self, forKey: .isProfile)
//                   phoneNo = try values.decodeIfPresent(String.self, forKey: .phoneNo)
//                   profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
//                   profileVideoPath = try values.decodeIfPresent(AnyObject.self, forKey: .profileVideoPath)
//                   status = try values.decodeIfPresent(Bool.self, forKey: .status)
//                   userId = try values.decodeIfPresent(String.self, forKey: .userId)
//                   userType = try values.decodeIfPresent(String.self, forKey: .userType)
           }
   
}
struct MyRestaurantResultModel:  Decodable {

    var status: Int
    var message: String
    var data: [MyRestaurantDataModel]

    enum CodingKeys: String, CodingKey{
        case status
        case message
        case data
    }
}
