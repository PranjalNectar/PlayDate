//
//  OTPViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 08/05/21.
//


import Foundation
import Combine
import SwiftUI
class OTPViewModel: ObservableObject {
    @Published var phoneNo = ""
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
  
    //MARK:- API

    @Published var loading = false
    
    func callOTPApi(phoneNo:String,otp:String,completion: @escaping(_ result : String?, _ responce : OTPResult?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["phoneNo": phoneNo,
                          "otp": otp
            ] as [String : Any]

            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.otp.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(OTPResult.self, from: apiData )
                        
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
  
    func callResendOTPApi(phoneNo:String,completion: @escaping(_ result : String?, _ responce : OTPResult?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["phoneNo": phoneNo
            ] as [String : Any]

            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.resendOTP.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(OTPResult.self, from: apiData )
                        
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
