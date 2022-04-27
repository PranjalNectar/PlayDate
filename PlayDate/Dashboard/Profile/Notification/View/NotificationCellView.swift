//
//  NotificationCellView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/05/21.
//
import SwiftUI
import SDWebImageSwiftUI

struct NotificationCellView: View {
    //MARK:- Properties
    let data : NotiDataModel
    @State private var suggestionImage = ""
    @State private var suggestionName = ""
    @State private var friendRequest =  [NotiFriendRequest]()
    @State private var userInfo =  [UserInfo]()
    @State var requestID = ""
    @State private var message = ""
    @State private var showAlert: Bool = false
    @Binding var status : Int
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var notificationVM = NotificationViewModel()
    @State var postPic = ""
    
    init(data:NotiDataModel,status:Binding<Int>) {
        self._status = status
        self.data = data
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().separatorStyle = .none
    }
    
    //MARK:- Body
    var body: some View {
        Button (action: {  }){
            VStack(alignment:.leading,spacing:0){
                HStack(){
                    if suggestionImage == ""{
                        
                        Image("profileplaceholder")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                            .clipped()
                        
                    }else {
                        WebImage(url: URL(string: suggestionImage ))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                    }
                    
                    HStack(spacing:2){
                        Text(suggestionName )
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .fontWeight(.bold)
                            .font(.custom("Arial", size: 14))

                        Text(data.notificationMessage ?? "")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .font(.custom("Arial", size: 14))
                    }
                    
                    if data.patternID == "FeedLike" || data.patternID == "Post" {
                        WebImage(url: URL(string: postPic))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity)
                            //.aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30, alignment: .leading)
                        
                    }else if data.patternID == "FeedComment"{
                        
                        Image("notificationComment")
                    }else if data.patternID == "MatchRequest" || data.patternID == "DatePartner"{
                        Image("PlayDateHeart")
                    }
                }
                
                if data.patternID == "Friend" || data.patternID == "Match" || data.patternID == "Relationship"{
                    HStack(spacing:20){
                        Spacer()
                        ZStack{
                            Button {
                                callFriendMatchRelationshipUpdateApi(status: "Verified"){ (status) in
                                    self.showAlert = true
                                }
                            } label: {
                                Image("Icon awesome-check")
                            }.padding()
                            
                        } .background(Constants.AppColor.appPink)
                        .frame(width: 35, height: 25)
                        .cornerRadius(12.5)
                        
                        ZStack{
                            Button {
                                callFriendMatchRelationshipUpdateApi(status: "Rejected"){ (status) in
                                    self.showAlert = true
                                }
                            } label: {
                                Image("Icon metro-cancel")
                            }.padding()
                            
                            
                        } .background(Constants.AppColor.appPink)
                        .frame(width: 35, height: 25)
                        .cornerRadius(12.5)
                    }
                }
            
                if data.patternID == "ChatRequest"{
                    HStack(spacing:20){
                        Spacer()
                        ZStack{
                            Button {
                                
                                self.UpdateChatRequestService(status: "Active", requestId : data.chatRequest?[0].id ?? "")
                            } label: {
                                Image("Icon awesome-check")
                            }.padding()
                        } .background(Constants.AppColor.appPink)
                        .frame(width: 35, height: 25)
                        .cornerRadius(12.5)
                        
                        ZStack{
                            Button {
                                self.UpdateChatRequestService(status: "Reject", requestId : data.chatRequest?[0].id ?? "")
                            } label: {
                                Image("Icon metro-cancel")
                            }.padding()
                        }
                        .background(Constants.AppColor.appPink)
                        .frame(width: 35, height: 25)
                        .cornerRadius(12.5)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            if data.patternID == "Friend" || data.patternID == "Match" {
                for item in 0..<(data.friendRequest ?? [NotiFriendRequest]()).count{
                    requestID = data.friendRequest?[item].requestId ?? ""
                    let userInfo = data.friendRequest?[item].userInfo
                    
                    for user in 0..<(userInfo ?? [UserInfo]()).count{
                        suggestionImage = userInfo?[user].profilePicPath ?? ""
                        suggestionName = userInfo?[user].username ?? ""
                        
                    }
                }
            }else if data.patternID == "FeedLike" || data.patternID == "FeedComment" || data.patternID == "Post"{
                for j in 0..<(data.userInformation ?? [NotiUserInformation]()).count{
                    suggestionImage = data.userInformation?[j].profilePicPath ?? ""
                    suggestionName = data.userInformation?[j].username ?? ""
                }
                
                for post in 0..<(data.postInfo ?? [NotiPostInfo]()).count{
                    
                    let media = data.postInfo?[post].media
                    for mediaData in 0..<(media ?? [NotiMedia]()).count{
                        let mediaType = media?[mediaData].mediaType ?? ""
                        if mediaType == "Video" {
                            postPic = media?[mediaData].mediaThumbName ?? ""
                        }else{
                            postPic = media?[mediaData].mediaFullPath ?? ""
                        }
                        
                    }
                }
            }else if  data.patternID == "Relationship" {
                for item in 0..<(data.relationRequest ?? [NotiRelationRequest]()).count{
                    requestID = data.relationRequest?[item].requestId ?? ""
                    saveRelationshipRequestID(requestID: requestID)
                    let userInfo = data.relationRequest?[item].userInfo
                    
                    for user in 0..<(userInfo ?? [UserInfo]()).count{
                        suggestionImage = userInfo?[user].profilePicPath ?? ""
                        suggestionName = userInfo?[user].username ?? ""
                    }
                }
            }else if data.patternID == "FriendAccepted" || data.patternID == "DatePartner" || data.patternID == "MatchRequest" || data.patternID == "RelationAccepted"{
                
                for j in 0..<(data.userInformation ?? [NotiUserInformation]()).count{
                    suggestionImage = data.userInformation?[j].profilePicPath ?? ""
                    suggestionName = data.userInformation?[j].username ?? ""
                }
            }else if data.patternID == "ChatRequest" || data.patternID ==  "ChatAccepted" {
                for j in 0..<(data.userInformation ?? [NotiUserInformation]()).count{
                    suggestionImage = data.userInformation?[j].profilePicPath ?? ""
                    suggestionName = data.userInformation?[j].username ?? ""
                    //data.chat
                }
            }
        }
    }
    
    
    //MARK:- Call Api
    func callFriendMatchRelationshipUpdateApi(status:String,completion: @escaping (Int) -> ()) {
        notificationVM.callFriendMatchRelationshipUpdateApi(requestID, status: status,patternID:data.patternID ?? "") { result, response,error in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.status = 1
                self.showAlert = true
                if data.patternID == "Relationship" && status == "Verified" {
                    
                    var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                    registerDefaultData?["relationship"] = "Taken"
                    UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                }
            }else if result == strResult.error.rawValue{
                self.status = 0
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
    
    func UpdateChatRequestService(status : String, requestId : String){
        notificationVM.UpdateChatNotificationApi(requestId, status: status) { result, response,error in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.showAlert = true
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


