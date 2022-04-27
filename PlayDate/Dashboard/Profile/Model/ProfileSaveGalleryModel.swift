//
//  ProfileSaveGalleryModel.swift
//  PlayDate
//
//  Created by Pranjal on 26/05/21.
//

import Foundation

struct ProfileSaveGalleryModel : Codable {

        let data : [ProfileSaveGalleryData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([ProfileSaveGalleryData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}

struct ProfileSaveGalleryData : Codable, Identifiable {

        let id : String?
        let galleryType : String?
        let mediaFullPath : String?
        let mediaThumbName : String?
        let mediaType : String?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case galleryType = "galleryType"
                case mediaFullPath = "mediaFullPath"
                case mediaThumbName = "mediaThumbName"
                case mediaType = "mediaType"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                galleryType = try values.decodeIfPresent(String.self, forKey: .galleryType)
                mediaFullPath = try values.decodeIfPresent(String.self, forKey: .mediaFullPath)
                mediaThumbName = try values.decodeIfPresent(String.self, forKey: .mediaThumbName)
                mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        }
}

