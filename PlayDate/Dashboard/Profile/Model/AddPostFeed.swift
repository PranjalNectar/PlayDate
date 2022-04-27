//
//  AddPostFeed.swift
//  PlayDate
//
//  Created by Pranjal on 28/05/21.
//

import Foundation


struct AddPostFeedModel : Codable {

        let data : AddPostData?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent(AddPostData.self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct AddPostData : Codable {

        let location : String?
        let mediaId : String?
        let postType : String?
        let tag : String?
        let tagFriend : [String]?
        let userId : String?

        enum CodingKeys: String, CodingKey {
                case location = "location"
                case mediaId = "mediaId"
                case postType = "postType"
                case tag = "tag"
                case tagFriend = "tagFriend"
                case userId = "userId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                location = try values.decodeIfPresent(String.self, forKey: .location)
                mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
                postType = try values.decodeIfPresent(String.self, forKey: .postType)
                tag = try values.decodeIfPresent(String.self, forKey: .tag)
                tagFriend = try values.decodeIfPresent([String].self, forKey: .tagFriend)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
        }

}
