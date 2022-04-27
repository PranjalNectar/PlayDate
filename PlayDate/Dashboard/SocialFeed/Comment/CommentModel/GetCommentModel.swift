//
//  GetCommentModel.swift
//  PlayDate
//
//  Created by Pranjal on 28/05/21.
//

import Foundation

struct GetCommentModel : Codable {

        let data : [GetCommentPost]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([GetCommentPost].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct GetCommentPost : Codable, Identifiable {
    
        let id = UUID()
        let comments : Comment?
        let entryDate : String?
        let fullName : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?
    
     var commentSelected : Bool? = false

        enum CodingKeys: String, CodingKey {
                case comments = "comments"
                case entryDate = "entryDate"
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
            case commentSelected = "commentSelected"
            
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                comments = try values.decodeIfPresent(Comment.self, forKey: .comments)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
            commentSelected = try values.decodeIfPresent(Bool.self, forKey: .commentSelected)
            
        }

}


struct Comment : Codable {

        let comment : String?
        let commentId : String?
        let entryDate : String?
        let postId : String?

        enum CodingKeys: String, CodingKey {
                case comment = "comment"
                case commentId = "commentId"
                case entryDate = "entryDate"
                case postId = "postId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                comment = try values.decodeIfPresent(String.self, forKey: .comment)
                commentId = try values.decodeIfPresent(String.self, forKey: .commentId)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                postId = try values.decodeIfPresent(String.self, forKey: .postId)
        }

}

struct PostCommentOnOffModel:  Decodable {
    var status: Int
    var message: String
}
