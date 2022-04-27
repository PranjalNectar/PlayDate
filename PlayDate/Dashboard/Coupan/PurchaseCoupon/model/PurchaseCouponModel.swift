//
//  PurchaseCouponModel.swift
//  PlayDate
//
//  Created by Pranjal on 15/06/21.
//

import Foundation

struct PurchaseCouponModel : Codable {

        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}
