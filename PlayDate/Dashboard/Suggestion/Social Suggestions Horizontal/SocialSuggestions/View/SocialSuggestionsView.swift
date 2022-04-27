//
//  SocialSuggestionsView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 30/04/21.
//

import SwiftUI

@available(iOS 14.0, *)
struct SocialSuggestionsView: View {
    //MARK:- Properties
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var x :CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 100
    @State var op : CGFloat = 0
    @State var suggestionsData = [SocialSuggestionDataModel]()
    @State var isAddProfile = false
    @State var isMsg = false
    @Binding var showAlert: Bool
    @Binding var message :String
    @State var page = 1
    @State var limit = 100
    
    //MARK:- Body
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing:20){
                ForEach(self.suggestionsData) { i in
                    CardView1(isMsg: isMsg, isAddProfile: isAddProfile, data:i, friendRequest: i.friendRequest!,showAlert:$showAlert,message:$message)
                        .offset(x:self.x)
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged({ (value) in
                                    if value.translation.width > 0 {
                                        self.x = value.location.x
                                    }else {
                                        self.x = value.location.x - self.screen
                                    }
                                })
                                
                                .onEnded({ (value) in
                                    if value.translation.width > 0 {
                                        if value.translation.width > ((self.screen - 100) / 2) && Int(self.count) != 0 {
                                            
                                            self.count -= 1
                                            
                                            self.updateHeight(value:Int(self.count))
                                            self.x = -((self.screen + 20) * self.count)
                                        }else {
                                            self.x = -((self.screen + 20) * self.count)
                                        }
                                    }else {
                                        if -value.translation.width > ((self.screen - 100) / 2) && Int(self.count) != (self.suggestionsData.count - 1) {
                                            
                                            self.count += 1
                                            self.updateHeight(value:Int(self.count))
                                            self.x = -((self.screen + 20) * self.count)
                                        }else {
                                            self.x = -((self.screen + 20) * self.count)
                                        }
                                    }
                                })
                        )
                }
            }
            .frame(width:UIScreen.main.bounds.width)
            .offset(x:self.op)
            Spacer()
            
            ActivityLoader(isToggle: $socialSuggestionListVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .animation(.spring())
        .onAppear{
            self.GetSuggestionsListService()
        }
        
    }
    
    //MARK:- Functions
    func updateHeight(value : Int) {
        for i in 0..<suggestionsData.count {
            suggestionsData[i].show = false
        }
        suggestionsData[value].show = true
    }
    
    //MARK:- Call Api
    func GetSuggestionsListService() {
        socialSuggestionListVM.GetSuggestionsListService(self.limit, page: self.page, filter: "") { result, responce,error  in
            if result == strResult.success.rawValue{
                self.suggestionsData = responce?.data ?? []
                print(self.suggestionsData)
                if suggestionsData.count != 0 {
                    self.op = ((self.screen + 20) * CGFloat(self.suggestionsData.count / 2)) - (self.suggestionsData.count % 2 == 0 ? ((self.screen + 20) / 2) : 0)
                }
                //                let arr = responce?.data ?? []
                //                print(arr.count)
                //                for i in 0..<arr.count {
                //                    self.suggestionsData.append(arr[i])
                //                }
            }else if result == strResult.error.rawValue{
                self.message = responce?.message ?? ""
                self.showAlert = true
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

import SDWebImageSwiftUI
struct CardView1 : View {
    //MARK:- Properties
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var isMsg : Bool
    @State var isAddProfile : Bool
    @State private var error: Bool = false
    var data : SocialSuggestionDataModel
    var friendRequest : [FriendRequest]
    @State private var activeAlert: ActiveAlert = .error
    @Binding var showAlert: Bool
    @Binding var message :String
    @State var isChatActive = false
    
    //MARK:- Body
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            HStack{
                Image("")
                Spacer()
            }
            
            if data.profilePicPath == "" || data.profilePicPath == nil{
                Image("profileplaceholder")
                    .resizable()
                    .cornerRadius(30)
                    .clipped()
                    .padding(.top,20)
                    .padding(.leading,30)
                    .padding(.trailing,30)
                    .padding(.bottom,20)
            }else {
                WebImage(url: URL(string: data.profilePicPath ?? ""))
                    .resizable()
                    .cornerRadius(30)
                    .clipped()
                    .padding(.top,20)
                    .padding(.leading,30)
                    .padding(.trailing,30)
                    .padding(.bottom,20)
            }
            
            Text(data.username ?? "")
                .fontWeight(.heavy)
                .font(Font.system(size: 16.5))
                .padding(.bottom, 5)
            
            HStack(spacing:70){
                Button {
                    self.PostAddFriendRequestService()
                } label: {
                    Image(self.isAddProfile ? "suggestionAdded" : "suggessionAAD")
                        .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .frame(width:30,height:30)
                    
                }
                
                Button {
                    
                    if  data.chatStatusFrom?.count == 0  {
                        self.addchatrequest()
                    }else if data.chatStatusFrom?.count == 0 {
                        self.addchatrequest()
                    }else{
                        if data.chatStatusTo?.count != 0{
                            if data.chatStatusTo?[0].activeStatus == "Active"{
                                self.isChatActive = true
                            }
                        }else if data.chatStatusFrom?.count != 0{
                            if data.chatStatusFrom?[0].activeStatus == "Active"{
                                self.isChatActive = true
                            }
                        }
                    }
                    
                } label: {
                    
                    Image(isMsg ? "chat_Pink" : "chat_gray")
                        .resizable()
                        .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .frame(width:40,height:30)
                }
            }
            .padding(.bottom,16)
            ActivityLoader(isToggle: $socialSuggestionListVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            print(UIScreen.main.bounds.height - 380)
            if data.friendRequest?.count == 0 {
                self.isAddProfile = false
            }else {
                print(data.friendRequest?[0].status ?? 0)
                self.isAddProfile = true
            }
            
            if data.chatStatusTo?.count != 0{
                if data.chatStatusTo?[0].activeStatus == "Active"{
                    self.isMsg = true
                }
            }else if data.chatStatusFrom?.count != 0{
                if data.chatStatusFrom?[0].activeStatus == "Active"{
                    self.isMsg = true
                }
            }else {
                self.isMsg = false
            }
        }
        .frame(width: UIScreen.main.bounds.width-100, height: data.show  ? (UIScreen.main.bounds.height - 400) :  UIScreen.main.bounds.height - 400)
        
        .overlay(
            RoundedRectangle(cornerRadius: 30).stroke(Constants.AppColor.appPink, lineWidth: 2)
        )
    }
    
    //MARK:- Call Api
    func PostAddFriendRequestService() {
        
        socialSuggestionListVM.PostAddRemoveFriendRequestService(id: data.id ?? "", type: "AddFriend") { result, responce,error  in
            
            if result == strResult.success.rawValue{
                self.isAddProfile = true
                self.message = responce?.message ?? ""
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.message = responce?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    func addchatrequest(){
        socialSuggestionListVM.AddChatRequestService(data.id ?? "") { result, responce,error  in
            
            self.message = responce?.message ?? ""
            if result == strResult.success.rawValue{
                self.showAlert = true
                self.isMsg = true
            }else if result == strResult.error.rawValue{
                self.showAlert = true
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
