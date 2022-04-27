//
//  UserGenderView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/05/21.
//



import SwiftUI

struct UserGenderView: View {
    
    @Binding var comingFromEdit: Bool
    @State private var didTapS:Bool = false
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State private var didTapT:Bool = false
    @State private var didTapN:Bool = false
    @Environment(\.presentationMode) var presentation
    @State private var Authenticate: Bool = false
    @State private var error: Bool = false
    @State var gender = ""
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var message = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                        
                    }
                    
                    Spacer()
                }
                HStack(alignment :.top){
                    VStack(alignment : .leading ,spacing: 10.0){
                        Text("Gender")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text("Please select your gender")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16.0)
                Spacer()
                
                VStack(spacing: 25.0){
                    Button(action: {
                        if !self.didTapS{
                            self.didTapS = true
                            self.didTapT = false
                            self.didTapN = false
                        }
                        gender = "Male"
                    }) {
                        RelationText(text: "MALE")
                            .background(didTapS ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    OrText()
                    
                    Button(action: {
                        if !self.didTapT{
                            self.didTapT = true
                            self.didTapS = false
                            self.didTapN = false
                        }
                        gender = "Female"
                    }) {
                        RelationText(text:"FEMALE")
                            .background(didTapT ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    OrText()
                    
                    Button(action: {
                        if !self.didTapN{
                            self.didTapT = false
                            self.didTapS = false
                            self.didTapN = true
                        }
                        gender = "Other"
                    }) {
                        RelationText(text:"NON - BINARY")
                            .background(didTapN ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                }
                
                Spacer()
                VStack(alignment: .center){
                    
                    NavigationLink(destination: Relationship(comingFromEdit: .constant(false)), isActive: $Authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if gender == ""  {
                                self.Authenticate = false
                                self.shown = true
                                arrValid = [String]()
                                arrValid.append(MessageString().userGender)
                            }else {
                                self.shown = false
                                arrValid = [String]()
                                self.UpdateUserProfielService()
                            }
                            
                        }, label: {
                            NextArrow()
                        })
                        .alert(isPresented: self.$error) {
                            Alert(title: Text(message))
                        }
                    }
                }
                Spacer()
                
            }.onAppear{
                let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                gender = getRegisterDefaultData!["gender"] as! String
                if gender == "" {
                    
                }else {
                    if gender == "Male" {
                        self.didTapS = true
                    }else if gender == "Female"{
                        self.didTapT = true
                    }else {
                        self.didTapN = true
                    }
                }
                
            }
            .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            if shown
            {
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            
        }
        .statusBar(style: .lightContent)
    }
    
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: gender, type: "gender") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                }
                self.error = false
                UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                UserDefaults.standard.set("relationship", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["gender"] = gender
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
            }else if result == strResult.error.rawValue{
                self.Authenticate = false
                self.error = true
                //self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                //self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                //self.showAlert = true
            }
        }
    }
}
