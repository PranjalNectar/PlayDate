//
//  UserNameModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 14/05/21.
//

//Register Model
struct UserNameModel: Decodable {
   
    var status: Int
    var message: String
  
    
    enum CodingKeys: String, CodingKey{
        case status
        case message
       
    }
}
