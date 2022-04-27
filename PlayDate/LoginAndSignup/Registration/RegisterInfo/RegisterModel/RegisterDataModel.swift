//
//  RegisterDataModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 06/05/21.
//


//OTP Model
struct OTPResult: Decodable {
    
    var status: Int
    var message: String
    
    enum CodingKeys: String, CodingKey{
        case status
        case message
    }
}

struct Restaurantlist : Codable {
    
    let id : String?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct Interestedlist : Codable {
    
    let id : String?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}


extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
extension Int {
    var boolValue: Bool {
        return self != 0
    }
}
