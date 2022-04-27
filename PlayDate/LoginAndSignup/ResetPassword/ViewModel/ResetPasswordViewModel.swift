//
//  ResetPasswordViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 11/05/21.
//

import Foundation
import Combine
import SwiftUI
class ResetPasswordViewModel: ObservableObject {
    
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
    @Published var loading = false
 
    func callResetPassApi(phoneNo:String,otp:String,password:String,completion: @escaping(_ result : String?, _ responce : ResetPasswordModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            
            let params = ["phoneNo": phoneNo,"otp":otp,"password": password] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.resetPassword.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(ResetPasswordModel.self, from: apiData )
                        
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
    
    func clearData() {
        
        arr = [String]()
    }
}
