//
//  LoginViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/04/21.
//


import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var keyward = ""
    @Published var password = ""
    @Published var textLimit = 10 //Your limit
    @Published var arr = [String]()
    @Published var state = MessageString()
    @Published var authenticated = Bool()
    @Published var loading = false
    var arrInterest = [[String:Any]]()
    var arrRestaurant = [[String:Any]]()
    
    //MARK:- API

    func callLoginApi(completion: @escaping(_ result : String?, _ responce : LoginResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["keyward": keyward,
                          "password": password,
                          "deviceType": Constants.Device.deviceType,
                          "deviceID": Constants.Device.deviceID,
                          "deviceToken": "45581515151",// UserDefaults.standard.value(forKey: Constants.UserDefaults.deviceToken) as Any,
            ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.login.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        UserDefaults.standard.set(apiData, forKey: Constants.UserDefaults.userData)
                        let response = try JSONDecoder().decode(LoginResultModel.self, from: apiData)
                        if response.status != 0{
                            saveUserToken(token: response.data?.token ?? "")
                            saveUserId(userID: response.data?.userId ?? "")
                            userToken = response.data?.token ??  ""
                            self.SaveData()
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
    
    
    func callSocialLoginApi(parameter:[String:Any],completion: @escaping(_ result : String?, _ responce : LoginResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["sourceType": parameter["sourceType"] as! String,
                          "sourceSocialId":parameter["sourceSocialId"] as! String,
                          "email" : parameter["email"] as? String ?? "",
                          "deviceType": Constants.Device.deviceType,
                          "deviceID": Constants.Device.deviceID,
                          "deviceToken": UserDefaults.standard.value(forKey: Constants.UserDefaults.deviceToken) as Any,
                          
            ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.socialLogin.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        UserDefaults.standard.set(apiData, forKey: Constants.UserDefaults.userData)
                        let response = try JSONDecoder().decode(LoginResultModel.self, from: apiData)
                        if response.status != 0{
                            saveUserToken(token: response.data?.token ?? "")
                            saveUserId(userID: response.data?.userId ?? "")
                            userToken = response.data?.token ??  ""
                            self.SaveData()
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
    
    
    
    func SaveData(){
        if
            let loginResultDataEncode = UserDefaults.standard.value(forKey: Constants.UserDefaults.userData) as? Data,
            let loginResultDataDecode = try? JSONDecoder().decode(LoginResultModel.self, from: loginResultDataEncode) {
            print(loginResultDataDecode.data?.token ?? "")
            print(loginResultDataDecode.data?.fullName ?? "")
            // loginResultDataDecode.data.sourceSocialId = "1"
           
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
            
            print(userData)
            SharedPreferance.setAppUserType(loginResultDataDecode.data?.userType ?? "")
            
            UserDefaults.standard.set(userData, forKey:Constants.UserDefaults.loginData)
        }
    }
    
    
    //MARK:- Validation Functions
    
    func callLoginValidations() -> [String]{
        
        isValidUserName()
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
    
    func isValidUserName() {
        keyward = keyward.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyward.count == 0 {
            arr.append(state.userName)
        }
    }
    
    func isValidPhone(){
        //  keyward = String(keyward.prefix(10))
        keyward = keyward.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyward.count == 0 {
            arr.append(state.phoneNumber)
            
        }else {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{7,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            let valid = phoneTest.evaluate(with: keyward)
            if !valid {
                arr.append(state.vPhoneNumber)
            }
        }
    }
    func clearData() {
        
        arr = [String]()
    }
}



// -------------  Login -------------- //

//                            if
//                                let loginResultDataEncode = UserDefaults.standard.value(forKey: Constants.UserDefaults.userData) as? Data,
//                                let loginResultDataDecode = try? JSONDecoder().decode(LoginResultModel.self, from: loginResultDataEncode) {
//                                print(loginResultDataDecode.data?.token ?? "")
//                                print(loginResultDataDecode.data?.fullName ?? "")
//                                // loginResultDataDecode.data.sourceSocialId = "1"
//
//                                userToken = response.data?.token ??  ""
//
//                                //Interest
//                                let interest = loginResultDataDecode.data?.interested ?? [LoginDataInterested]()
//
//                                do {
//                                    // Create JSON Encoder
//                                    let encoder = JSONEncoder()
//
//                                    // Encode Note
//                                    let data = try encoder.encode(interest)
//
//                                    // Write/Set Data
//                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.interest)
//
//                                    do {
//                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//                                            print("Error: Cannot convert data to JSON object")
//                                            return
//                                        }
//                                        self.arrInterest = jsonObject
//                                        print(jsonObject)
//                                        print(self.arrInterest)
//                                    } catch {
//                                        print("Error: Trying to convert JSON data to string")
//                                        return
//                                    }
//                                } catch {
//                                    print("Unable to Encode Array of Notes (\(error))")
//                                }
//
//                                //Restaurant
//                                let restaurants = loginResultDataDecode.data?.restaurants ?? [LoginDataRestaurant]()
//
//                                do {
//                                    // Create JSON Encoder
//                                    let encoder = JSONEncoder()
//
//                                    // Encode Note
//                                    let data = try encoder.encode(restaurants)
//
//                                    // Write/Set Data
//                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.restaurants)
//
//                                    do {
//                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//                                            print("Error: Cannot convert data to JSON object")
//
//                                            return
//                                        }
//                                        self.arrRestaurant = jsonObject
//                                        print(jsonObject)
//                                        print(self.arrRestaurant)
//                                    } catch {
//                                        print("Error: Trying to convert JSON data to string")
//                                        return
//                                    }
//
//                                } catch {
//                                    print("Unable to Encode Array of Notes (\(error))")
//                                }
//
//
//                                let userData : [String:Any] = ["email":loginResultDataDecode.data?.email ?? "",
//                                                               "phoneNo":loginResultDataDecode.data?.phoneNo ?? "",
//                                                               "birthDate" : loginResultDataDecode.data?.birthDate ?? "" ,
//                                                               "gender" :  loginResultDataDecode.data?.gender ?? "",
//                                                               "relationship":  loginResultDataDecode.data?.relationship ?? "",
//                                                               "interestedIn" :  loginResultDataDecode.data?.interestedIn ?? "" ,
//                                                               "username":  loginResultDataDecode.data?.username ?? "",
//                                                               "personalBio":  loginResultDataDecode.data?.personalBio ?? "",
//                                                               "uploadImage": loginResultDataDecode.data?.profilePic ?? "",
//                                                               "interestList":  self.arrInterest ,
//                                                               "restaurant":  self.arrRestaurant,
//                                                               "profilePicPath":loginResultDataDecode.data?.profilePicPath ?? "",
//                                                               "profileVideoPath":loginResultDataDecode.data?.profileVideoPath ?? "",
//                                                               "inviteCode":loginResultDataDecode.data?.inviteCode ?? "",
//                                                               "inviteLink": loginResultDataDecode.data?.inviteLink ?? "",
//                                                               "userType" : loginResultDataDecode.data?.userType ?? "",
//                                                               "businessPhoto" : loginResultDataDecode.data?.businessImage ?? "",
//                                                               "fullName" : loginResultDataDecode.data?.fullName ?? ""
//                                ]
//
//                                print(userData)
//                                SharedPreferance.setAppUserType(loginResultDataDecode.data?.userType ?? "")
//
//                                UserDefaults.standard.set(userData, forKey:Constants.UserDefaults.loginData)
//
//                                ConnectWithQB.init()
//                            }


// ----------- social Login ----------- ///


//                            if
//                                let loginResultDataEncode = UserDefaults.standard.value(forKey: Constants.UserDefaults.userData) as? Data,
//                                let loginResultDataDecode = try? JSONDecoder().decode(LoginResultModel.self, from: loginResultDataEncode) {
//                                print(loginResultDataDecode.data?.token ?? "")
//                                print(loginResultDataDecode.data?.fullName ?? "")
//                                // loginResultDataDecode.data.sourceSocialId = "1"
//
//                                userToken = response.data?.token ??  ""
//
//                                //Interest
//                                let interest = loginResultDataDecode.data?.interested ?? [LoginDataInterested]()
//
//                                do {
//                                    // Create JSON Encoder
//                                    let encoder = JSONEncoder()
//
//                                    // Encode Note
//                                    let data = try encoder.encode(interest)
//
//                                    // Write/Set Data
//                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.interest)
//
//                                    do {
//                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//                                            print("Error: Cannot convert data to JSON object")
//
//                                            return
//                                        }
//                                        self.arrInterest = jsonObject
//                                        print(jsonObject)
//                                        print(self.arrInterest)
//                                    } catch {
//                                        print("Error: Trying to convert JSON data to string")
//                                        return
//                                    }
//
//                                } catch {
//                                    print("Unable to Encode Array of Notes (\(error))")
//                                }
//
//
//                                //Restaurant
//                                let restaurants = loginResultDataDecode.data?.restaurants ?? [LoginDataRestaurant]()
//
//                                do {
//                                    // Create JSON Encoder
//                                    let encoder = JSONEncoder()
//
//                                    // Encode Note
//                                    let data = try encoder.encode(restaurants)
//
//                                    // Write/Set Data
//                                    UserDefaults.standard.set(data, forKey:Constants.UserDefaults.restaurants)
//
//                                    do {
//                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//                                            print("Error: Cannot convert data to JSON object")
//
//                                            return
//                                        }
//                                        self.arrRestaurant = jsonObject
//                                        print(jsonObject)
//                                        print(self.arrRestaurant)
//                                    } catch {
//                                        print("Error: Trying to convert JSON data to string")
//                                        return
//                                    }
//
//                                } catch {
//                                    print("Unable to Encode Array of Notes (\(error))")
//                                }
//
//
//                                let userData : [String:Any] = ["email":loginResultDataDecode.data?.email ?? "",
//                                                               "phoneNo":loginResultDataDecode.data?.phoneNo ?? "",
//                                                               "birthDate" : loginResultDataDecode.data?.birthDate ?? "" ,
//                                                               "gender" :  loginResultDataDecode.data?.gender ?? "",
//                                                               "relationship":  loginResultDataDecode.data?.relationship ?? "",
//                                                               "interestedIn" :  loginResultDataDecode.data?.interestedIn ?? "" ,
//                                                               "username":  loginResultDataDecode.data?.username ?? "",
//                                                               "personalBio":  loginResultDataDecode.data?.personalBio ?? "",
//                                                               "uploadImage": loginResultDataDecode.data?.profilePic ?? "",
//                                                               "interestList":  self.arrInterest ,
//                                                               "restaurant":  self.arrRestaurant,
//                                                               "profilePicPath":loginResultDataDecode.data?.profilePicPath ?? "",
//                                                               "profileVideoPath":loginResultDataDecode.data?.profileVideoPath ?? "",
//                                                               "inviteCode":loginResultDataDecode.data?.inviteCode ?? "","inviteLink": loginResultDataDecode.data?.inviteLink ?? "",
//                                                               "userType" : loginResultDataDecode.data?.userType ?? "",
//                                                               "businessPhoto" : loginResultDataDecode.data?.businessImage ?? "",
//                                                               "fullName" : loginResultDataDecode.data?.fullName ?? ""
//                                ]
//
//                                print(userData)
//                                UserDefaults.standard.set(userData, forKey:Constants.UserDefaults.loginData)
//                            }
                           
