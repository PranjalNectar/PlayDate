//
//  NotificationCountModel.swift
//  PlayDate
//
//  Created by Pranjal on 09/07/21.
//

import Foundation


struct NotificationCountModel : Codable {
        let data : [CountData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([CountData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct CountData : Codable {

        let totalUnreadNotification : Int?

        enum CodingKeys: String, CodingKey {
                case totalUnreadNotification = "totalUnreadNotification"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                totalUnreadNotification = try values.decodeIfPresent(Int.self, forKey: .totalUnreadNotification)
        }
}
