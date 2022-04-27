//
//  Relationship.swift
//  PlayDate
//
//  Created by Pranjal on 22/04/21.
//

import SwiftUI

struct Relationship: View {
    
    @Binding var comingFromEdit: Bool
    @State private var didTapS:Bool = false
    @State private var didTapT:Bool = false
    @Environment(\.presentationMode) var presentation
    @State private var Authenticate: Bool = false
    @State private var error: Bool = false
    @State var relationship = ""
    @State var localRelationship = ""
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var message = ""
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State private var controller: Controller = .GenderInterest
    
    @State var comeFromBack = false
    
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
                        Text("Relationship")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text("Please select your relationship status")
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
                        }
                        relationship = "Single"
                        localRelationship = "Single"
                    }) {
                        RelationText(text: "SINGLE")
                            .background(didTapS ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    OrText()
                    
                    Button(action: {
                        if !self.didTapT{
                            self.didTapT = true
                            self.didTapS = false
                        }
                        relationship = "Taken"
                        localRelationship = "Taken"
                    }) {
                        RelationText(text:"TAKEN")
                            .background(didTapT ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                }
                
                Spacer()
                VStack(alignment: .center){
                    NavigationLink(destination: chooseDestination(), isActive: $Authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if relationship == ""  {
                                self.Authenticate = false
                                self.shown = true
                                arrValid = [String]()
                                arrValid.append(MessageString().relationship)
                            }else {
                                self.shown = false
                                arrValid = [String]()
                                if relationship == "Taken"{
                                    self.Authenticate = true
                                    selectController()
                                }else {
                                    self.UpdateUserProfielService()
                                    
                                }
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
            relationship = getRegisterDefaultData!["relationship"] as! String
            
            if comeFromBack {
                
                if localRelationship == "" {
                    
                }else {
                    
                    if localRelationship == "Single" {
                        self.didTapS = true
                    }else {
                        self.didTapT = true
                    }
                    
                }
            }else {
                if relationship == "" {
                    
                }else {
                    
                    if relationship == "Single" {
                        self.didTapS = true
                    }else {
                        self.didTapT = true
                    }
                    
                }
            }
            
        }
        
    }
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: relationship, type: "relationship") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                    selectController()
                }
                self.error = false
                UserDefaults.standard.set("genderInterest", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["relationship"] = relationship
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

    enum Controller {
        case GenderInterest, SelectInviteJoin
    }
    
    @ViewBuilder
    func chooseDestination() -> some View {
        switch controller {
        case .GenderInterest: GenderInterest(comingFromEdit: $comingFromEdit)
        default: SelectInviteJoinView(comingFromEdit: $comingFromEdit, localRelationship: $localRelationship, comeFromBack: $comeFromBack)
        }
    }
    
    func selectController(){
        if relationship == "Single" {
            controller = .GenderInterest
        }else{
            controller = .SelectInviteJoin
        }
    }
}
