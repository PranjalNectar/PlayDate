//
//  GenderInterest.swift
//  PlayDate
//
//  Created by Pranjal on 22/04/21.
//

import SwiftUI

struct GenderInterest: View {
    
    @State private var didTapMale:Bool = false
    @State private var didTapFemale:Bool = false
    @State private var didTapNon:Bool = false
    @Environment(\.presentationMode) var presentation
   
    @State var interestedIn = ""
    @State private var Authenticate: Bool = false
    @State private var error: Bool = false
    @State var message = ""
   
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @Binding var comingFromEdit: Bool
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
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
                HStack{
                    VStack(alignment : .leading ,spacing: 10.0){
                        Text("Intersted in")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text("Please select your sex orientation")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16.0)
                Spacer()
                
                VStack(spacing: 25.0){
                    Button(action: {
                        if self.didTapMale{
                            self.didTapMale.toggle()
                        }else{
                            self.didTapMale.toggle()
                        }
                    }) {
                        RelationText(text: "MALE")
                            .background(didTapMale ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    AndText()
                    
                    Button(action: {
                        if self.didTapFemale{
                            self.didTapFemale = false
                        }else{
                            self.didTapFemale = true
                        }
                    }) {
                        RelationText(text:"FEMALE")
                            .background(didTapFemale ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    AndText()
                    
                    Button(action: {
                        if self.didTapNon{
                            self.didTapNon = false
                        }else{
                            self.didTapNon = true
                        }
                    }) {
                        RelationText(text:"NON - BINARY")
                            .background(didTapNon ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                }
                
                Spacer()
                VStack(alignment: .center){
                    
                    
                    NavigationLink(destination: Username(comingFromEdit: .constant(false)), isActive: $Authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if didTapMale == false && didTapFemale == false && didTapNon == false {
                                interestedIn = ""
                            }else {
                                var arrInterest = [String]()
                                if didTapMale {
                                    arrInterest.append("Male")
                                }
                                if didTapFemale {
                                    arrInterest.append("Female")
                                }
                                if didTapNon{
                                    arrInterest.append("Other")
                                }
                                interestedIn = arrInterest.joined(separator: ",")
                            }
                            if interestedIn == ""  {
                                self.Authenticate = false
                                self.shown = true
                                arrValid = [String]()
                                arrValid.append(MessageString().genderInterest)
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
                
            }.blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
        }
        .statusBar(style: .lightContent)
        .onAppear{
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            interestedIn = getRegisterDefaultData!["interestedIn"] as! String
            
            let interestedInArr = interestedIn.split(separator: ",")
            if interestedInArr.count == 0 {
                
            }else {
                
                if interestedInArr.contains("Male") {
                    self.didTapMale = true
                }
                if interestedInArr.contains("Female") {
                    self.didTapFemale = true
                }
                if interestedInArr.contains("Other") {
                    self.didTapNon = true
                }
            }
            
        }
    }
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: interestedIn, type: "interestedIn") { result, response,error  in
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
                UserDefaults.standard.set("username", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["interestedIn"] = interestedIn
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
