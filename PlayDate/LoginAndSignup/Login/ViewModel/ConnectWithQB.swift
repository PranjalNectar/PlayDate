//
//  ConnectWithQB.swift
//  PlayDate
//
//  Created by Pranjal on 27/07/21.
//

import Foundation
import Quickblox

class ConnectWithQB{
    init() {
        let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
        self.signUp(fullName: "\(registerDefaultData?["username"] ?? "")",
                    login: UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                    email: "\(registerDefaultData?["email"] ?? "")",
                    phone: "\(registerDefaultData?["phoneNo"] ?? "")")
    }
    
    //MARK: - Internal Methods
    /**
     *  Signup and login
     */
    private func signUp(fullName: String, login: String, email : String, phone : String) {
        //beginConnect()
        let newUser = QBUUser()
        newUser.login = login
        newUser.fullName = fullName
        newUser.password = LoginConstant.defaultPassword
        newUser.email = email
        newUser.externalUserID = 0
        newUser.phone = phone
        //infoText = LoginStatusConstant.signUp
        QBRequest.signUp(newUser, successBlock: { [weak self] response, user in
            
            self?.login(fullName: fullName, login: login)
            
            }, errorBlock: { [weak self] response in
                
                if response.status == QBResponseStatusCode.validationFailed {
                    // The user with existent login was created earlier
                    self?.login(fullName: fullName, login: login)
                    return
                }
                //self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
        })
    }
    
    /**
     *  login
     */
    private func login(fullName: String, login: String, password: String = LoginConstant.defaultPassword) {
       // beginConnect()
        
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { [weak self] response, user in

                            user.password = password
                            user.updatedAt = Date()
                            Profile.synchronize(user)
                            
                            if user.fullName != fullName {
                                //self?.updateFullName(fullName: fullName, login: login)
                            } else {
                                self?.connectToChat(user: user)
                            }
                            
            }, errorBlock: { [weak self] response in
                //self?.handleError(response.error?.error, domain: ErrorDomain.logIn)
                if response.status == QBResponseStatusCode.unAuthorized {
                    // Clean profile
                    Profile.clearProfile()
                    //self?.defaultConfiguration()
                }
        })
    }
    
    /**
     *  connectToChat
     */
    private func connectToChat(user: QBUUser) {
       // infoText = LoginStatusConstant.intoChat
        QBChat.instance.connect(withUserID: user.id,
                                password: LoginConstant.defaultPassword,
                                completion: { [weak self] error in
                                    if let error = error {
                                        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                                            // Clean profile
                                            Profile.clearProfile()
                                            //self?.defaultConfiguration()
                                        } else {
                                            //self?.handleError(error, domain: ErrorDomain.logIn)
                                        }
                                    } else {
                                        //did Login action
                                        //self?.performSegue(withIdentifier: LoginConstant.showUsers, sender: nil)
                                    }
        })
    }
    
}
