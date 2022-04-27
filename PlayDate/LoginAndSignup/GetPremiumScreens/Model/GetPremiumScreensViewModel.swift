//
//  GetPremiumScreensViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/07/21.
//


import Foundation

struct GetPremiumResultModel : Codable {

        let data : [GetPremiumDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([GetPremiumDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}



struct GetPremiumDataModel : Codable ,Identifiable{
        var id = UUID()
        let name : String?
        let packageDescription : [PackageDescriptionModel]?
        let packageId : String?
        let packageType : String?
        var colors : String?

        enum CodingKeys: String, CodingKey {
                case name = "name"
                case packageDescription = "packageDescription"
                case packageId = "packageId"
                case packageType = "packageType"
                case colors = "colors"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                packageDescription = try values.decodeIfPresent([PackageDescriptionModel].self, forKey: .packageDescription)
                packageId = try values.decodeIfPresent(String.self, forKey: .packageId)
                packageType = try values.decodeIfPresent(String.self, forKey: .packageType)
                colors = try values.decodeIfPresent(String.self, forKey: .colors) ?? ""
        }

}

struct PackageDescriptionModel : Codable ,Identifiable{
       // var id = UUID()
        let v : Int?
        let id : String?
        let packageDescription : String?
        let packageId : String?
        let packageValue : String?

        enum CodingKeys: String, CodingKey {
                case v = "__v"
                case id = "_id"
                case packageDescription = "packageDescription"
                case packageId = "packageId"
                case packageValue = "packageValue"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                v = try values.decodeIfPresent(Int.self, forKey: .v)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                packageDescription = try values.decodeIfPresent(String.self, forKey: .packageDescription)
                packageId = try values.decodeIfPresent(String.self, forKey: .packageId)
                packageValue = try values.decodeIfPresent(String.self, forKey: .packageValue)
        }

}
