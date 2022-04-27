//
//  GetChatMessageModel.swift
//  PlayDate
//
//  Created by Pranjal on 29/06/21.
//

import Foundation

struct GetChatMessageModel : Codable {

    let data : [messageData]?
    let message : String?
    let status : Int?
    let promotions : [String]?
    let questions : [Question]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
        case promotions = "promotions"
        case questions = "questions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([messageData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        promotions = try values.decodeIfPresent([String].self, forKey: .promotions)
        questions = try values.decodeIfPresent([Question].self, forKey: .questions)
    }

}



struct messageData : Codable, Identifiable {
    let id = UUID()
    let chatId : String?
    let entryDate : String?
    let message : String?
    let messageId : String?
    let status : Bool?
    let userId : String?
    let userInfo : [messageUserInfo]?
    let lat : String?
    let longField : String?
    let mediaId : String?
    let mediaInfo : [MediaInfo]?
    let messageType : String?
    let questionId : String?

    enum CodingKeys: String, CodingKey {
        case chatId = "chatId"
        case entryDate = "entryDate"
        case message = "message"
        case messageId = "messageId"
        case status = "status"
        case userId = "userId"
        case userInfo = "UserInfo"
        case lat = "lat"
        case longField = "long"
        case mediaId = "mediaId"
        case mediaInfo = "mediaInfo"
        case messageType = "messageType"
        case questionId = "questionId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
        entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        messageId = try values.decodeIfPresent(String.self, forKey: .messageId)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userInfo = try values.decodeIfPresent([messageUserInfo].self, forKey: .userInfo)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        longField = try values.decodeIfPresent(String.self, forKey: .longField)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        mediaInfo = try values.decodeIfPresent([MediaInfo].self, forKey: .mediaInfo)
        messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
        questionId = try values.decodeIfPresent(String.self, forKey: .questionId)
    }

}


struct messageUserInfo : Codable {

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

struct textMessageModel : Codable {
    
    let chatId : String?
    let message : String?
    let typing : Bool?
    let profilePic : String?
    let userId : String?
    let username : String?
    let lat : Double?
    let long : Double?
    let mediaId : String?
    let messageType : String?
    let mediaFullPath : String?
    let mediaType : String?
    let mediaFullPathThumb : String?
    let messageId : String?

    enum CodingKeys: String, CodingKey {
        case chatId = "chatId"
        case message = "message"
        case typing = "typing"
        case profilePic = "profilePic"
        case userId = "userId"
        case username = "username"
        case lat = "lat"
        case long = "long"
        case mediaId = "mediaId"
        case messageType = "messageType"
        case mediaFullPath = "mediaFullPath"
        case mediaType = "mediaType"
        case mediaFullPathThumb = "mediaFullPathThumb"
        case messageId = "messageId"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        typing = try values.decodeIfPresent(Bool.self, forKey: .typing)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        long = try values.decodeIfPresent(Double.self, forKey: .long)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        messageType = try values.decodeIfPresent(String.self, forKey: .messageType)
        mediaFullPath = try values.decodeIfPresent(String.self, forKey: .mediaFullPath)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        mediaFullPathThumb = try values.decodeIfPresent(String.self, forKey: .mediaFullPathThumb)
        messageId = try values.decodeIfPresent(String.self, forKey: .messageId)
    }

}


struct MediaInfo : Codable {
    
    let mediaFullPath : String?
    let mediaId : String?
    let mediaThumbName : String?
    let mediaType : String?
    
    enum CodingKeys: String, CodingKey {
        case mediaFullPath = "mediaFullPath"
        case mediaId = "mediaId"
        case mediaThumbName = "mediaThumbName"
        case mediaType = "mediaType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaFullPath = try values.decodeIfPresent(String.self, forKey: .mediaFullPath)
        mediaId = try values.decodeIfPresent(String.self, forKey: .mediaId)
        mediaThumbName = try values.decodeIfPresent(String.self, forKey: .mediaThumbName)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
    }
    
}


struct Question : Codable {

        let entryDate : String?
        let options : [Option]?
        let question : String?
        let questionId : String?
        let status : String?
        var isShow : Bool? = false

        enum CodingKeys: String, CodingKey {
                case entryDate = "entryDate"
                case options = "options"
                case question = "question"
                case questionId = "questionId"
                case status = "status"
                case isShow = "isShow"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
                options = try values.decodeIfPresent([Option].self, forKey: .options)
                question = try values.decodeIfPresent(String.self, forKey: .question)
                questionId = try values.decodeIfPresent(String.self, forKey: .questionId)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                isShow = try values.decodeIfPresent(Bool.self, forKey: .isShow)
        }

}


public struct Option : Codable, Identifiable {
    
    public var id = UUID()
        let option : String?
        let optionId : String?
        let questionId : String?

        enum CodingKeys: String, CodingKey {
                case option = "option"
                case optionId = "optionId"
                case questionId = "questionId"
        }
    
    public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                option = try values.decodeIfPresent(String.self, forKey: .option)
                optionId = try values.decodeIfPresent(String.self, forKey: .optionId)
                questionId = try values.decodeIfPresent(String.self, forKey: .questionId)
        }

}



struct QuestionAnswerModel : Codable {

        let answerOrder : Int?
        let chatId : String?
        let isRightAnswer : String?
        let optionId : String?
        let points : Int?
        let profilePic : String?
        let questionId : String?
        let userId : String?
        let username : String?

        enum CodingKeys: String, CodingKey {
                case answerOrder = "answerOrder"
                case chatId = "chatId"
                case isRightAnswer = "isRightAnswer"
                case optionId = "optionId"
                case points = "points"
                case profilePic = "profilePic"
                case questionId = "questionId"
                case userId = "userId"
                case username = "username"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                answerOrder = try values.decodeIfPresent(Int.self, forKey: .answerOrder)
                chatId = try values.decodeIfPresent(String.self, forKey: .chatId)
                isRightAnswer = try values.decodeIfPresent(String.self, forKey: .isRightAnswer)
                optionId = try values.decodeIfPresent(String.self, forKey: .optionId)
                points = try values.decodeIfPresent(Int.self, forKey: .points)
                profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
                questionId = try values.decodeIfPresent(String.self, forKey: .questionId)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                username = try values.decodeIfPresent(String.self, forKey: .username)
        }

}


struct AnswerModel : Codable {
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
