//
//  DateRestaurantModel.swift
//  PlayDate
//
//  Created by Pranjal on 11/06/21.
//

import Foundation

struct DateRestaurantModel : Codable {

        let data : [DateRestaurantData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([DateRestaurantData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct DateRestaurantData : Codable, Identifiable {

        let address : String?
        let closeTime : String?
        let distance : Float?
        let id : String?
        let image : String?
        let lat : String?
        let longField : String?
        let name : String?
        let openTime : String?
        let status : String?

        enum CodingKeys: String, CodingKey {
                case address = "address"
                case closeTime = "closeTime"
                case distance = "distance"
                case id = "id"
                case image = "image"
                case lat = "lat"
                case longField = "long"
                case name = "name"
                case openTime = "openTime"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                address = try values.decodeIfPresent(String.self, forKey: .address)
                closeTime = try values.decodeIfPresent(String.self, forKey: .closeTime)
                distance = try values.decodeIfPresent(Float.self, forKey: .distance)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                image = try values.decodeIfPresent(String.self, forKey: .image)
                lat = try values.decodeIfPresent(String.self, forKey: .lat)
                longField = try values.decodeIfPresent(String.self, forKey: .longField)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                openTime = try values.decodeIfPresent(String.self, forKey: .openTime)
                status = try values.decodeIfPresent(String.self, forKey: .status)
        }

}
