//
//  SuggestionCellView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 01/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SuggestionCellView: View {
    //MARK:- Properties
    let suggestionImage : String
    let suggestionName : String
    @State var friendRequest : [FriendRequest]
    @State var id : String
    @State private var message = ""
    @State private var error: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var showAlert: Bool = false
    @State var img : UIImage? = UIImage()
    @State var friendId = ""
    @State var isAddProfile = false
    @State var isShowDimond = false
    @State var isActive = false
    @State var feeddata : SocialFeedData?
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var relationship = ""
    
    
    //MARK:- Body
    var body: some View {
        ZStack{
            NavigationLink(destination: ProfileView( friendId: $friendId, profileData: nil, isProfielOptionShow: .constant(false), comeFromProfileTab: .constant(false), isAlreadyFriend: .constant(false), suggestionListId: $id, suggestioFriendRequest: $friendRequest, ImageForCrop: $img, isProfileSheetShow: .constant(false), feedtoSheet: $feeddata, relationship: $relationship, profile1: [Profile1](), profile2: [Profile2]()).navigationBarHidden(true), isActive: $isActive) {
            }
            .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
            
            Button (action: {
                self.isActive = true
            }){
                HStack(){
                    HStack{
                        ZStack{
                            if suggestionImage == ""{
                                Image("profileplaceholder")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .clipped()
                            }else {
                                WebImage(url: URL(string: suggestionImage ))
                                    
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                    .clipped()
                            }
                        }
                        
                        Text(suggestionName)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .fontWeight(.bold)
                            .font(Font.system(size: 13.5))
                    }
                    Spacer()
                    Button {
                        PostAddFriendRequestService()
                    } label: {
                        Image(isAddProfile ? "suggestionAdded" : "suggessionAAD")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .onAppear{
                                if friendRequest.count == 0 {
                                    self.isAddProfile = false
                                }else {
                                    print( friendRequest[0].status!)
                                    self.isAddProfile = true
                                }
                            }
                    }

                    
                }
                
            }
            ActivityLoader(isToggle: $socialSuggestionListVM.loading)
            
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
    
    //MARK:- Call Api
    func PostAddFriendRequestService() {
    
            socialSuggestionListVM.PostAddRemoveFriendRequestService(id: id, type: "AddFriend") { result, responce,error  in
               
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
}


struct SuggestedList : View {
    //MARK:- Properties
    @State var isCall = false
    @Environment(\.presentationMode) var presentation
    @Binding var filter: String
    @State private var showAlert: Bool = false
    @State private var message = ""
    var friendRequest = [FriendRequest]()
    @State var arrdata = [SocialSuggestionDataModel]()
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var page = 1
    @State var limit = 10
    
    init(filter: Binding<String>) {
        self._filter = filter
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .none
        UITableView.appearance().backgroundColor = .none
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    //MARK:- Body
    var body: some View {
        ZStack {
            List{
                ForEach(self.arrdata) { item in
                    SuggestionCellView(suggestionImage: item.profilePicPath ?? "", suggestionName: item.username ?? "", friendRequest: item.friendRequest ?? [FriendRequest](),id : item.id ?? "")
                    
                        .onAppear{
                            if self.arrdata.last?.id == item.id{
                                self.page += 1
                                self.GetSuggestionsListService()
                            }
                        }
                }
            }
            ActivityLoader(isToggle: $socialSuggestionListVM.loading)
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            if self.isCall == false{
                print("call service")
                self.GetSuggestionsListService()
                self.isCall = true
            }
        }
        .onDisappear{
            self.isCall = false
        }
    }
    
    //MARK:- Call Api
    func GetSuggestionsListService() {
        socialSuggestionListVM.GetSuggestionsListService(self.limit, page: self.page, filter: filter) { result, responce,error  in
            if result == strResult.success.rawValue{
                //self.arrdata = responce?.data ?? []
                let arr = responce?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrdata.append(arr[i])
                }
                print(self.arrdata.count)
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
