//
//  Constants.swift
//  PlayDate
//
//  Created by Pallavi Jain on 06/05/21.
//
import Foundation
import SwiftUI

struct Constants {
    static let AppName = "PlayDate"
    
    struct Device {
        static let deviceID = UIDevice.current.identifierForVendor!.uuidString
        static let deviceType = "Ios"
    }
    
    
    struct UserDefaults {
        static let isUserLogin = "isUserLogin"
        static let token = "token"
        static let userData = "userData"
        static let loginData = "loginData"
        static let controller = "controller"
        static let isLogin = "isLogin"
        static let backButton = "backButton"
        static let userId = "userId"
        static let interest = "interest"
        static let restaurants = "restaurants"
        static let isSuggestionOpen = "isSuggestionOpen"
        static let requestID = "requestID"
        static let deviceToken = "deviceToken"
        
        
    }
    
    struct AppColor {
        static let appBlack = Color("appBlack")
        static let appPink = Color("pink")
        static let applightPink = Color("lightPink")
        static let appRegisterbg = Color("registerbg")
        static let appWhite = Color("appWhite")
        static let appBlackWhite = Color("appBlackWhite")
        static let appDarkGary = Color("appDarkGary")
        
        
    }
    
}

enum UserType : String{
    case Person
    case Business
}

class SharedPreferance : NSObject{
    
    let kAppDarkTheme   = "AppDarkTheme"
    let kAppUserType    = "AppUserType"
    
    fileprivate let defaults = UserDefaults.standard
    static let sharedInstance = SharedPreferance()
    
    class func getAppDarkTheme() -> Bool {
        return sharedInstance.getAppDarkTheme() ?? false
    }
    fileprivate func getAppDarkTheme() -> Bool?{
        return defaults.value(forKey: kAppDarkTheme) as? Bool;
    }
    
    class func setAppDarkTheme(_ isAppDarkTheme: Bool) {
        sharedInstance.setAppDarkTheme(isAppDarkTheme)
    }
    fileprivate func setAppDarkTheme(_ isAppDarkTheme: Bool){
        defaults.set(isAppDarkTheme, forKey:kAppDarkTheme );
    }
    
    
    class func getAppUserType() -> String {
        return sharedInstance.getAppUserType() ?? ""
    }
    fileprivate func getAppUserType() -> String?{
        return defaults.value(forKey: kAppUserType) as? String;
    }
    
    class func setAppUserType(_ AppUserType: String) {
        sharedInstance.setAppUserType(AppUserType)
    }
    fileprivate func setAppUserType(_ AppUserType: String){
        defaults.set(AppUserType, forKey:kAppUserType );
    }
    
}

func saveUserToken(token:String) {
    
    let userToken: String = token
    let userdefaults = UserDefaults.standard
    userdefaults.set(userToken, forKey: Constants.UserDefaults.token)
    userdefaults.synchronize()
}

func saveUserId(userID:String) {
    
    let userId: String = userID
    let userdefaults = UserDefaults.standard
    userdefaults.set(userId, forKey: Constants.UserDefaults.userId)
    userdefaults.synchronize()
}
func saveRelationshipRequestID(requestID:String) {
    
    let userId: String = requestID
    let userdefaults = UserDefaults.standard
    userdefaults.set(userId, forKey: Constants.UserDefaults.requestID)
    userdefaults.synchronize()
}
var userToken = ""

func getLoginUserDefaults(key:String) -> Any{
    let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
    let result = getRegisterDefaultData![key] as Any
    return result
}

func saveDeviceToken(deviceToken:String) {
    
    let deviceToken: String = deviceToken
    let userdefaults = UserDefaults.standard
    userdefaults.set(deviceToken, forKey: Constants.UserDefaults.deviceToken)
    userdefaults.synchronize()
}


enum Controller {
    case birthDate, gender,relationship,genderInterest,username, personalBio, uploadImage,ineterstList,restaurant,dashboard, recordprofilevideo, businessPhoto
}

//MARK:- Navigation from login and register
var controller: Controller = .dashboard

func selectLoginResgisterController() -> Controller{
    let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
    
    if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
        
        if getRegisterDefaultData!["birthDate"] as! String == "" {
            UserDefaults.standard.set("birthDate", forKey:Constants.UserDefaults.controller)
            controller = .birthDate
        }else if getRegisterDefaultData!["gender"] as! String == "" {
            UserDefaults.standard.set("gender", forKey:Constants.UserDefaults.controller)
            controller = .gender
        }else if getRegisterDefaultData!["relationship"] as! String == "" {
            UserDefaults.standard.set("relationship", forKey:Constants.UserDefaults.controller)
            controller = .relationship
        }else if getRegisterDefaultData!["interestedIn"] as! String == "" {
            UserDefaults.standard.set("genderInterest", forKey:Constants.UserDefaults.controller)
            controller = .genderInterest
        }else if getRegisterDefaultData!["username"] as! String == "" {
            UserDefaults.standard.set("username", forKey:Constants.UserDefaults.controller)
            controller = .username
        }else if getRegisterDefaultData!["personalBio"] as! String == "" {
            UserDefaults.standard.set("personalBio", forKey:Constants.UserDefaults.controller)
            controller = .personalBio
        }else if getRegisterDefaultData!["uploadImage"] as! String == "" {
            UserDefaults.standard.set("uploadImage", forKey:Constants.UserDefaults.controller)
            controller = .uploadImage
        }else if (getRegisterDefaultData!["interestList"] as! [[String:Any]]).count == 0 {
            UserDefaults.standard.set("ineterstList", forKey:Constants.UserDefaults.controller)
            controller = .ineterstList
        }else if (getRegisterDefaultData!["restaurant"]as! [[String:Any]]).count == 0 {
            UserDefaults.standard.set("restaurant", forKey:Constants.UserDefaults.controller)
            controller = .restaurant
        }else if getRegisterDefaultData!["profileVideoPath"]as! String == "" {
            UserDefaults.standard.set("profileVideoPath", forKey:Constants.UserDefaults.controller)
            controller = .recordprofilevideo
        }else {
            UserDefaults.standard.set("dashboard", forKey:Constants.UserDefaults.controller)
            controller = .dashboard
            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.isLogin)
        }
       
        return controller
    }else{
        if getRegisterDefaultData!["birthDate"] as! String == "" {
            UserDefaults.standard.set("birthDate", forKey:Constants.UserDefaults.controller)
            controller = .birthDate
        }else if getRegisterDefaultData!["username"] as! String == "" {
            UserDefaults.standard.set("username", forKey:Constants.UserDefaults.controller)
            controller = .username
        }else if getRegisterDefaultData!["personalBio"] as! String == "" {
            UserDefaults.standard.set("personalBio", forKey:Constants.UserDefaults.controller)
            controller = .personalBio
        }else if getRegisterDefaultData!["uploadImage"] as! String == "" {
            UserDefaults.standard.set("uploadImage", forKey:Constants.UserDefaults.controller)
            controller = .uploadImage
        }else if getRegisterDefaultData!["businessPhoto"]as! String == "" {
            UserDefaults.standard.set("businessPhoto", forKey:Constants.UserDefaults.controller)
            controller = .businessPhoto
        }else {
            UserDefaults.standard.set("dashboard", forKey:Constants.UserDefaults.controller)
            controller = .dashboard
            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.isLogin)
        }
        return controller
    }
    
    
}
