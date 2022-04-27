//
//  AddMediaModel.swift
//  PlayDate
//
//  Created by Pranjal on 25/05/21.
//

import Foundation

struct AddMediaModel : Codable {
        let data : AddMedia?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent(AddMedia.self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct AddMedia : Codable {

        let fullPath : String?
        let mediaId : String?
        let mediaName : String?
        let mediaThumbName : String?
        let mediaType : String?
    

        enum CodingKeys: String, CodingKey {
                case fullPath = "fullPath"
                case mediaId = "mediaId"
                case mediaName = "mediaName"
                case mediaThumbName = "mediaThumbName"
                case mediaType = "mediaType"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullPath = try values.decodeIfPresent(String.self, forKey: .fullPath)
                mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
                mediaName = try values.decodeIfPresent(String.self, forKey: .mediaName)
                mediaThumbName = try values.decodeIfPresent(String.self, forKey: .mediaThumbName)
                mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        }

}
