//
//  ProfileView.swift
//  PlayDate
//
//  Created by Pranjal on 23/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityIndicatorView
import Mantis
import SocketIO

struct ProfileView: View {
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var friendId : String
    @State var isAddOptionShow = false
    @State var isGalleryOptionShow = false
    @State var isimageselected = false
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @State var profileData : ProfileDetailData?
    @State var coupleProfileData : CoupleProfileDataModel?
    @Binding var isProfielOptionShow : Bool
    
    //Social list
    @Binding var comeFromProfileTab : Bool
    @Binding var isAlreadyFriend : Bool
    @Binding var suggestionListId : String
    @Binding var suggestioFriendRequest : [FriendRequest]
    @Binding var ImageForCrop: UIImage?
    @State var isActive = false
    @State var isPlayActive = false
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var isAddProfile = false
    @State private var error: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State var arrFeedData = [SocialFeedData]()
    @Environment(\.presentationMode) var presentation
    @State private var showFriendAlert: Bool = false
    @State var isClicked = false
    @State var profileVideo = ""
    @State private var isPresented = false
    @State var isShown = false
    @Binding var isProfileSheetShow : Bool
    @State var feeddata : SocialFeedData?
    @Binding var feedtoSheet : SocialFeedData?
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio:1)
    @State var CropselectedImage: UIImage = UIImage()
    @State var isImageSelected = false
    @State var mediaid : String = ""
    @State var geometryHeight : CGFloat = 0.00
    @State var geometryWidth : CGFloat = 0.00
    @Binding var relationship : String
    @State  var profile1 : [Profile1]
    @State  var profile2 : [Profile2]
    @State var isStatus : Int = 0
    let socket = SocketIOManager.shared
    @State private var isChatActive  = false
    @State var isCancel = false
    @State var notiCount = ""
    @ObservedObject private var notificationVM = NotificationViewModel()
    @State var navtag = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    if comeFromProfileTab{
                        if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                            if isAddOptionShow{
                                PlusOptionView(isAddOptionShow: $isAddOptionShow, isGalleryOptionShow: $isGalleryOptionShow)
                                    .transition(.flipFromLeft)
                                    .animation(
                                        Animation.easeIn(duration: 0.1)
                                            .delay(0.1)
                                    )
                            }else{
                                Image("plus")
                                    .onTapGesture {
                                        self.isAddOptionShow = true
                                    }
                                Spacer()
                            }
                        }else{
                            //Spacer()
                            
                            Button(action: {
                                    //presentation.wrappedValue.dismiss()
                                self.isProfielOptionShow = false
                                self.isProfileSheetShow = false
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .imageScale(.large)
                                    .padding()
                            }
                        }
                    }else {
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .imageScale(.large)
                                .padding()
                        }
                    }
                    Spacer()
                    if !isAddOptionShow{
                        Image("PlayDateSmall")
                    }
                    Spacer()
                    if comeFromProfileTab{
                        NavigationLink(destination:  NotificationView(isShown: false).background(Constants.AppColor.appWhite)
                                        .navigationBarHidden(true), isActive: $isActive) {
                            Button(action: {
                                self.isActive = true
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
                        }
                    }else {
                        Text("dfdf").foregroundColor(.clear)
                    }
                }.padding()
                
                Spacer()
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false){
                        VStack{
                            if relationship == "Single" || SharedPreferance.getAppUserType() == UserType.Business.rawValue {
                                HStack(spacing : 20){
                                    VStack{
                                        Text(String(self.profileData?.totalFriends ?? 0))
                                            .foregroundColor(Color("pink"))
                                        Text("Friends")
                                            .font(.custom("Arial", size: 12.0))
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    
                                    VStack{
                                        
                                        Text(self.profileData?.username ?? "Playdate")
                                            .fontWeight(.bold)
                                            .font(.custom("Arial", size: 14.0))
                                            .lineLimit(1)
                                            .fixedSize()
                                        
                                        ZStack{
                                            if  (self.profileData?.profilePicPath  != nil){
                                                WebImage(url: URL(string: self.profileData?.profilePicPath ?? ""))
                                                    .resizable()
                                                    .placeholder {
                                                        Rectangle().foregroundColor(.gray)
                                                    }
                                                    .indicator(.activity)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 150, height: 150)
                                                    .clipShape(Circle())
                                                    .scaledToFit()
                                                
                                            }else{
                                                Image("profileplaceholder")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 150, height: 150)
                                                    .clipShape(Circle())
                                                    .scaledToFit()
                                            }
                                            
                                            
                                            NavigationLink(destination:  PlayerView(profileVideo: $profileVideo)
                                                            .ignoresSafeArea()
                                                            .navigationBarHidden(true), isActive: $isPlayActive) {
                                                Button(action: {
                                                    self.isPlayActive = true
                                                }, label: {
                                                    if profileVideo != "" {
                                                        Image("playicon")
                                                    }
                                                })
                                            }
                                        }
                                    }
                                    Spacer()
                                    
                                    VStack{
                                        Text(String(arrFeedData.count))
                                            .foregroundColor(Color("pink"))
                                        Text("Post")
                                            .font(.custom("Arial", size: 12.0))
                                            .lineLimit(1)
                                    }
                                }.padding(.top)
                                .padding([.leading,.trailing],30)
                                
                            }else {
                                if comeFromProfileTab{
                                    //HStack(spacing : 20){
                                        VStack{
                                            Text(self.coupleProfileData?.profile1?[0].username ?? "Playdate")
                                                .fontWeight(.bold)
                                                .font(.custom("Arial", size: 14.0))
                                                .lineLimit(1)
                                            HStack{
                                                ZStack{
                                                    if  (self.coupleProfileData?.profile1?[0].profilePicPath  != nil){
                                                        WebImage(url: URL(string: self.coupleProfileData?.profile1?[0].profilePicPath ?? ""))
                                                            .resizable()
                                                            .placeholder {
                                                                Rectangle().foregroundColor(.gray)
                                                            }
                                                            .indicator(.activity)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .scaledToFit()
                                                        
                                                    }else{
                                                        Image("profileplaceholder")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .scaledToFit()
                                                    }
                                                    
                                                    
                                                    NavigationLink(destination:  PlayerView(profileVideo: $profileVideo)
                                                                    .ignoresSafeArea()
                                                                    .navigationBarHidden(true),
                                                                   isActive: $isPlayActive) {
                                                        Button(action: {
                                                            self.isPlayActive = true
                                                        }, label: {
                                                            if profileVideo != "" {
                                                                Image("playicon")
                                                            }
                                                            
                                                        })
                                                    }
                                                }
                                                
                                                Spacer()
                                               // Image("love")
                                                LottieView(name: .constant("heart"))
                                                Spacer()
                                                
                                                
                                                ZStack{
                                                    if  (self.coupleProfileData?.profile2?[0].profilePicPath  != nil){
                                                        WebImage(url: URL(string: self.coupleProfileData?.profile2?[0].profilePicPath ?? ""))
                                                            .resizable()
                                                            .placeholder {
                                                                Rectangle().foregroundColor(.gray)
                                                            }
                                                            .indicator(.activity)
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .scaledToFit()
                                                        
                                                    }else{
                                                        Image("profileplaceholder")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(Circle())
                                                            .scaledToFit()
                                                    }
                                                    
                                                    
                                                    NavigationLink(destination:  PlayerView(profileVideo: $profileVideo)
                                                                    
                                                                    .ignoresSafeArea()
                                                                    .navigationBarHidden(true), isActive: $isPlayActive) {
                                                        Button(action: {
                                                            self.isPlayActive = true
                                                        }, label: {
                                                            if profileVideo != "" {
                                                                Image("playicon")
                                                            }
                                                            
                                                        })
                                                    }
                                                }
                                            }
                                        //}
                                        
                                    }.padding(.top)
                                    .padding([.leading,.trailing],30)
                                }else {
                                    
                                    HStack(spacing : 20){
                                        VStack{
                                            Text(String(self.profileData?.totalFriends ?? 0))
                                                .foregroundColor(Color("pink"))
                                            Text("Friends")
                                                .font(.custom("Arial", size: 12.0))
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                        
                                        VStack{
                                            Text(self.profileData?.username ?? "Playdate")
                                                .fontWeight(.bold)
                                                .font(.custom("Arial", size: 14.0))
                                                .lineLimit(1)
                                            ZStack{
                                                if  (self.profileData?.profilePicPath  != nil){
                                                    WebImage(url: URL(string: self.profileData?.profilePicPath ?? ""))
                                                        .resizable()
                                                        .placeholder {
                                                            Rectangle().foregroundColor(.gray)
                                                        }
                                                        .indicator(.activity)
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 150, height: 150)
                                                        .clipShape(Circle())
                                                        .scaledToFit()
                                                    
                                                }else{
                                                    Image("profileplaceholder")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 150, height: 150)
                                                        .clipShape(Circle())
                                                        .scaledToFit()
                                                }
                                                
                                                NavigationLink(destination:  PlayerView(profileVideo: $profileVideo)
                                                                //.background(Constants.AppColor.appWhite.edgesIgnoringSafeArea(.bottom))
                                                                .ignoresSafeArea()
                                                                .navigationBarHidden(true), isActive: $isPlayActive) {
                                                    Button(action: {
                                                        self.isPlayActive = true
                                                    }, label: {
                                                        if profileVideo != "" {
                                                            Image("playicon")
                                                        }
                                                        
                                                    })
                                                }
                                            }
                                        }
                                        Spacer()
                                        
                                        VStack{
                                            Text(String(self.profileData?.totalPosts ?? 0))
                                                .foregroundColor(Color("pink"))
                                            Text("Post")
                                                .font(.custom("Arial", size: 12.0))
                                                .lineLimit(1)
                                        }
                                    }.padding(.top)
                                    .padding([.leading,.trailing],30)
                                    
                                    
                                }
                            }
                            
                            HStack(spacing:20){
                                if !comeFromProfileTab{
                                    if isAlreadyFriend{
                                        Button {
                                            if isAddProfile{
                                                showFriendAlert = true
                                            }else {
                                                showFriendAlert = false
                                                PostAddFriendRequestService()
                                            }
                                        } label: {
                                            if isAlreadyFriend{
                                                Image(isAlreadyFriend ? "suggestionAdded" : "suggessionAAD")
                                                    .onAppear{
                                                        if suggestioFriendRequest.count == 0 {
                                                            //  self.isAddProfile = false
                                                        }else {
                                                            print( suggestioFriendRequest[0].status!)
                                                            //     self.isAddProfile = true
                                                        }
                                                    }
                                            }
                                        }
                                        .alert(isPresented: $showFriendAlert) { () -> Alert in
                                            Alert(title: Text("PlayDate"), message: Text("Are you sure you want to unfriend \(self.profileData?.username ?? "")?"), primaryButton: .default(Text("No"), action: {
                                                print("Okay Click")
                                            }), secondaryButton: .default(Text("Yes")) { PostAddFriendRequestService() })
                                        }
                                    }else {
                                        Button {
                                            self.isAddProfile = false
                                            PostAddFriendRequestService()
                                            //}
                                        } label: {
                                            Image(isAddProfile ? "suggestionAdded" : "suggessionAAD")
                                        }
                                    }
                                }
                                Spacer()
                                if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                                    Text("0 Points")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 14.0))
                                        .frame(width: 150, height: 30)
                                }else{
                                    /////// --------- rating ------ /////////
                                }
                                Spacer()
                                
                                if !comeFromProfileTab{
                                    Image(isAlreadyFriend ? "chat_Pink" : "chat_gray")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .onTapGesture {
                                            if isAlreadyFriend{
                                                let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                                                           "token": UserDefaults.standard.string(forKey: Constants.UserDefaults.token) ?? "",
                                                           "toUserId" : suggestionListId
                                                ]
                                                print(dic)
                                                socket.SendMessageData(event: EventName.chat_room.rawValue, dic: dic) {
                                                    self.navtag = "chatList"
                                                }
                                            }
                                        }
                                }
                            }
                        
                            .padding([.leading,.trailing],30)
                            
                            if relationship == "Single" || SharedPreferance.getAppUserType() == UserType.Business.rawValue {
                                VStack(spacing : 10){
                                    Text("About Me")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 15.0))
                                        .foregroundColor(Color("pink"))
                                    
                                    Text(self.profileData?.personalBio ?? "Not Available")
                                        .font(.custom("Arial", size: 12.0))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading,.trailing],20)
                                
                            }else {
                                if comeFromProfileTab{
                                    VStack(spacing : 10){
                                        Text("How We Met")
                                            .fontWeight(.bold)
                                            .font(.custom("Arial", size: 15.0))
                                            .foregroundColor(Color("pink"))
                                            .padding(.top,20)
                                        
                                        if relationship == "Taken"{
                                            Text(self.coupleProfileData?.bio ?? "Not Available")
                                                .font(.custom("Arial", size: 12.0))
                                                .multilineTextAlignment(.center)
                                        }else {
                                            Text(self.coupleProfileData?.profile1?[0].personalBio ?? "Not Available")
                                                .font(.custom("Arial", size: 12.0))
                                                .multilineTextAlignment(.center)
                                        }
                                      
                                        Image("no-shuffle")
                                        
                                    }.padding([.leading,.trailing],20)
                                    
                                }else {
                                    VStack(spacing : 10){
                                        Text("About Me")
                                            .fontWeight(.bold)
                                            .font(.custom("Arial", size: 15.0))
                                            .foregroundColor(Color("pink"))
                                        
                                        Text(self.profileData?.personalBio ?? "Not Available")
                                            .font(.custom("Arial", size: 12.0))
                                            .multilineTextAlignment(.center)
                                    }.padding([.leading,.trailing],20)
                                }
                                
                            }
                            
                            VStack{
                                if comeFromProfileTab && SharedPreferance.getAppUserType() == UserType.Person.rawValue {
                                    ProfileTabView(arrFeedData: $arrFeedData, isSheetShow: $isShown, isStatus: $isStatus, feedtoSheet: $feeddata,geometryHeight: $geometryHeight,geometryWidth: $geometryWidth)
                                      
                                        .onAppear {
                                            self.geometryHeight = geometry.size.height
                                            self.geometryWidth = geometry.size.width
                                        }
                                        .popover(isPresented: $isShown, content: {
                                            SheetView(isShown: true , showSheet: $isShown, selectedfeed: self.feeddata!, postId: "postId", status: $isStatus)
                                                .background(BackgroundClearView())
                                        })
                                        .onChange(of: isStatus) { (value) in
                                            if isStatus == 1{
                                                if relationship == "Single" {
                                                    self.ProfileDetailService()
                                                }else {
                                                    if comeFromProfileTab{
                                                        self.CoupleProfileDetailService()
                                                    }else {
                                                        self.ProfileDetailService()
                                                    }
                                                }
                                            }
                                        }
                                }else {
                                    if arrFeedData.count == 0 {
                                        Spacer()
                                    }else {
                                        
                                    }
                                    MyFeedView(isAlreadyFriend: $isAlreadyFriend, userID: $suggestionListId, comeFromProfileTab: .constant(false), arrFeedData: $arrFeedData, isClicked: $isClicked, isSheetShow: .constant(false), feedtoSheet: $feeddata,geometryHeight: $geometryHeight,geometryWidth: $geometryWidth, apistatus: $isStatus)
                                        .onAppear {
                                            self.geometryHeight = geometry.size.height
                                            self.geometryWidth = geometry.size.width
                                        }
                                        .navigationBarHidden(true)
                                        .ignoresSafeArea()
                                    
                                    Spacer()
                                }
                                Spacer()
                                
                            }.padding(.top, 20)
                        }
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                    }
                }
                
                NavigationLink(destination: InboxAndRequestView(),isActive: $isChatActive,label: {
                })
                
                NavigationLink(destination: UploadFeedView(image: self.CropselectedImage, mediaid: self.mediaid, mediatype:"image"), isActive: $isImageSelected) {
                }
            }
            .onChange(of: self.ImageForCrop, perform: { value in
                if self.ImageForCrop != nil{
                    self.CropselectedImage = self.ImageForCrop!
                    self.showingCropper = true
                }
            })
            
            ActivityIndicatorView(isVisible: $ProfileVM.loading, type: .flickeringDots)
                .foregroundColor(Constants.AppColor.appPink)
                .frame(width: 50.0, height: 50.0)
           
            ActivityLoader(isToggle: $socialSuggestionListVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .fullScreenCover(isPresented: $showingCropper, content: {
            ImageCropper(image: $CropselectedImage,
                         cropShapeType: $cropShapeType,
                         presetFixedRatioType: $presetFixedRatioType, isCancel: $isCancel)
                .ignoresSafeArea()
                .onDisappear{
                    if !isCancel{
                        self.AddMediaService()
                    }
                   
                    print("call after crop")
                }
        })
        
        .padding(.bottom, comeFromProfileTab ? 20 : 0)
        .navigationBarHidden(true)
        .onAppear{
            if isAlreadyFriend{
                self.isAddProfile = true
            }
            self.OnListner()
            
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
           
            relationship = (getRegisterDefaultData?["relationship"] ?? "") as! String
            
            print(relationship)
            if relationship == "Single" {
                self.ProfileDetailService()
                self.profileVideo = profileData?.profileVideoPath ?? ""
            }else {
                if comeFromProfileTab && SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                    self.CoupleProfileDetailService()
                }else {
                    self.ProfileDetailService()
                    profileVideo = profileData?.profileVideoPath ?? ""
                }
            }
            self.GetNotificationCount()
        }
        .onChange(of: self.isGalleryOptionShow, perform: { value in
            if self.isGalleryOptionShow{
                self.isProfielOptionShow = true
            }else{
                self.isProfielOptionShow = false
            }
        })
    }
    
    func OnListner(){
        socket.HandledEventdate { (event, data) in
            if event == EventName.chat_room.rawValue{
                print("---------- received ------------")
                print(data)
                do {
                    let msg = data[0] as! [String:Any]
                    let apiData = try JSONSerialization.data(withJSONObject: msg , options: .prettyPrinted)
                    let response = try JSONDecoder().decode(textMessageModel.self, from: apiData )
                    print(response)
                    if self.navtag == "chatList"{
                        self.isChatActive = true
                    }
                }catch (let error){
                    print("ERROR:", error)
                }
            }
        }
    }
    
    func ProfileDetailService(){
        ProfileVM.GetProfileDetailService(userID: suggestionListId, comeFromProfileTab: comeFromProfileTab) { result, response,error in
            
            if result == strResult.success.rawValue{
                self.profileData = response?.data?[0]
                self.profileVideo = profileData?.profileVideoPath ?? ""
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
    
    func CoupleProfileDetailService(){
        ProfileVM.GetCoupleProfileDetailService(userID: suggestionListId, comeFromProfileTab: comeFromProfileTab) { result, response,error in
            
            if result == strResult.success.rawValue{
                self.coupleProfileData = response?.data?[0]
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
    
    func AddMediaService(){
        var data = Data()
        
        data = self.CropselectedImage.jpegData(compressionQuality: 0.5) ?? Data()
        
        ProfileVM.AddMediaService("feed", mediatype: "image", imgData: data, check: "") {result, response,error in
            if result == strResult.success.rawValue{
                self.mediaid = response?.data?.mediaId ?? ""
                self.isImageSelected = true
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
    

    //MARK:- Call Api
  
    func PostAddFriendRequestService() {
        if isAddProfile{
            
            socialSuggestionListVM.PostAddRemoveFriendRequestService(id: friendId, type: "RemoveFriend") { result, responce,error  in
                
                if result == strResult.success.rawValue{
                    self.message = responce?.message ?? ""
                    self.showAlert = true
                    self.isAddProfile = false
                    self.isAlreadyFriend = false
                }else if result == strResult.error.rawValue{
                    self.message = responce?.message ?? ""
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }else if result == strResult.Network.rawValue{
                    self.message = MessageString().Network
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }else if result == strResult.NetworkConnection.rawValue{
                    self.message = MessageString().NetworkConnection
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }
            }
        }else{
            socialSuggestionListVM.PostAddRemoveFriendRequestService(id: suggestionListId, type: "AddFriend") { result, responce,error  in
                
                if result == strResult.success.rawValue{
                    self.message = responce?.message ?? ""
                    self.showAlert = true
                    self.isAddProfile = false
                    self.isAlreadyFriend = false
                }else if result == strResult.error.rawValue{
                    self.message = responce?.message ?? ""
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }else if result == strResult.Network.rawValue{
                    self.message = MessageString().Network
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }else if result == strResult.NetworkConnection.rawValue{
                    self.message = MessageString().NetworkConnection
                    self.showAlert = true
                    self.isAddProfile = true
                    self.isAlreadyFriend = true
                }
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



struct PlusOptionView: View {
    @Binding var isAddOptionShow : Bool
    @Binding var isGalleryOptionShow : Bool
    @State var isActive = false
    var body: some View {
        HStack{
            Image("cross")
                .padding(.all, 5.0)
                .onTapGesture {
                    self.isAddOptionShow = false
                    self.isGalleryOptionShow = false
                }
            Image("gallery")
                .padding(.all, 5.0)
                .onTapGesture {
                    self.isGalleryOptionShow = true
                    self.isAddOptionShow = true
                }
            
            NavigationLink(destination: AddQuestionView(), isActive: $isActive) {
                Button(action: {
                    self.isActive = true
                }, label: {
                    Image("question")
                        .padding(.all, 5.0)
                })
            }
            
            Image("cart")
                .padding(.all, 5.0)
        }
        .padding(.all, 5.0)
        .background(Color("pink"))
        .cornerRadius(20)
        //.frame(width: 200, height: 40, alignment: .center)
    }
}








