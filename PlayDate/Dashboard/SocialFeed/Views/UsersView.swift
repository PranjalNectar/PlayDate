//
//  UsersView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 25/04/21.
//


import SwiftUI
import SDWebImageSwiftUI


struct ListView: View {
    
    @State var indexs = 0
    @State var friend : FriendData
    @State var isActive = false
    @State var friendRequest : [FriendRequest]
    @State var id : String
    @State var friendId : String
    @State var feeddata : SocialFeedData?
    @State var img : UIImage? = UIImage()
    @State var profile1 = [Profile1]()
    @State var profile2 = [Profile2]()
    @State var relationship = ""
    
    var body: some View {
        ZStack{
            
            NavigationLink(destination: ProfileView( friendId: $friendId, profileData: nil, isProfielOptionShow: .constant(false), comeFromProfileTab: .constant(false), isAlreadyFriend: .constant(true), suggestionListId: $id, suggestioFriendRequest: $friendRequest, ImageForCrop: $img, isProfileSheetShow: .constant(false), feedtoSheet: $feeddata, relationship: $relationship, profile1: profile1, profile2: profile2).navigationBarHidden(true), isActive: $isActive) {
            }
            .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
            
            Button(action: {
                self.isActive.toggle()
            }, label: {
                VStack(alignment: .center ,spacing:0) {
                    WebImage(url: URL(string: friend.profilePicPath ?? ""))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity).accentColor(.pink)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    Text(friend.username ?? "")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .frame(width: 60, alignment: .center)
                        .font(Font.system(size: 12.5))
                        .lineLimit(1)
                }
            })
            
        }
       
    }
}

struct UsersView: View {
    
    @State var arrFriendData = [FriendData]()
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var isActive = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack( spacing:15) {
                NavigationLink(destination: UserSearchListView()
                                .ignoresSafeArea()
                                .navigationBarHidden(true), isActive: $isActive) {
                    Button(action: {
                        self.isActive = true
                    }, label: {
                        VStack{
                            Image("serach")
                                .frame(width: 60, height: 60)
                                .background(Constants.AppColor.applightPink)
                                .clipShape(Circle())
                            
                            Text("")
                                .foregroundColor(.black)
                                .frame(width: 60, alignment: .center)
                                .font(Font.system(size: 12.5))
                        }
                    })
                }
                
                ZStack{
                    if self.arrFriendData.count == 0{
                        Text("Connect With Friends, Search Them Now")
                            .foregroundColor(.gray)
                            .font(Font.system(size: 12))
                            .padding(.bottom)
                    }else{
                        HStack{
                            ForEach(self.arrFriendData) { item in
                                // ListView(friend: item)
                                ListView(friend: item, friendRequest: [FriendRequest](), id: item.userId ?? "", friendId: item.friendId ?? "" )
                            }
                        }
                    }
                }
              
            }
        }
        .padding(.top,10)
        .onAppear{
            self.GetFriendList()
        }
        
    }
    
    func GetFriendList(){
        SocailFeedVM.GetFriendsService("100", page: "1") { result, response, error  in
            if result == strResult.success.rawValue{
                print(response?.data?.count ?? 0)
                self.arrFriendData = response?.data ?? []
            }else if result == strResult.error.rawValue{
//                self.message = responce?.message ?? ""
//                self.showAlert = true
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
