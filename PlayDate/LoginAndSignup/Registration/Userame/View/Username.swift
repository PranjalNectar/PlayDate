//
//  Username.swift
//  PlayDate
//
//  Created by Pranjal on 22/04/21.
//

import SwiftUI

struct Username: View {
    
    @State var txtUsername: String = ""
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var userNameVM = UserNameViewModel()
    @Binding var comingFromEdit: Bool
    @State private var Authenticate: Bool = false
    @State var c: AlertAction?
    @State var shown = false
    @State var message = ""
    @State private var error: Bool = false
    @State private var showAlert: Bool = false
    @State var isPerson = true
    @State var isSelectPerson: Bool = true
    var body: some View {
        
        ZStack{
            VStack(spacing: 16){
                HStack{
                    
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                    }
                    Spacer()
                }
                HStack{
                    VStack(alignment : .leading ,spacing: 10.0){
                        Text(self.isSelectPerson ? "Create username" : "Create business username")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text(self.isSelectPerson ? "Search for a username to display on your profile" : "Search for a Business username to display on your profile")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16.0)
                Spacer()
                
                VStack(spacing: 25.0){
                    HStack(alignment: .center) {
                        
                        ZStack(alignment: .leading) {
                            if txtUsername.isEmpty { Text("Type username").foregroundColor(.white) }
                            TextField("", text: $txtUsername)
                                .foregroundColor(Color.white)
                                .accentColor(.white)
                            
                        }
                        .padding()
                        if txtUsername.isEmpty{
                            Image("uncheck").padding()
                        }else{
                            Image("check").padding()
                        }
                        
                    }.overlay(
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color.white, lineWidth: 1)
                    )
                    
                    .background(Constants.AppColor.appRegisterbg)
                    
                    Spacer()
                }.padding([.leading, .bottom, .trailing])
                Spacer()
                
                VStack(alignment: .center){
                    NavigationLink(destination: PersonalBio(comingFromEdit:.constant(false),coupleid:.constant(""), relationship: .constant("")), isActive: $Authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if !txtUsername.isEmpty{
                                self.UpdateUsernameService()
                            }else {
                                self.Authenticate = false
                            }
                        }, label: {
                            NextArrow()
                        })
                    }
                }
            }
            
            .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            ActivityLoader(isToggle: $userNameVM.loading)
        }
        .alert(isPresented: $error, title: Constants.AppName, message: self.message)
        .statusBar(style: .lightContent)
        .onAppear{
            
            if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                self.isSelectPerson = true
            }else{
                self.isSelectPerson = false
            }
            
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            txtUsername = getRegisterDefaultData!["username"] as! String
        }
    }
    
    
    func UpdateUsernameService(){
        userNameVM.callUserNameApi(username: txtUsername) { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                }
                UserDefaults.standard.set("uploadImage", forKey:Constants.UserDefaults.controller)
                self.error = false
                UserDefaults.standard.set("personalBio", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                
                registerDefaultData?["username"] = txtUsername
                
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
            }else if result == strResult.error.rawValue{
                self.Authenticate = false
                self.error = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
}

