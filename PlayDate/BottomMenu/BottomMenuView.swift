//
//  BottomMenuView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 27/04/21.
//

import SwiftUI
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import  SDWebImageSwiftUI
struct BottomMenuView: View {

    var tabs = ["social","coupan","heart","support","profile"]
    @State var selectedTab = "social"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    @State var isProfielOptionShow = false
    @State var isDashboardSheetShow = false
    @State var selectedfeed : SocialFeedData?
    @State var suggestionListId = ""
    @State var suggestioFriendRequest = [FriendRequest]()
    @State var friendId = ""
    @State var postId = ""
    @State var isCall = false
    @State var status = 0
    @State var sendImageToProfiel: UIImage? = UIImage()
    @State var profile1 = [Profile1]()
    @State var profile2 = [Profile2]()
    @State var isShown = false
    @State var relationship = ""
    
    var body: some View {
        //if !self.isProfielOptionShow
        ZStack(alignment:Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection:$selectedTab){
                
                DashBoardView(isDashboardSheetShow: $isDashboardSheetShow, isCall: $isCall, feedtoSheet: $selectedfeed, apistatus: $status).tag("social")
                   
                    .onChange(of: isCall) { (value) in
                        if status == 1 {
                            self.isCall = false
                            self.status = 1
                        }else {
                            self.isCall = true
                            self.status = 0
                        }
                        
                    }
                
                if SharedPreferance.getAppUserType() == UserType.Business.rawValue{
                    MainBusinessCouponView().tag("coupan")
                }else{
                    CoupanMainView().tag("coupan").ignoresSafeArea()
                }
            
                if SharedPreferance.getAppUserType() == UserType.Business.rawValue{
                    ProfileView( friendId: $friendId, profileData: nil, isProfielOptionShow: $isProfielOptionShow, comeFromProfileTab: .constant(true), isAlreadyFriend: .constant(false), suggestionListId: $suggestionListId, suggestioFriendRequest: $suggestioFriendRequest, ImageForCrop: $sendImageToProfiel, isProfileSheetShow: $isDashboardSheetShow, feedtoSheet: $selectedfeed, relationship: $relationship, profile1: profile1, profile2: profile2).tag("heart")
                        .onAppear{
                            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                           
                            relationship = (getRegisterDefaultData?["relationship"] ?? "") as! String
                            print(selectedTab)
                            if selectedTab == "heart"{
                                self.isProfielOptionShow = true
                            }
                            print(relationship)
                        }
                }else{
                    DateHomeView().tag("heart")
                    
                }
                SettingView().tag("support")
                
                ProfileView( friendId: $friendId, profileData: nil, isProfielOptionShow: $isProfielOptionShow, comeFromProfileTab: .constant(true), isAlreadyFriend: .constant(false), suggestionListId: $suggestionListId, suggestioFriendRequest: $suggestioFriendRequest, ImageForCrop: $sendImageToProfiel, isProfileSheetShow: $isDashboardSheetShow, feedtoSheet: $selectedfeed, relationship: $relationship, profile1: profile1, profile2: profile2).tag("profile")
                    .onAppear{
                        let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                       
                        relationship = (getRegisterDefaultData?["relationship"] ?? "") as! String
                        
                        print(relationship)
                    }
            }.onAppear{
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                    withAnimation {
                        // self.showSecondView = true
                    }
                }
            }
            .ignoresSafeArea()
            if !self.isProfielOptionShow && !self.isDashboardSheetShow{
                HStack{
                    ForEach(tabs,id: \.self){image in
                        
                        TabButton(image: image, selectedTab: $selectedTab)
                        
                        if image != tabs.last {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .padding(.horizontal,25)
                .padding(.vertical,5)
                .background(Constants.AppColor.appPink)
                .cornerRadius(radius: 30, corners: [.topLeft, .topRight])
                .ignoresSafeArea()
            }
            else if self.isDashboardSheetShow{
                SheetView(isShown: true , showSheet: $isDashboardSheetShow, selectedfeed: self.selectedfeed!, postId: postId, status: $status)
                
            }
            else{
                if self.isProfielOptionShow{
                    HStack{
                        GalleryOptionView(sendImage: $sendImageToProfiel, plusview: nil)
                    }
                    .background(Constants.AppColor.appDarkGary)
                }
            }
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        .navigationBarHidden(true)
        .onAppear{
            //UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
            
          let result = getLoginUserDefaults(key: "interestList")
            print(result)
        }
        .onChange(of: status) { (value) in
            if status == 1 {
                self.isCall = false
            }
        }
    }
}



struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}




struct TabButton : View {
    @State var image : String
    @Binding var selectedTab : String
    
    var body: some View {
        ZStack{
            Button(action: {
                selectedTab = image
            }) {
                if image == "heart" {
                    if SharedPreferance.getAppUserType() == UserType.Business.rawValue{
                        Image("bs_plus")
                            .renderingMode(.original)
                            .foregroundColor((selectedTab == image ? Constants.AppColor.appPink : Color.white))
                            .padding(6)
                    }else{
                        Image(image)
                            .renderingMode(.original)
                            .foregroundColor((selectedTab == image ? Constants.AppColor.appPink : Color.white))
                            .padding(6)
                    }
                }
                else if image == "profile"{
                    let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                    
                    let profilePicPath = "\(registerDefaultData?["profilePicPath"] ?? "")"
                    WebImage(url: URL(string: profilePicPath ))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity).accentColor(.pink)
                        .cornerRadius(20)
                        .frame(width:40,height : 40)
                }else {
                    Image(image)
                        .renderingMode(selectedTab == image ? .template : .original)
                        .foregroundColor((selectedTab == image ? Constants.AppColor.appPink : Color.white))
                        .padding(6)
                        .background((selectedTab != image ? Color("tab") : Color.white))
                        .cornerRadius(8)
                }
            }
        }.navigationBarHidden(true)
    }
}


struct Coupan:View {
    var body: some View {
        VStack{
            Text("Coupan")
        }
    }
}

struct Setting:View {
    @State private var isRegisterActive: Bool = false
    // @ObservedObject var fbmanager = UserFBLoginManager()
    var body: some View {
        VStack{
            
            NavigationLink(destination: LoginView(), isActive: $isRegisterActive) {
                
                Button(action: {
                    AccessToken.current = nil
                    UserDefaults.standard.setValue(false, forKey: Constants.UserDefaults.isLogin)
                    UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.token)
                    UserDefaults.standard.setValue([String:Any](), forKey: Constants.UserDefaults.loginData)
                    UserDefaults.standard.setValue(Data(), forKey: Constants.UserDefaults.userData)
                    UserDefaults.standard.synchronize()
                    GIDSignIn.sharedInstance().signOut()
                    GIDSignIn.sharedInstance()?.disconnect()
                    UserDefaults.standard.set("login", forKey:Constants.UserDefaults.controller)
                    //  AccessToken.setCurrent(nil)
                    LoginManager().logOut()
                    LoginManager().authType = .rerequest
                    //.string(forKey: Constants.UserDefaults.token)
                    self.isRegisterActive = true
                }, label: {
                    Text("LOGOUT")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("pink"))
                        
                        .clipShape(Capsule())
                })
            }
        }
    }
}


