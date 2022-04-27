//
//  SocialFeedView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 25/04/21.
//

import SwiftUI

struct SocialFeedView: View {
    @State private var isSocialActive: Bool = true
    @Binding var menu: Int
    @Binding var userSearch : Bool
    @Binding var socialSuggestionInvite : Bool
    @Environment(\.presentationMode) var presentation
    @Binding var relationship : String
    @State private var isNotiActive  = false
    @State private var isChatActive  = false
    @ObservedObject private var notificationVM = NotificationViewModel()
    @State var notiCount = ""
    
    var body: some View {
        VStack() {
            HStack{
                if userSearch == false {
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .imageScale(.large)
                            .padding(.leading,10)
                            .padding(.top,10)
                            .frame(width: 40, height: 30)
                    }
                    Spacer()
                }
                
                Image("PlayDateSmall")
                    .padding(.top, userSearch ? 0 : 40)
                    .padding(.bottom,10)
                
                if userSearch == false {
                    Spacer()
                    Text("")
                }
            }
            
            HStack{
                Button(action: {
                    self.menu = 0
                    UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
                    self.socialSuggestionInvite = true
                }) {
                    Text("Social")
                        .fontWeight(.bold)
                        .foregroundColor(self.menu == 0 ? .white : .gray)
                        .padding()
                }
                .background(self.menu == 0 ?  Constants.AppColor.appPink : Color.white)
                .frame(height: 30)
                .clipShape(Capsule())
                
                if relationship == "Single"{
                    Button(action: {
                        self.menu = 1
                        UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
                        self.socialSuggestionInvite = true
                    }) {
                        Text("Match")
                            .fontWeight(.bold)
                            .foregroundColor(self.menu == 1 ? .white : .gray)
                            .padding()
                    }
                    .background(self.menu == 1 ?  Constants.AppColor.appPink : Color.white)
                    .frame(height: 30)
                    .clipShape(Capsule())
                }
                
                ZStack {
                    Button(action: {
                       // self.menu = 2
                        self.isChatActive = true
                        UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
                        self.socialSuggestionInvite = true
                    }) {
                        Text("Chat")
                            .fontWeight(.bold)
                            .foregroundColor(self.menu == 2 ? .white : .gray)
                            .padding()
                    }
                    .background(self.menu == 2 ?  Constants.AppColor.appPink : Color.white)
                    .frame(height: 30)
                    .clipShape(Capsule())
                    
                    NavigationLink(destination: InboxAndRequestView(),isActive: $isChatActive,label: {
                    })
                        .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                }
                Spacer()
                ZStack {
                    Button(action: {
                        self.isNotiActive = true
                        UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
                        self.socialSuggestionInvite = true
                    }) {
                        ZStack(alignment : .topTrailing){
                            Image("bel")
                                .padding()
                            if self.notiCount != "" && self.notiCount != "0"{
                                Text(self.notiCount)
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 10))
                                    .foregroundColor(.white)
                                    .padding(2)
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .background(Color("pink"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(.white), lineWidth: 4)
                                    )
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(height: 30)
                    NavigationLink(
                        destination: NotificationView(),
                        isActive: $isNotiActive,
                        label: {
                        })
                        .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                }
            }
            .padding(.horizontal)
            UsersView().padding([.leading,.trailing],16)
            
        }
        .navigationBarHidden(true)
        .onAppear{
            let isSuggestionOpen = UserDefaults.standard.bool(forKey: Constants.UserDefaults.isSuggestionOpen)
            if isSuggestionOpen {
                self.socialSuggestionInvite = false
            }else{
                self.socialSuggestionInvite = true
            }
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            relationship = (getRegisterDefaultData?["relationship"] ?? "") as! String
            print(relationship)
            self.GetNotificationCount()
        }
        .buttonStyle(PlainButtonStyle())
    }

    func GetNotificationCount(){
        DispatchQueue.global(qos: .background).async {
            self.notificationVM.GetNotificationCount { result, response,error in
                if response?.data?[0].totalUnreadNotification ?? 0 < 100{
                    self.notiCount = "\(response?.data?[0].totalUnreadNotification ?? 0)"
                }else{
                    self.notiCount = "99+"
                }
            }
        }
    }

}



