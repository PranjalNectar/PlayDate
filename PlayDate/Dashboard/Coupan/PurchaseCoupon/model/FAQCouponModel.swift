//
//  FAQCouponModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 16/06/21.
//


import Foundation

struct FAQResultModel : Codable {

        let data : [FAQDataModel]?
        let message : String?
        let status : Int?

        enum CodingKeys: String, CodingKey {
                case data = "data"
                case message = "message"
                case status = "status"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                data = try values.decodeIfPresent([FAQDataModel].self, forKey: .data)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                status = try values.decodeIfPresent(Int.self, forKey: .status)
        }

}


struct FAQDataModel : Codable ,Identifiable {
        var id = UUID()
        let answer : String?
        let question : String?
        var showAnswer : Bool? = false

        enum CodingKeys: String, CodingKey {
                case answer = "answer"
                case question = "question"
                case showAnswer = "showAnswer"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                answer = try values.decodeIfPresent(String.self, forKey: .answer)
                question = try values.decodeIfPresent(String.self, forKey: .question)
                showAnswer = try values.decodeIfPresent(Bool.self, forKey: .showAnswer)
        }

}
