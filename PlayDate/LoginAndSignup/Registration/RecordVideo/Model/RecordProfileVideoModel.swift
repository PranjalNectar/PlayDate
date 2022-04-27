//
//  RecordProfileVideoModel.swift
//  PlayDate
//
//  Created by Pranjal on 31/05/21.
//

import Foundation


struct RecordProfileVideoModel : Codable {
    
    let data : RecordProfileVideoData?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try values.decodeIfPresent(RecordProfileVideoData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
    
}


struct RecordProfileVideoData : Codable {
    
    let profileVideo : String?
    let profileVideoPath : String?
    let profileVideoThumb : String?
    
    enum CodingKeys: String, CodingKey {
        case profileVideo = "profileVideo"
        case profileVideoPath = "profileVideoPath"
        case profileVideoThumb = "profileVideoThumb"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profileVideo = try values.decodeIfPresent(String.self, forKey: .profileVideo)
        profileVideoPath = try values.decodeIfPresent(String.self, forKey: .profileVideoPath)
        profileVideoThumb = try values.decodeIfPresent(String.self, forKey: .profileVideoThumb)
    }
    
}
