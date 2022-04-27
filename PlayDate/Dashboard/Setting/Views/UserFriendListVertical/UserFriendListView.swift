//
//  UserFriendListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 20/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserFriendListView: View {
    //MARK:- Properties
    @State var txtSearch  = ""
    @State var arrFriendData = [FriendData]()
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @ObservedObject var userFriendVM: UserFriendListViewModel = UserFriendListViewModel()
    @Environment(\.presentationMode) var presentation
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State private var isActive: Bool = false
    @Binding var comingFromEdit: Bool
    
    //MARK:- Body
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment:.leading,spacing: 20) {
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .imageScale(.large)
                            .padding()
                            .padding(.top,40)
                            .padding(.leading)
                    }
                    HStack{
                        Image("serach")
                            .padding([.leading,.top,.bottom])
                        
                        ZStack(alignment: .leading) {
                            if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                            
                            TextField("", text: $txtSearch)
                                .onChange(of: txtSearch) {_ in
                                    // callSuggestionsHorizontalApi(filter: txtSearch)
                                    self.GetFriendList()
                                }
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame( height: 50)
                    .background(Constants.AppColor.applightPink)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Constants.AppColor.appPink, lineWidth:1)
                    )
                    .cornerRadius(25)
                    .padding([.bottom,.leading,.trailing])
                    // SearchBar(text: $txtSearch)
                    
                    Text("Your Friends")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 17.5))
                        .padding(.leading,10)
                        .padding(.trailing,10)
                    
                    ZStack {
                        
                        List{
                            ForEach(self.arrFriendData.filter({$0.username!.contains(txtSearch.lowercased()) || txtSearch.isEmpty} )) { item in
                                
                                Button(action: {
                                    self.PostCreateRelationship(id: item.userId ?? "")
                                    
                                }) {
                                    HStack(){
                                        HStack{
                                            ZStack{
                                                if (item.profilePicPath ?? "") == "" { //|| (item.profilePicPath ?? "") == nil
                                                    Image("profileplaceholder")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .cornerRadius(10)
                                                        .clipped()
                                                }else {
                                                    WebImage(url: URL(string: (item.profilePicPath ?? "") ))
                                                        
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .cornerRadius(10)
                                                        .clipped()
                                                }
                                            }
                                            
                                            Text(item.username ?? "")
                                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                                .fontWeight(.bold)
                                                .font(Font.system(size: 13.5))
                                        }
                                    }.onTapGesture {
                                        
                                        self.PostCreateRelationship(id: item.userId ?? "")
                                        
                                    }
                                }
                            }
                        }
                    }.navigationBarHidden(true)
                    
                    
                    
                } .navigationBarHidden(true)
                
                HStack{

                    NavigationLink(destination: InviteView(comFrom: true), isActive: $isActive) {
                        Button(action: {
                            self.isActive = true
                            
                        }, label: {
                            Text("Not on PlayDate?")
                                .foregroundColor(Color.white)
                        })
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame( height: 50)
                .background(Constants.AppColor.appPink)
                
                .cornerRadius(25)
                .padding([.leading,.trailing])
                .padding(.bottom,4)
                
                
            }
            ActivityLoader(isToggle: $SocailFeedVM.loading)
            
        }.navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .padding(.bottom,2)
        .alert(isPresented:  $showAlert, title: Constants.AppName, message: self.message, dismissButton: .default(Text("Ok")){ presentation.wrappedValue.dismiss() })
        .onAppear{
            self.GetFriendList()
        }
    }
    
    
    //MARK:- Call Api
    func GetFriendList(){
        SocailFeedVM.GetFriendsService("200", page: "1") { result, response, error  in
            if result == strResult.success.rawValue{
                print(response?.data?.count ?? 0)
                self.arrFriendData = response?.data ?? []
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
    
    func PostCreateRelationship(id : String
    ){
        userFriendVM.PostCreateRelationshipsService(toUserId:id) { result, response, error  in
            if result == strResult.success.rawValue{
                print(response?.data?.count ?? 0)
                self.message = response?.message ?? ""
                self.showAlert = true
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
}
