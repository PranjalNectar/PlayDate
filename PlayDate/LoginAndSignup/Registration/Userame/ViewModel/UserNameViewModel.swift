//
//  UserNameViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 14/05/21.
//

import Foundation
import Combine
import SwiftUI
class UserNameViewModel: ObservableObject {
  
    @Published var loading = false
    
    func callUserNameApi(username:String,completion: @escaping(_ result : String?, _ responce : UserNameModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["username": username,
                          "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
            ] as [String : Any]

            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.updateUserName.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(UserNameModel.self, from: apiData )
                        
                        if response.status != 0{
                            completion(strResult.success.rawValue,response, nil)
                        }else{
                            completion(strResult.error.rawValue,response, nil)
                        }
                    } catch (let error){
                        completion(strResult.error.rawValue, nil, error.localizedDescription)
                        print("ERROR:", error)
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
    
}

    
