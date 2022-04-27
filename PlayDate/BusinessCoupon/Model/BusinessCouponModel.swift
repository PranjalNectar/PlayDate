//
//  BusinessCouponModel.swift
//  PlayDate
//
//  Created by Pranjal on 22/07/21.
//

import Foundation


struct BusinessCouponModel : Codable {
    
    let data : [BusinessCoupopnData]?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([BusinessCoupopnData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}


struct BusinessCoupopnData : Codable, Identifiable {

        let id = UUID()
        let awardedBy : String?
        let awardlevelValue : String?
        let couponAmountOf : String?
        let couponId : String?
        let couponImage : String?
        let couponPercentageValue : Int?
        let couponPurchasePoint : Int?
        let couponTitle : String?
        let couponValidTillDate : String?
        let freeItem : String?
        let newPrice : String?
        let status : String?
        let user : [BusinessUser]?
        let userId : String?

        enum CodingKeys: String, CodingKey {
                case awardedBy = "awardedBy"
                case awardlevelValue = "awardlevelValue"
                case couponAmountOf = "couponAmountOf"
                case couponId = "couponId"
                case couponImage = "couponImage"
                case couponPercentageValue = "couponPercentageValue"
                case couponPurchasePoint = "couponPurchasePoint"
                case couponTitle = "couponTitle"
                case couponValidTillDate = "couponValidTillDate"
                case freeItem = "freeItem"
                case newPrice = "newPrice"
                case status = "status"
                case user = "user"
                case userId = "userId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                awardedBy = try values.decodeIfPresent(String.self, forKey: .awardedBy)
                awardlevelValue = try values.decodeIfPresent(String.self, forKey: .awardlevelValue)
                couponAmountOf = try values.decodeIfPresent(String.self, forKey: .couponAmountOf)
                couponId = try values.decodeIfPresent(String.self, forKey: .couponId)
                couponImage = try values.decodeIfPresent(String.self, forKey: .couponImage)
                couponPercentageValue = try values.decodeIfPresent(Int.self, forKey: .couponPercentageValue)
                couponPurchasePoint = try values.decodeIfPresent(Int.self, forKey: .couponPurchasePoint)
                couponTitle = try values.decodeIfPresent(String.self, forKey: .couponTitle)
                couponValidTillDate = try values.decodeIfPresent(String.self, forKey: .couponValidTillDate)
                freeItem = try values.decodeIfPresent(String.self, forKey: .freeItem)
                newPrice = try values.decodeIfPresent(String.self, forKey: .newPrice)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                user = try values.decodeIfPresent([BusinessUser].self, forKey: .user)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
        }

}


struct BusinessUser : Codable {

        let businessImage : String?
        let fullName : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case businessImage = "businessImage"
                case fullName = "fullName"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                businessImage = try values.decodeIfPresent(String.self, forKey: .businessImage)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}
