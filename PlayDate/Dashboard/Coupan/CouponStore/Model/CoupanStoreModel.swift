//
//  CoupanStoreModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//


import Foundation

struct CoupanStoreResultModel : Codable {
    
    let data : CoupanStoreAllDataModel?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(CoupanStoreAllDataModel.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}

struct CoupanStoreAllDataModel : Codable {
    
    let account : CoupanStoreAccount?
    let coupondata : [CoupanStoreDataModel]?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case coupondata = "coupondata"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decodeIfPresent(CoupanStoreAccount.self, forKey: .account)
        coupondata = try values.decodeIfPresent([CoupanStoreDataModel].self, forKey: .coupondata)
    }
    
}

struct CoupanStoreDataModel : Codable, Identifiable {

        var id = UUID()
        let awardedBy : String?
        let awardlevelValue : String?
        let couponAmountOf : String?
        let couponCode : String?
        let couponId : String?
        let couponImage : String?
        let couponPercentageValue : Int?
        let couponPurchasePoint : Int?
        let couponTitle : String?
        let couponValidTillDate : String?
        let freeItem : String?
        let newPrice : String?
        let purchased : [CoupanStorePurchased]?
        let restaurants : [CoupanStorRestaurant]?
        let status : String?
        let user : [CouponUser]?
        let userId : String?

        enum CodingKeys: String, CodingKey {
                case awardedBy = "awardedBy"
                case awardlevelValue = "awardlevelValue"
                case couponAmountOf = "couponAmountOf"
                case couponCode = "couponCode"
                case couponId = "couponId"
                case couponImage = "couponImage"
                case couponPercentageValue = "couponPercentageValue"
                case couponPurchasePoint = "couponPurchasePoint"
                case couponTitle = "couponTitle"
                case couponValidTillDate = "couponValidTillDate"
                case freeItem = "freeItem"
                case newPrice = "newPrice"
                case purchased = "purchased"
                case restaurants = "restaurants"
                case status = "status"
                case user = "user"
                case userId = "userId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                awardedBy = try values.decodeIfPresent(String.self, forKey: .awardedBy)
                awardlevelValue = try values.decodeIfPresent(String.self, forKey: .awardlevelValue)
                couponAmountOf = try values.decodeIfPresent(String.self, forKey: .couponAmountOf)
                couponCode = try values.decodeIfPresent(String.self, forKey: .couponCode)
                couponId = try values.decodeIfPresent(String.self, forKey: .couponId)
                couponImage = try values.decodeIfPresent(String.self, forKey: .couponImage)
                couponPercentageValue = try values.decodeIfPresent(Int.self, forKey: .couponPercentageValue)
                couponPurchasePoint = try values.decodeIfPresent(Int.self, forKey: .couponPurchasePoint)
                couponTitle = try values.decodeIfPresent(String.self, forKey: .couponTitle)
                couponValidTillDate = try values.decodeIfPresent(String.self, forKey: .couponValidTillDate)
                freeItem = try values.decodeIfPresent(String.self, forKey: .freeItem)
                newPrice = try values.decodeIfPresent(String.self, forKey: .newPrice)
                purchased = try values.decodeIfPresent([CoupanStorePurchased].self, forKey: .purchased)
                restaurants = try values.decodeIfPresent([CoupanStorRestaurant].self, forKey: .restaurants)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                user = try values.decodeIfPresent([CouponUser].self, forKey: .user)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
        }

}

struct CouponUser : Codable {

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

struct CoupanStorRestaurant : Codable {
    
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

struct CoupanStorePurchased : Codable {
    
    let couponId : String?
    let purchaseId : String?
    let status : String?
    let userId : String?
    
    enum CodingKeys: String, CodingKey {
        case couponId = "couponId"
        case purchaseId = "purchaseId"
        case status = "status"
        case userId = "userId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        couponId = try values.decodeIfPresent(String.self, forKey: .couponId)
        purchaseId = try values.decodeIfPresent(String.self, forKey: .purchaseId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
    }
    
}


struct CoupanStoreAccount : Codable {
    
    let id : String?
    let currentPoints : Int?
    let totalPoints : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case currentPoints = "currentPoints"
        case totalPoints = "totalPoints"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        currentPoints = try values.decodeIfPresent(Int.self, forKey: .currentPoints)
        totalPoints = try values.decodeIfPresent(Int.self, forKey: .totalPoints)
    }
    
}
