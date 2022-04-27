//
//  ChangePasswordViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 31/05/21.
//

//

import Foundation
import Combine
import SwiftUI
class ChangePasswordViewModel: ObservableObject {

    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
    @Published var loading = false
    //MARK:- Validation Functions
    

    func callChangePasswordApi(oldPassword:String,newPassword:String, completion: @escaping(_ result : String?, _ responce : ChangePasswordModel?, _ error : String?) -> ()) {
        self.loading = true
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "oldPassword": oldPassword,
                "newPassword" : newPassword
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.change_password.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(ChangePasswordModel.self, from: apiData )
                            // print("JSON", result.data.fullName)
                            print(result)
                            if response.status != 0{
                                completion(strResult.success.rawValue,response, nil)
                            }else{
                                completion(strResult.error.rawValue,response, nil)
                            }
                        } catch (let error){
                            completion(strResult.error.rawValue, nil, error.localizedDescription)
                            print("ERROR:", error)
                        }
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
  
    func clearData() {
        arr = [String]()
    }
}
