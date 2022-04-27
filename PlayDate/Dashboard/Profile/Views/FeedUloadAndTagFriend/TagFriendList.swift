//
//  TagFriendList.swift
//  PlayDate
//
//  Created by Pranjal on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct TagFriendList: View {
    @State var arrFriendData = [FriendData]()
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var txtSearch  = ""
    @Environment(\.presentationMode) var presentation
    @State var arrtages : [String] = []
    @State var arrname : [String] = []
    @State private var showAlert: Bool = false
    @State private var message = ""
    
    var body: some View {

        ZStack{
            VStack{
                HStack{
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image("bback")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .imageScale(.large)
                            .padding()
                    }
                    Spacer()
                }
                .padding()
                .frame(height : 44)
                
                Spacer()
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
                    }
                }
                .frame( height: 50)
                .background(Color("pink"))
                .cornerRadius(25)
                .padding()
                
                HStack{
                    Text("Your Friend")
                        .bold()
                        .font(.custom("Arial", size: 18.0))
                        .padding(.leading)
                    Spacer()
                }
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.arrFriendData.filter{($0.username ?? "").contains(self.txtSearch.lowercased()) || txtSearch.isEmpty} ) { item in
                        TagListView(friend: item, arrtages: $arrtages, arrname: $arrname)
                    }
                }
                .padding()
                VStack(alignment: .center){
                    Button(action: {
                        print(self.arrname.count)
                        print(self.arrtages.count)
                        UserDefaults.standard.set(nil, forKey:"tagUserids")
                        UserDefaults.standard.set(nil, forKey:"tagUsername")
                        UserDefaults.standard.set(self.arrtages, forKey:"tagUserids")
                        UserDefaults.standard.set(self.arrname, forKey:"tagUsername")
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Image("arrow")
                            .padding()
                            .frame(width : 60,height: 60)
                            .background(Color("pink"))
                            .cornerRadius(30)
                            .padding()
                    })
                    
                }
            }
            ActivityLoader(isToggle: $SocailFeedVM.loading)
        }
        .onAppear{
            self.GetFriendList()
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
    }
    
    func GetFriendList(){
        SocailFeedVM.GetFriendsService("100", page: "1"){ result, responce, error  in
            if result == strResult.success.rawValue{
                print(responce?.data?.count ?? 0)
                self.arrFriendData = responce?.data ?? []
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

struct TagListView: View {
    
    @State var indexs = 0
    @State var friend : FriendData
    @Binding var arrtages : [String]
    @Binding var arrname : [String]
    var body: some View {
        Button(action: {
            if self.friend.isSelected {
                self.friend.isSelected = false
                if self.arrtages.contains(self.friend.userId!){
                    self.arrtages.removeAll{ $0 == self.friend.userId! }
                    self.arrname.removeAll{ $0 == self.friend.username! }
                }
            }else{
                self.friend.isSelected = true
                self.arrtages.append(self.friend.userId ?? "")
                self.arrname.append(self.friend.username ?? "")
            }
           
        }, label: {
            HStack(spacing:15) {
                
                WebImage(url: URL(string: friend.profilePicPath ?? ""))
                    .resizable()
                    .placeholder(Image("profile"))
                    .frame(width: 50, height: 50)
                    .cornerRadius(8.0)
                
                Text(friend.username ?? "")
                    .foregroundColor(Constants.AppColor.appBlackWhite)
                    //.frame(width: 60, alignment: .center)
                    .font(.custom("Arial", size: 18.0))
                Spacer()
                if self.friend.isSelected {
                    Image("urpink")
                }
            }
        })
    }
}
