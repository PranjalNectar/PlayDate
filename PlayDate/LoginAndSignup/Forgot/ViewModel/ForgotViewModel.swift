//
//  ForgotViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 11/05/21.
//

import Foundation
import Combine
import SwiftUI
class ForgotViewModel: ObservableObject {
    
    @Published var phoneNo = ""
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
    @Published var loading = false
    //MARK:- Validation Functions
    
    func callValidations() -> [String]{
        isValidPhone()
        return arr
    }
    
    func isValidPhone(){
        //  keyward = String(keyward.prefix(10))
        phoneNo = phoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if phoneNo.count == 0 {
            arr.append(state.phoneNumber)
            
        }else {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{7,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            let valid = phoneTest.evaluate(with: phoneNo)
            if !valid {
                arr.append(state.vPhoneNumber)
            }
        }
    }

    func callForgotApi(completion: @escaping(_ result : String?, _ responce : ForgotModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["phoneNo": phoneNo] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.forgotPassword.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(ForgotModel.self, from: apiData )
                        
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
