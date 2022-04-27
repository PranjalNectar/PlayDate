//
//  InterestModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/05/21.
//



import Foundation

struct MyInterest: Decodable,Identifiable {
  
    let id: String
    let name: String
}
struct MyInterestResultModel:  Decodable {

    var status: Int
    var message: String
    var data: [MyInterest]

    enum CodingKeys: String, CodingKey{
        case status
        case message
        case data
    }
}
