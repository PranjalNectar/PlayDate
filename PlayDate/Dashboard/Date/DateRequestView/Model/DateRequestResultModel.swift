//
//  DateRequestResultModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 23/06/21.
//



import Foundation

struct DateRequestResultModel : Codable {

        let data : DateRequestDataModel?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
            data = try values.decodeIfPresent(DateRequestDataModel.self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct DateRequestDataModel : Codable {

        let requestId : String?

        enum CodingKeys: String, CodingKey {
                case requestId = "requestId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        }

}
