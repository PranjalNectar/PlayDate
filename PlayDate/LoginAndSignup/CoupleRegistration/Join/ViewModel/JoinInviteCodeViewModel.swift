//
//  JoinInviteCodeViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/06/21.
//


import Foundation
import Combine
import SwiftUI
class JoinInviteCodeViewModel: ObservableObject {
    @Published var codeTxt = ""
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
    @Published var loading = false
    
    //MARK:- Validation Functions
    
    func callValidations() -> [String]{
        isValidInviteCode()
        return arr
    }
  
    func isValidInviteCode() {
        let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
        let inviteCode = getRegisterDefaultData!["inviteCode"] ?? 0
        print("inviteCode=====\(inviteCode)")
        if codeTxt.count == 0 {
            arr.append(state.inviteCode)
        }else if "\(inviteCode)" != codeTxt {
            arr.append(state.vInviteCode)
        }
    }

    func clearData() {
        arr = [String]()
    }
    
    func TakenJoinCodeService(inviteCode: String, completion: @escaping(_ result : String?, _ responce : JoinModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "inviteCode" : inviteCode,
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.join_couple_code.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(JoinModel.self, from: apiData )
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
