//
//  InboxAndRequestView.swift
//  PlayDate
//
//  Created by Pranjal on 21/06/21.
//

import SwiftUI

struct InboxAndRequestView: View {
        
    @ObservedObject private var ChatInboxVM = ChatInboxViewModel()
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @Environment(\.presentationMode) var presentation
    @State var arrInboxUser  : [InboxUserListData] = []
    @State var selectedItem : InboxUserListData?
    @State var txtSearch  = ""
    @State var isInboxOptionPopup = false
    @State var isPopupShow = false
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var isChatActive = false
    @State var selectedOption : Int = 0
    let socket = SocketIOManager.shared
    @State var isActive = false
    @State var friendRequest : [FriendRequest] = []
    @State var id : String = ""
    @State var friendId : String = ""
    @State var feeddata : SocialFeedData?
    @State var img : UIImage? = UIImage()
    @State var profile1 = [Profile1]()
    @State var profile2 = [Profile2]()
    @State var relationship = ""
    @State private var isNotiActive  = false
    @State var notiCount = ""
    @ObservedObject private var notificationVM = NotificationViewModel()
    @State var page = 1
    @State var limit = 20
    @State var chatid : String?
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image("bback")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                    }
                    .padding()
                    Spacer()
                    Spacer()
                    Image("PlayDateSmall")
                    Spacer()
                    ZStack{
                        Button(action: {
                            self.isNotiActive = true
                        }, label: {
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
                        })
                        
                        NavigationLink(
                            destination: NotificationView(),
                            isActive: $isNotiActive,
                            label: {
                            })
                            .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                    }
                    .padding()
                }.padding(.horizontal)
                
                HStack{
                    Image("serach")
                        .padding([.leading,.top,.bottom])
                    
                    ZStack(alignment: .leading) {
                        if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                        
                        TextField("Search here...", text: $txtSearch)
                            .onChange(of: txtSearch) {_ in
                                // callRestaurantApi(filter: txtSearch)
                            }
                            .foregroundColor(Color.white)
                            .accentColor(.white)
                    }
                }
                .frame( height: 50)
                .background(Constants.AppColor.applightPink)
                .cornerRadius(25)
                .padding(.horizontal)

                ScrollView{
                    ForEach(self.arrInboxUser.filter{($0.fromUser?[0].username?.contains(self.txtSearch.lowercased()))! || txtSearch.isEmpty} )
                    { item in
                        if item.fromUser?.count != 0{
                            ChatInboxView(isPopupShow: $isPopupShow, InboxUserData: item,selectedData: $selectedItem)
                                // .modifier(InboxChatBGModifier(checked: item.id == self.selectedItem?.id))
                                .padding(.top, 8)
                                
                                .onChange(of: isPopupShow){_ in
                                    if self.isPopupShow{
                                        self.isInboxOptionPopup = true
                                        self.isPopupShow = false
                                    }
                                }
                                //                            .onLongPressGesture {
                                //                                self.isInboxOptionPopup = true
                                //                                self.selectedItem = nil
                                //                                self.selectedItem = item
                                //                            }
                                .onTapGesture {
                                    self.selectedItem = nil
                                    self.selectedItem = item
                                    self.isChatActive = true
                                }
                                .onAppear{
                                    if self.arrInboxUser.last?.id == item.id{
                                        if self.arrInboxUser.count > limit{
                                            self.page += 1
                                            self.GetChatUserList()
                                        }
                                    }
                                }
                        }
                    }
                }
                .animation(.spring(response: 0.3))
                .padding(.horizontal)
                NavigationLink(destination: MainChatWindow(OtherUserData : self.selectedItem),isActive: $isChatActive,label: {
                })
                
                NavigationLink(destination: ProfileView( friendId: $friendId, profileData: nil, isProfielOptionShow: .constant(false), comeFromProfileTab: .constant(false), isAlreadyFriend: .constant(true), suggestionListId: $id, suggestioFriendRequest: $friendRequest, ImageForCrop: $img, isProfileSheetShow: .constant(false), feedtoSheet: $feeddata, relationship: $relationship, profile1: profile1, profile2: profile2).navigationBarHidden(true), isActive: $isActive) {
                }
            }
            ActivityLoader(isToggle: $ChatInboxVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isInboxOptionPopup, content: {
            ChatInboxOptionPopup(isHide: $isInboxOptionPopup, selectedOption: $selectedOption)
                .background(BackgroundClearView())
        })
        .onAppear{
            self.arrInboxUser.removeAll()
            self.socket.Online_Offline()
            self.GetChatUserList()
            self.GetNotificationCount()
        }
        
        .onChange(of: self.selectedOption, perform: { value in
            if self.selectedOption == 1{
                self.DeleteChatRoom()
            }else if self.selectedOption == 2{
                self.Report_Block_UserService(action: "Block")
            }else if self.selectedOption == 3{
                self.Report_Block_UserService(action: "Report")
            }else if self.selectedOption == 4{
                self.id = self.selectedItem?.fromUser?[0].userId ?? ""
                self.isActive = true
            }
            self.selectedOption = 0
        })
    }
    
    func GetChatUserList(){
        self.ChatInboxVM.GetInboxUserListService(self.limit, page: self.page) { result, response,error  in
            
            if result == strResult.success.rawValue{
                //print(response?.data?.count ?? 0)
                //self.arrInboxUser = response?.data ?? []
                //print(self.arrInboxUser)
                let arr = response?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrInboxUser.append(arr[i])
                }
//                self.arrInboxUser = self.arrInboxUser.sorted(by:{
//                    common.getDateFromString(strDate: $0.chatMessage?[0].entryDate ?? "")  .compare(common.getDateFromString(strDate: $1.chatMessage?[0].entryDate ?? "")) == .orderedDescending
//                })
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
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
    
    func DeleteChatRoom(){
        self.ChatInboxVM.DeleteChatRoomService(self.selectedItem?.chatId ?? "") { result, responce, error in
            self.message = responce?.message ?? ""
            if result == strResult.success.rawValue{
                self.arrInboxUser.removeAll()
                self.GetChatUserList()
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
    
    
    func Report_Block_UserService(action : String) {
        print(self.selectedItem?.toUserId ?? "")
        self.SocailFeedVM.GetBlockUserService(toUserId : self.selectedItem?.fromUser?[0].userId ?? "", action: action) { result, responce, error in
            self.message = responce?.message ?? ""
            if result == strResult.success.rawValue{
                self.arrInboxUser.removeAll()
                self.GetChatUserList()
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

struct InboxChatBGModifier: ViewModifier {
    var checked: Bool = false
    func body(content: Content) -> some View {
        Group {
            if checked {
                ZStack(alignment: .trailing) {
                    content
                        .background(self.checked ? Constants.AppColor.applightPink : Constants.AppColor.appWhite )
                }
            } else {
                content
            }
        }
    }
}


