//
//  SheetView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//

import SwiftUI

struct SheetView: View {
    
    @State var isShown = false
    @State var textFieldVal = ""
    @State var filters:[String] = []
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    @State private var message = ""
    @State private var showAlert: Bool = false
    @Binding var showSheet : Bool
    @State var selectedfeed : SocialFeedData?
    @State var isDeleteNotiOpen = false
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var isOn = false
    @State var postId : String
    @Binding var status : Int
    @State var apiStatus = 0
    @State var isMyPost = false
    @State var height = CGFloat()
    @State var comeFrom = false
 
    
    var body: some View {
        ZStack{
            HalfModalView(isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen, modalHeight: $height, color: Color("darkgray")){
                
                VStack(spacing:15){
                    Image("LineNotch")
                        //.frame(height: 10)
                        .padding(.bottom,20)
                    
                    if self.isMyPost {
                        Toggle(isOn: self.$show1, label: {
                            Text("")
                                .font(Font.system(size: 12.5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .onAppear{
                                    self.height = self.height + 50.0

                                }
                        })
                        .toggleStyle(
                            ColoredToggleStyle(label: "Turn Posts Notification OFF",
                                               onColor: .white,
                                               offColor: .white,
                                               onThumbColor:  ((selectedfeed?.notifyStatus ?? "") == "On") ? Constants.AppColor.appPink : Color.gray, isOn: $isOn,postId: $postId, apiStatus: $apiStatus, comeFromComment: $comeFrom))
                        .onChange(of: apiStatus) { (value) in
                            if apiStatus == 1 {
                            }else {
                                
                            }
                            self.status = apiStatus
                        }
                    }
                    
                    if self.isMyPost == false{
                        Button(action: {
                            // self.show3.toggle()
                            GetBlockUserService()
                        }, label: {
                            HStack {
                                Text("Block User")
                                    .font(Font.system(size: 12.5))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Image("block")
                            }.onAppear{
                                self.height = self.height + 50.0                            }
                        })
                    }
                    
                    if self.isMyPost {
                        Button(action: {
                            GetDeletePostService()
                        }, label: {
                            HStack {
                                Text("Delete Post")
                                    .font(Font.system(size: 12.5))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Image("Icon metro-bin")
                            }.onAppear{
                                self.height = self.height + 50.0
                            }
                        })
                    }
                }
                .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
                .background(Color.clear)
                .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
                .padding(.horizontal)
                .onChange(of: self.height , perform: { value in
                    print(height)
                })
            }
            .onChange(of: self.isShown , perform: { value in
                print(apiStatus)
                self.status = apiStatus
                if !self.isShown{
                    self.isShown = false
                    self.showSheet = false
                }
            })
            
            
            .onAppear{
                self.height = 70.0
                print(selectedfeed?.postId ?? "")
                postId = selectedfeed?.postId ?? ""
                postId = selectedfeed?.postId ?? ""
                print(status)
                if (selectedfeed?.notifyStatus ?? "") == "On" {
                    self.isOn = true
                }else {
                    self.isOn = false
                }
                if selectedfeed?.userId ?? "" == UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""{
                    self.isMyPost = true
                }else {
                    self.isMyPost = false
                }
                print(height)
            }
        }
        .navigationBarHidden(true)
    }
    
    //MARK:- Call Api
    func GetBlockUserService() {
        SocailFeedVM.GetBlockUserService(toUserId : selectedfeed?.userId ?? "", action: "Block") { result, responce, error in
            
            if result == strResult.success.rawValue{
                self.status = 1
            }else if result == strResult.error.rawValue{
                self.status = 0
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    
    func GetDeletePostService() {
        SocailFeedVM.GetDeletePostService(postId : selectedfeed?.postId ?? "") { result, responce, error in
            if result == strResult.success.rawValue{
                self.message = responce?.message ?? ""
                    self.status = 1
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.status = 0
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


struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var onThumbColor = Color.white
    var offThumbColor = Color.gray
    var width = 40.0
    var height = 20.0
    var cornerRadius = 10.0
    @Binding var isOn : Bool
    @Binding var postId : String
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @ObservedObject var CommentVM: CommentViewModel = CommentViewModel()
    @Binding var apiStatus : Int
    @Binding var comeFromComment : Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
                .font(Font.system(size: 12.5))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                
                if self.isOn {
                    if comeFromComment {
                        GetPostCommentOnOffService(commentStatus: "0"){ (status) in
                            if status == 1 {
                                
                                self.isOn = false
                            }
                        }
                    }else {
                        GetPostNotificationOnOffService(postStatus: "Off"){ (status) in
                            if status == 1 {
                                
                                self.isOn = false
                            }
                        }
                    }
                    
                }else {
                    
                    if comeFromComment {
                        GetPostCommentOnOffService(commentStatus: "1"){ (status) in
                            if status == 1 {
                                
                                self.isOn = true
                            }
                        }
                    }else {
                        GetPostNotificationOnOffService(postStatus: "On"){ (status) in
                            if status == 1 {
                                
                                self.isOn = true
                            }
                        }
                    }
                    
                }
                
                
                
            } )
            {
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius), style: .circular)
                    .fill(self.isOn ? onColor : offColor)
                    .frame(width: CGFloat(width), height: CGFloat(height))
                    .overlay(
                        Circle()
                            .fill(self.isOn ? onThumbColor : offThumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: self.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
                
            }
        }.onAppear{
            //self.isOn = configuration.isOn
        }
        //.font(.title)
        //.padding(.horizontal)
    }
    
    //MARK:- Call Api
    func GetPostNotificationOnOffService(postStatus: String,completion: @escaping (Int) -> ()) {
        
        SocailFeedVM.GetPostNotificationOnOffService(postId: postId,status: postStatus) { result, responce, error in
            if result == strResult.success.rawValue{
                self.apiStatus = 1
                if postStatus == "On" {
                    self.isOn = true
                }else {
                    self.isOn = false
                }
            }else if result == strResult.error.rawValue{
                self.apiStatus = 0
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
        }
    }
    
    func GetPostCommentOnOffService(commentStatus: String,completion: @escaping (Int) -> ()) {
        CommentVM.PostCommentOnOffService(postId: postId,commentStatus: commentStatus) { result, responce, error in
            if result == strResult.success.rawValue{
                self.apiStatus = 1
                if commentStatus == "1" {
                    self.isOn = true
                }else {
                    self.isOn = false
                }
            }else if result == strResult.error.rawValue{
                self.apiStatus = 0
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
        }
    }
}
