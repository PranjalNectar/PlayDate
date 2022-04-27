//
//  SocialFeedModel.swift
//  PlayDate
//
//  Created by Pranjal on 20/05/21.
//

import Foundation

struct SocialFeedModel : Codable {

        let data : [SocialFeedData]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([SocialFeedData].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct SocialFeedData : Codable, Identifiable {
        var id = UUID()
        let comments : Int?
        let commentsList : [CommentsData]?
        let commentStatus : Bool?
        let entryDate : String?
        let galleryArr : [GalleryArr]?
        var isGallerySave : Int?
        var isLike : Int?
        let likeArr : [LikeArr]?
        var likes : Int?
        let location : String?
        let media : [Media]?
        let mediaId : String?
        let notifyStatus : String?
        let postedBy : [PostedBy]?
        let postId : String?
        let postType : String?
        let tag : String?
        let tagFriend : [String]?
        let tagFriends : [TagFriend]?
        let userId : String?
        let colorCode : String?
        let emojiCode : String?

    enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case commentsList = "comments_list"
        case commentStatus = "commentStatus"
        case entryDate = "entryDate"
        case galleryArr = "galleryArr"
        case isGallerySave = "isGallerySave"
        case isLike = "isLike"
        case likeArr = "likeArr"
        case likes = "likes"
        case location = "location"
        case media = "media"
        case mediaId = "mediaId"
        case notifyStatus = "notifyStatus"
        case postedBy = "postedBy"
        case postId = "postId"
        case postType = "postType"
        case tag = "tag"
        case tagFriend = "tagFriend"
        case tagFriends = "tagFriends"
        case userId = "userId"
        case colorCode = "colorCode"
        case emojiCode = "emojiCode"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decodeIfPresent(Int.self, forKey: .comments)
        commentsList = try values.decodeIfPresent([CommentsData].self, forKey: .commentsList)
        commentStatus = try values.decodeIfPresent(Bool.self, forKey: .commentStatus)
        entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
        galleryArr = try values.decodeIfPresent([GalleryArr].self, forKey: .galleryArr)
        isGallerySave = try values.decodeIfPresent(Int.self, forKey: .isGallerySave)
        isLike = try values.decodeIfPresent(Int.self, forKey: .isLike)
        likeArr = try values.decodeIfPresent([LikeArr].self, forKey: .likeArr)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        media = try values.decodeIfPresent([Media].self, forKey: .media)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        notifyStatus = try values.decodeIfPresent(String.self, forKey: .notifyStatus)
        postedBy = try values.decodeIfPresent([PostedBy].self, forKey: .postedBy)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
        postType = try values.decodeIfPresent(String.self, forKey: .postType)
        tag = try values.decodeIfPresent(String.self, forKey: .tag)
        tagFriend = try values.decodeIfPresent([String].self, forKey: .tagFriend)
        tagFriends = try values.decodeIfPresent([TagFriend].self, forKey: .tagFriends)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        colorCode = try values.decodeIfPresent(String.self, forKey: .colorCode)
        emojiCode = try values.decodeIfPresent(String.self, forKey: .emojiCode)
    }
    
}

struct PostedBy : Codable {

        let fullName : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}

struct CommentsData : Codable, Identifiable {
        let id : String?
        let comment : String?
        let commentBy : [CommentBy]?
        let commentId : String?
        let entryDate : String?
        let postId : String?
        let userId : String?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case comment = "comment"
                case commentBy = "commentBy"
                case commentId = "commentId"
                case entryDate = "entryDate"
                case postId = "postId"
                case userId = "userId"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                comment = try values.decodeIfPresent(String.self, forKey: .comment)
                commentBy = try values.decodeIfPresent([CommentBy].self, forKey: .commentBy)
                commentId = try values.decodeIfPresent(String.self, forKey: .commentId)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                postId = try values.decodeIfPresent(String.self, forKey: .postId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
        }
}


struct CommentBy : Codable {

        let id : String?
        let fullName : String?
        let profilePicPath : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case id = "_id"
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}


struct Media : Codable {
    
    let mediaFullPath : String?
    let mediaId : String?
    let mediaType : String?
    let mediaThumbName : String?
    
    enum CodingKeys: String, CodingKey {
        case mediaFullPath = "mediaFullPath"
        case mediaId = "mediaId"
        case mediaType = "mediaType"
        case mediaThumbName = "mediaThumbName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaFullPath = try values.decodeIfPresent(String.self, forKey: .mediaFullPath)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        mediaThumbName = try values.decodeIfPresent(String.self, forKey: .mediaThumbName)
    }
    
}

struct TagFriend : Codable {

        let fullName : String?
        let profilePicPath : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case fullName = "fullName"
                case profilePicPath = "profilePicPath"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
                profilePicPath = try values.decodeIfPresent(String.self, forKey: .profilePicPath)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}

struct LikeArr : Codable {

        let like : Int?

        enum CodingKeys: String, CodingKey {
                case like = "like"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                like = try values.decodeIfPresent(Int.self, forKey: .like)
        }

}

struct GalleryArr : Codable {
        let gallery : Int?
        enum CodingKeys: String, CodingKey {
                case gallery = "gallery"
        }
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                gallery = try values.decodeIfPresent(Int.self, forKey: .gallery)
        }
}


struct PostNotificationOnOfftModel:  Decodable {

    var status: Int
    var message: String
    
   
}

struct BlockUserPosttModel:  Decodable {

    var status: Int
    var message: String
    
   
}

struct DeletePostPosttModel:  Decodable {

    var status: Int
    var message: String
    
   
}
