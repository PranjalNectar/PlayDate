//
//  FriendMatchRelationshipUpdateModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 21/06/21.
//

import Foundation

struct FriendMatchRelationshipUpdateResultModel : Codable {

        let data : [FriendMatchRelationshipUpdateDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([FriendMatchRelationshipUpdateDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct FriendMatchRelationshipUpdateDataModel : Codable {

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
