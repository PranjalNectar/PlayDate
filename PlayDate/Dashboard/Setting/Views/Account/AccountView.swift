//
//  Account.swift
//  PlayDate
//
//  Created by Pranjal on 29/04/21.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
struct AccountView: View {
    //MARK:- Properties
    @State var editUsename : Bool = false
    @State var editPersonalBio : Bool = false
    @State var editBusinessPhoto : Bool = false
    @State var editRestPass : Bool = false
    @State var editInterest : Bool = false
    @State var editImage : Bool = false
    @State var editVideo : Bool = false
    @State var editCreateRelationship : Bool = false
    @Binding var isPresentedUpgrade: Bool
    @State var username = ""
    @State var fullName = ""
    @State var personalBio = ""
    @State var profilePicPath = ""
    @State var email = ""
    @State var phoneNo = ""
    @State var interestList = [[String:Any]]()
    @State var selectedInterestName = ""
    @State var isOn = false
    @State var status = 0
    @State var profileVideoPath = ""
    @State var show1 = false
    let registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
    @State var relationship = ""
    @State var model = ToggleModel()
    @ObservedObject var userFriendVM: UserFriendListViewModel = UserFriendListViewModel()
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var coupleProfileData : CoupleProfileDataModel?
    @State var requestID = ""
    
