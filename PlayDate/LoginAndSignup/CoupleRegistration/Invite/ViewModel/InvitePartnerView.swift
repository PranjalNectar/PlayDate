//
//  InvitePartnerView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/06/21.
//

import SwiftUI

struct InvitePartnerView: View {
    @Environment(\.presentationMode) var presentation
    @State private var Authenticate: Bool = false
    @Binding var comingFromEdit: Bool
    @State var relationship = ""
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State private var message = ""
    @State private var error: Bool = false
    @State var c: AlertAction?
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @Binding var localRelationship : String
    @State private var showShareSheet: Bool = false
    @State var shareSheetItems: [Any] = []
    
    var body: some View {
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
            
            Image("love-letter")
            
            Spacer()
            
            Text("Invite Partner")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 20.0))
            Spacer()
            Text("Start a couple with your partner on PlayDate")
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 14.0))
                .padding([.leading,.trailing],40)
            
            Spacer()
            
            HStack(spacing:20.0){
                Button(action: {
                    self.showShareSheet = true
                }) {
                    ZStack{
                        Image("pinkCircleBG")
                            .resizable()
                            .frame(width: 70.0, height: 70.0)
                        
                        Image("messenger")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                    }
                }
                
                Button(action: {
                    self.showShareSheet = true
                }) {
                    ZStack{
                        Image("darkPinkCircleBG")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                        
                        Image("WhiteHeart")
                            .resizable()
                            .frame(width: 80.0, height: 70.0)
                    }
                }
                
                Button(action: {
                    self.showShareSheet = true
                }) {
                    ZStack{
                        Image("pinkCircleBG")
                            .resizable()
                            .frame(width: 70.0, height: 70.0)
                        
                        Image("Msg")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                    }
                }
            }
            Spacer()
            
            NavigationLink(destination:InviteSentView(comingFromEdit: $comingFromEdit), isActive: $Authenticate) {
                Button(action: {
                    self.UpdateUserProfielService()
                }) {
                    NextArrow()
                } .alert(isPresented: self.$error) {
                    Alert(title: Text(message))
                }
            }
        }.background(BGImage())
        .navigationBarHidden(true)
        .onAppear{
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            relationship = getRegisterDefaultData!["relationship"] as! String
            
           let inviteLink = getRegisterDefaultData!["inviteLink"] ?? ""
            print("inviteLink=====\(inviteLink)")
            
            self.shareSheetItems = [inviteLink]
        }
        
        .sheet(isPresented: $showShareSheet, content: {
            
            ActivityViewController(activityItems: self.$shareSheetItems)
        })
    }
    
    func actionSheet() {
            guard let data = URL(string: "https://www.apple.com") else { return }
            let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: relationship, type: "relationship") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.Authenticate = true
                self.error = false
                UserDefaults.standard.set("genderInterest", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["relationship"] = localRelationship
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

