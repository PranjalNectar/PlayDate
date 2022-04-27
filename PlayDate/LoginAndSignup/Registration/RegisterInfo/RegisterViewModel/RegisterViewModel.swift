//
//  RegisterViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 06/05/21.
//

import Foundation
import Combine
import SwiftUI
class RegisterViewModel: ObservableObject {
    @Published var authenticated = Bool()
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var address = ""
    @Published var phoneNo = ""
    @Published var userType = ""
    @Published var errormessage = ""
    @Published var status = Int()
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var loading = false
    
    var arrInterest = [[String:Any]]()
    var arrRestaurant = [[String:Any]]()
    
    init(){}
    
    //MARK:- API

    func callRegisterApi(completion: @escaping(_ result : String?, _ responce : LoginResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["email": email,
                          "address" : address,
                          "phoneNo" : phoneNo,
                          "password": password,
                          "fullName" : fullName,
                          "userType" : userType,
                          "deviceType": Constants.Device.deviceType,
                          "deviceID": Constants.Device.deviceID,
                          "deviceToken": UserDefaults.standard.value(forKey: Constants.UserDefaults.deviceToken) as Any,
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.register.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        UserDefaults.standard.set(apiData, forKey: Constants.UserDefaults.userData)
                        let response = try JSONDecoder().decode(LoginResultModel.self, from: apiData)
                        
                        if response.status != 0{
                            saveUserToken(token: response.data?.token ?? "")
                            saveUserId(userID: response.data?.userId ?? "")
                            //Get user default data
                            if
                                let loginResultDataEncode = UserDefaults.standard.value(forKey: Constants.UserDefaults.userData) as? Data,
                                let loginResultDataDecode = try? JSONDecoder().decode(LoginResultModel.self, from: loginResultDataEncode) {
                                print(loginResultDataDecode.data?.token ?? "")
                                print(loginResultDataDecode.data?.fullName ?? "")
                                // loginResultDataDecode.data.sourceSocialId = "1"
                                
                                userToken = response.data?.token ??  ""
                                
                                //Interest
                                let interest = loginResultDataDecode.data?.interested ?? [LoginDataInterested]()
                                
                                do {
                                    // Create JSON Encoder
                                    let encoder = JSONEncoder()
                                    
                                    // Encode Note
                                    let data = try encoder.encode(interest)
                                    
                                    // Write/Set Data
                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.interest)
                                    
                                    do {
                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                                            print("Error: Cannot convert data to JSON object")
                                            
                                            return
                                        }
                                        self.arrInterest = jsonObject
                                        print(jsonObject)
                                        print(self.arrInterest)
                                    } catch {
                                        print("Error: Trying to convert JSON data to string")
                                        return
                                    }
                                    
                                } catch {
                                    print("Unable to Encode Array of Notes (\(error))")
                                }
                                
                                
                                //Restaurant
                                let restaurants = loginResultDataDecode.data?.restaurants ?? [LoginDataRestaurant]()
                                
                                do {
                                    // Create JSON Encoder
                                    let encoder = JSONEncoder()
                                    
                                    // Encode Note
                                    let data = try encoder.encode(restaurants)
                                    
                                    // Write/Set Data
                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.restaurants)
                                    
                                    do {
                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                                            print("Error: Cannot convert data to JSON object")
                                            
                                            return
                                        }
                                        self.arrRestaurant = jsonObject
                                        print(jsonObject)
                                        print(self.arrRestaurant)
                                    } catch {
                                        print("Error: Trying to convert JSON data to string")
                                        return
                                    }
                                    
                                } catch {
                                    print("Unable to Encode Array of Notes (\(error))")
                                }
                                
                                
                                let userData : [String:Any] = ["email":loginResultDataDecode.data?.email ?? "",
                                                               "phoneNo":loginResultDataDecode.data?.phoneNo ?? "",
                                                               "birthDate" : loginResultDataDecode.data?.birthDate ?? "" ,
                                                               "gender" :  loginResultDataDecode.data?.gender ?? "",
                                                               "relationship":  loginResultDataDecode.data?.relationship ?? "",
                                                               "interestedIn" :  loginResultDataDecode.data?.interestedIn ?? "" ,
                                                               "username":  loginResultDataDecode.data?.username ?? "",
                                                               "personalBio":  loginResultDataDecode.data?.personalBio ?? "",
                                                               "uploadImage": loginResultDataDecode.data?.profilePic ?? "",
                                                               "interestList":  self.arrInterest ,
                                                               "restaurant":  self.arrRestaurant,
                                                               "profilePicPath":loginResultDataDecode.data?.profilePicPath ?? "",
                                                               "profileVideoPath":loginResultDataDecode.data?.profileVideoPath ?? "",
                                                               "inviteCode":loginResultDataDecode.data?.inviteCode ?? "",
                                                               "inviteLink": loginResultDataDecode.data?.inviteLink ?? "",
                                                               "userType" : loginResultDataDecode.data?.userType ?? "",
                                                               "businessPhoto" : loginResultDataDecode.data?.businessImage ?? "",
                                                               "fullName" : loginResultDataDecode.data?.fullName ?? ""
                                ]
                                
                                SharedPreferance.setAppUserType(loginResultDataDecode.data?.userType ?? "")
                                print(userData)
                                UserDefaults.standard.set(userData, forKey:Constants.UserDefaults.loginData)
                            }
                          
                            completion(strResult.success.rawValue,response, nil)
                        }else{
                            completion(strResult.error.rawValue,response, nil)
                        }
                    } catch (let error){
                        
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let result = try JSONDecoder().decode(RegisterErrorModel.self, from: apiData)

                            print("error")
                            self.errormessage =  result.data![0].msg ?? ""
                            completion(strResult.error.rawValue, nil, self.errormessage)

                        } catch {
                        }
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
    
    
    
    
    //MARK:- Validation Functions
    func callRegisterValidations() -> [String]{
        
        isValidFullName()
        isValidAddress()
        isValidPhone()
        isValidEmail()
        isValidPassword()
        
        return arr
    }
    
    func isValidPassword() {
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count == 0 {
            arr.append(state.password)
        } else if password.count < 6 {
            arr.append(state.vPassword)
        }
    }
    
    func isValidEmail()  {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if email.count == 0 {
            arr.append(state.email)
            
        }else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailPred.evaluate(with: email) == false {
                arr.append(state.vEmail)
                
            }
        }
    }
    func isValidAddress() {
        address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        if address.count == 0 {
            arr.append(state.address)
        }
    }
    
    
    func isValidFullName() {
        fullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        if fullName.count == 0 {
            if userType == "Person"{
                arr.append(state.fullName)
            }else{
                arr.append(state.businessName)
            }
        }
    }
    
    func isValidPhone(){
        phoneNo = phoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if phoneNo.count == 0 {
            arr.append(state.phoneNumber)
            
        } else if phoneNo.count < 10 {
            arr.append(state.vPhoneNumber)
        }
    }
    
    func clearData() {
        
        arr = [String]()
    }
}