    //MARK:- Body
    var body: some View {
        VStack(spacing : 20){
            
            NavigationLink(destination: UploadImage(comingFromEdit: $editImage), isActive: $editImage) {
                VStack(spacing:10){
                    
                    if profilePicPath == ""{
                        Image("profileplaceholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            .scaledToFit()
                            .onTapGesture {
                                self.editImage = true
                                
                            }
                    }else {
                        WebImage(url: URL(string: profilePicPath))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .indicator(.activity).accentColor(.pink)
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    }
                    Text("Change profile photo")
                        .fontWeight(.bold)
                        .font(.custom("Arial", size: 14.0))
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .onTapGesture {
                            self.editImage = true
                        }
                }
            }
            
            VStack(spacing : 20){
                if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Username")
                            Spacer()
                            NavigationLink(destination: Username(comingFromEdit:$editUsename), isActive: $editUsename) {
                                Image("edit")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .onTapGesture {
                                        self.editUsename = true                            }
                            }
                        }.padding([.leading, .trailing])
                        
                        if username == ""{
                            TextNormal(txtNormal : "Emyron96")
                        }else {
                            TextNormal(txtNormal : username)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                        }
                    }
                }else{
                    //// business ///////
                    
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Business Name")
                            Spacer()
                            
                        }.padding([.leading, .trailing])
                        
                        
                        if self.fullName == ""{
                            TextNormal(txtNormal : "Business Name")
                        }else {
                            TextNormal(txtNormal : self.username)
                        }
                        
                    }
                }
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Reset Password")
                        Spacer()
                        NavigationLink(destination: ChangePasswordView(), isActive: $editRestPass) {//GameMenuView()ChangePasswordView
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editRestPass.toggle()
                                }
                            
                        }
                    }.padding([.leading, .trailing])
                    
                    TextNormal(txtNormal : "*******")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                }
                
                if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                    if relationship == "Single" {
                        VStack(alignment:.leading, spacing : 10){
                            HStack{
                                TextHeading(txtTitle : "Create Relationship")
                                Spacer()
                                NavigationLink(destination: UserFriendListView(comingFromEdit: $editCreateRelationship), isActive: $editCreateRelationship) {
                                    Image("relationplus")
                                        .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                        .onTapGesture {
                                            self.editCreateRelationship.toggle()
                                        }
                                }
                            }.padding([.leading, .trailing])
                            
                            TextNormal(txtNormal : "Invite your partner")
                            
                            
                        }
                    }else {
                        VStack(alignment:.leading, spacing : 10){
                            HStack{
                                TextHeading(txtTitle : "Leave Relationship")
                                Spacer()
                                
                                Image("relationplus")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .onTapGesture {
                                        self.LeaveRelationshipService()
                                    }
                                
                            }.padding([.leading, .trailing])
                            
                            TextNormal(txtNormal : "Become Single")
                            
                        }
                    }
                    
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Change Bio Video")
                            Spacer()
                            
                            NavigationLink(destination: RecoredShowVideoView(comingFromEdit: $editVideo), isActive: $editVideo) {
                                Image("video")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .onTapGesture {
                                        self.editVideo = true
                                    }
                            }
                        }.padding([.leading, .trailing])
                        
                        TextNormal(txtNormal : "Upload new video")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                    }
                }else{
                    ///////////////// ------- business ----- ///////////////
                    
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Email Address")
                            Spacer()
                            
                        }.padding([.leading, .trailing])
                        
                        
                        if email == ""{
                            TextNormal(txtNormal : "Myron.evans@gmail.com")
                        }else {
                            TextNormal(txtNormal : email)
                        }
                        
                    }
                    
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Phone Number")
                            Spacer()
                            
                        }.padding([.leading, .trailing])
                        
                        if phoneNo == ""{
                            TextNormal(txtNormal : "202-555-0126")
                        }else {
                            TextNormal(txtNormal : phoneNo)
                        }
                    }
                    
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Change Business Photo")
                            Spacer()
                            NavigationLink(destination: BusinessPhotoView(comingFromEdit: $editBusinessPhoto), isActive: $editBusinessPhoto) {
                                
                                Image("edit")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .onTapGesture {
                                        self.editBusinessPhoto = true
                                    }
                            }
                        }.padding([.leading, .trailing])
                        
                        TextNormal(txtNormal : "Edit your Business Photo")
                    }
                }
                
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Change Profile Bio")
                        Spacer()
                        NavigationLink(destination: PersonalBio(comingFromEdit: $editPersonalBio,coupleid:$requestID,relationship:$relationship), isActive: $editPersonalBio) {
                            
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editPersonalBio = true
                                }
                           
                        }
                    }.padding([.leading, .trailing])
                    
                    
                    if personalBio == "" {
                        TextNormal(txtNormal : "Edit your Profile Bio")
                    }else {
                        TextNormal(txtNormal : personalBio)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                    }
                    
                }
                if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                    VStack(alignment:.leading, spacing : 10){
                        HStack{
                            TextHeading(txtTitle : "Interests")
                            Spacer()
                            NavigationLink(destination: Interest(comingFromEdit: $editInterest), isActive: $editInterest) {
                                Image("edit")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .onTapGesture {
                                        self.editInterest = true
                                    }
                            }
                        }.padding([.leading, .trailing])
                        
                        if interestList.count == 0 {
                            TextNormal(txtNormal : "Edit your Interest")
                        }else {
                            
                            TextNormal(txtNormal : selectedInterestName)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                        }
                    }
                }
                
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Dark Mode")
                        Spacer()
                        
                        Toggle(isOn: $model.isDark, label: {
                            Text("")
                                .font(Font.system(size: 12.5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                        .toggleStyle(
                            ThemeToggleStyle(label: "", onColor: Constants.AppColor.appBlackWhite, offColor:Constants.AppColor.appBlackWhite, onThumbColor: Constants.AppColor.appPink, offThumbColor: .gray,
                                             width: 25,
                                             height: 14,
                                             cornerRadius: 7,
                                             isOn:$isOn
                            )
                        )
                        
                        
                    }.padding([.leading, .trailing])
                    
                    TextNormal(txtNormal : "Enable / Disable Dark Mode")
                }
                
                Upgrade(isPresentedUpgrade: $isPresentedUpgrade)
                //UsersViewController()//.viewDidLoad()
                
            }.padding()
        }.navigationBarHidden(true)
        .onAppear{
            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
            let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            username = "\(registerDefaultData?["username"] ?? "")"
            personalBio = "\(registerDefaultData?["personalBio"] ?? "")"
            profilePicPath = "\(registerDefaultData?["profilePicPath"] ?? "")"
            interestList = registerDefaultData?["interestList"] as! [[String : Any]]
            relationship = "\(registerDefaultData?["relationship"] ?? "")"
            email = "\(registerDefaultData?["email"] ?? "")"
            phoneNo = "\(registerDefaultData?["phoneNo"] ?? "")"
            fullName = "\(registerDefaultData?["fullName"] ?? "")"
            if relationship == "Taken" {
                self.CoupleProfileDetailService()
            }
            
            if SharedPreferance.getAppDarkTheme(){
                self.isOn = true
                self.model.isDark = true
            }else{
                self.isOn = false
                self.model.isDark = false
            }
            
            var arrInterestNames = [String]()
            for i in 0..<(interestList.count) {
                let dict = interestList[i]
                arrInterestNames.append(dict["name"] as! String)
                self.selectedInterestName = arrInterestNames.joined(separator: ",")
            }
        }
        ActivityLoader(isToggle: $userFriendVM.loading)
            .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
    
    //MARK:- Call Api
    func LeaveRelationshipService(){
        // let requestId = UserDefaults.standard.string(forKey: Constants.UserDefaults.requestID) ?? ""
        userFriendVM.PostLeaveRelationshipsService(requestId:requestID) { result, response, error  in
            if result == strResult.success.rawValue{
                print(response as Any)
                self.message = response?.message ?? ""
                self.showAlert = true
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["relationship"] = "Single"
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                relationship = "Single"
              
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
        ProfileVM.GetCoupleProfileDetailService(userID:  UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "", comeFromProfileTab: true) { result, response,error in
            
            if result == strResult.success.rawValue{
                self.coupleProfileData = response?.data?[0]
                self.requestID = coupleProfileData?.coupleId ?? ""
                print(self.requestID)
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

struct TextHeading: View {
    var txtTitle = ""
    var body: some View {
        Text(txtTitle)
            .fontWeight(.bold)
            .font(.custom("Arial", size: 16.0))
    }
}

struct TextNormal: View {
    var txtNormal = ""
    var body: some View {
        Text(txtNormal)
            .font(.custom("Arial", size: 16.0))
            .foregroundColor(Constants.AppColor.appBlackWhite.opacity(0.4))
            .padding([.leading, .trailing])
    }
}

struct Upgrade: View {
    @State var isBlockUserActive = false
    @State var isInviteActive = false
    @Binding var isPresentedUpgrade: Bool
    @State private var isRegisterActive: Bool = false
    var body: some View {
        HStack{
            VStack(alignment:.leading,spacing : 20){
                
                if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                    TextHeading(txtTitle : "Upgrade Account to Premium")
                        .onTapGesture {
                            self.isPresentedUpgrade.toggle()
                        }
                    
                    NavigationLink(destination: InviteView(comFrom: false), isActive: $isInviteActive) {
                        TextHeading(txtTitle : "Invite Friends")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .onTapGesture {
                                self.isInviteActive = true
                            }
                    }
                    
                    NavigationLink(destination: BlockUserListView(), isActive: $isBlockUserActive) {
                        TextHeading(txtTitle : "Block Users")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .onTapGesture {
                                self.isBlockUserActive.toggle()
                            }
                    }
                }
                
                NavigationLink(destination: LoginView(), isActive: $isRegisterActive) {
                    TextHeading(txtTitle : "Logout")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        
                        .onTapGesture {
                            AccessToken.current = nil
                            UserDefaults.standard.setValue(false, forKey: Constants.UserDefaults.isLogin)
                            UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.token)
                            UserDefaults.standard.setValue([String:Any](), forKey: Constants.UserDefaults.loginData)
                            UserDefaults.standard.setValue(Data(), forKey: Constants.UserDefaults.userData)
                            UserDefaults.standard.synchronize()
                            GIDSignIn.sharedInstance().signOut()
                            GIDSignIn.sharedInstance()?.disconnect()
                            UserDefaults.standard.set("login", forKey:Constants.UserDefaults.controller)
                            LoginManager().logOut()
                            LoginManager().authType = .rerequest
                            self.isRegisterActive = true
                        }
                }
                
            }.padding()
            Spacer()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView( isPresentedUpgrade:.constant(false))
    }
}


struct ProfileImage: View {
    var body: some View {
        VStack(spacing:10){
            Image("profileplaceholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .scaledToFit()
            
            Text("Change profile photo")
                .fontWeight(.bold)
                .font(.custom("Arial", size: 14.0))
        }
    }
}

struct ThemeToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var onThumbColor = Color.white
    var offThumbColor = Color.gray
    var width = 40.0
    var height = 20.0
    var cornerRadius = 10.0
    @Binding var isOn : Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
                .font(Font.system(size: 12.5))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                // if configuration.isOn {
                //             configuration.isOn.toggle()
                //             self.isOn = configuration.isOn
                // }else {
                configuration.isOn.toggle()
                self.isOn = configuration.isOn
                // }
            })
            {
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius), style: .circular)
                    .fill(self.isOn ? onColor : offColor)
                    .frame(width: CGFloat(width), height: CGFloat(height))
                    .overlay(
                        Circle()
                            .fill(self.isOn ? onThumbColor : offThumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: self.isOn ? -10 : 10))
                    .animation(Animation.easeInOut(duration: 0.1))
                
            }
        }.onAppear{
            //self.isOn = configuration.isOn
        }
    }
}



