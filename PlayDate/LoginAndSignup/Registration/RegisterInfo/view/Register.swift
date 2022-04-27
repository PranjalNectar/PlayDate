//
//  Register.swift
//  PlayDate
//
//  Created by Pranjal on 20/04/21.
//

import SwiftUI
import Combine
import FBSDKLoginKit
import AuthenticationServices
import Firebase
import GoogleSignIn
import ActivityIndicatorView
struct Register: View {
    //MARK:- Properties
    @ObservedObject private var registerVM = RegisterViewModel()
    @Environment(\.presentationMode) var presentation
    @State private var authenticate: Bool = false
    @State private var authenticateSocial: Bool = false
    @State private var authenticateAppleSocial: Bool = false
    @State private var authenticateGoogleSocial: Bool = false
    @State private var showLoadingIndicator = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var showSuccess = false
    @State private var error: Bool = false
    @State var isHidePassword = true
    @State  var isActive:Bool = false
    @State var isSelectPerson = true
    @State private var onlyNumber = ""
    @State var comeFrom: String = "Register"
    @State var phoneNo = ""
    @State var message = ""
    @State var name = ""
    @ObservedObject var fbmanager = UserFBLoginManager()
    @ObservedObject var loginVM: LoginViewModel = LoginViewModel()
    @State private var controller: Controller = .dashboard
    @State private var isSocialRegisterActive: Bool = false
    
    //MARK:- Body
    var body: some View {
        ZStack{
            VStack(spacing: 25.0){
                HStack{
                    Image("logo")
                        .padding(.top,40)
                }
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false){
                        VStack{
                            VStack(alignment: .leading, spacing: 20.0) {
                                HStack(alignment: .center) {
                                    Image(self.isSelectPerson ? "name" : "bs_name")
                                        .padding([.top,.bottom,.leading])
                                    ZStack(alignment: .leading) {
                                        if registerVM.fullName.isEmpty { Text(self.isSelectPerson ? "Full Name" : "Business Name")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        TextField("", text: $registerVM.fullName)
                                            .foregroundColor(Color.white)
                                            .accentColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                                HStack(alignment: .center) {
                                    Image("address").padding([.top,.bottom,.leading])
                                    ZStack(alignment: .leading) {
                                        if registerVM.address.isEmpty { Text("Address")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        TextField("", text: $registerVM.address)
                                            .foregroundColor(Color.white)
                                            .accentColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                                HStack(alignment: .center) {
                                    Image("phone").padding([.top,.bottom,.leading])
                                    
                                    ZStack(alignment: .leading) {
                                        if registerVM.phoneNo.isEmpty { Text("Phone Number")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        TextField("", text: $registerVM.phoneNo)
                                            .foregroundColor(Color.white)
                                            .keyboardType(.numberPad)
                                            .accentColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                                HStack(alignment: .center) {
                                    Image("email").padding([.top,.bottom,.leading])
                                    
                                    ZStack(alignment: .leading) {
                                        if registerVM.email.isEmpty { Text("Email")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        TextField("", text: $registerVM.email)
                                            .foregroundColor(Color.white)
                                            .keyboardType(.emailAddress)
                                            .accentColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                                HStack(alignment: .center) {
                                    Image("password").padding([.top,.bottom,.leading])
                                    
                                    ZStack(alignment: .leading) {
                                        if registerVM.password.isEmpty { Text("Password")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        
                                        if isHidePassword {
                                            SecureField("", text: $registerVM.password)
                                                .foregroundColor(Color.white)
                                                .accentColor(.white)
                                                .font(.custom("Helvetica Neue", size: 14.0))
                                        }else {
                                            TextField("", text: $registerVM.password)
                                                .foregroundColor(Color.white)
                                                .accentColor(.white)
                                                .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                    }
                                    
                                    Button(action: {
                                        isHidePassword.toggle()
                                    }) {
                                        if isHidePassword {
                                            Image("eyeoff")
                                                .padding()
                                        }else {
                                            Image("eyeon")
                                                .padding()
                                        }
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                            }
                            .padding(.leading,25)
                            .padding(.trailing,25)
                            Spacer()
                            VStack(alignment: .center, spacing: 30.0){
                                NavigationLink(destination: OTP(phoneNo: $phoneNo, comeFrom: $comeFrom, isSelectPerson: self.isSelectPerson), isActive: $authenticate) {
                                    Button(action: {
                                        print(authenticate)
                                        //callApi
//                                        self.authenticate =  true
                                        checkValidations()
                                        if arrValid.count == 0 {
                                            DispatchQueue.main.async {
                                                callRegisterApi()
                                            }
                                        }else {
                                            self.shown = true
                                        }
                                    }, label: {
                                        Text("REGISTER")
                                            .fontWeight(.medium)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                            .foregroundColor(.white)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width - 150)
                                            .background(Color.gray.opacity(0.4))
                                            
                                            .clipShape(Capsule())
                                    })
                                }
                                
                                Button(action: {presentation.wrappedValue.dismiss()}) {
                                    
                                    Text("LOGIN")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 14.0))
                                        .padding()
                                }
                                .background(Color.clear)
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Constants.AppColor.appPink, lineWidth: 3)
                                )
                            }.padding(.top,30)
                            Spacer()
                            LabelDividerView(label: "OR")
                      
                            
                            HStack(spacing: 50.0){
                                //MARK:- Apple
                                SignUpWithAppleView(name: $name)
                                    .frame(width: 50, height: 50)
                                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.appleLogin))
                                    { obj in
                                        
                                        if let userInfo = obj.userInfo, let info = userInfo["info"] {
                                            print(info)
                                            DispatchQueue.main.async {
                                                
                                                callSocialLoginApi(info: info as! [String : Any], type: "apple")
                                            }
                                        }
                                    }
                                
                                
                                //MARK:- Google
                                NavigationLink(destination: chooseDestination(), isActive: $authenticateGoogleSocial) {
                                    Button(action: {
                                        
                                        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                                        GIDSignIn.sharedInstance()?.signIn()
                                        
                                        let googleUser = GIDSignIn.sharedInstance()?.currentUser
                                        if googleUser != nil {
                                            print("dddd")
                                        }
                                    }) {
                                        Image("google")
                                    }
                                    .frame(width: 50,height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.googleLogin))
                                    { obj in
                                        // Change key as per your "userInfo"
                                        if let userInfo = obj.userInfo, let info = userInfo["info"] {
                                            print(info)
                                            //  print(userInfo)
                                            
                                            DispatchQueue.main.async {
                                                callSocialLoginApi(info: info as! [String : Any], type: "google")
                                            }
                                        }
                                    }
                                }
                                
                                //MARK:- Facebook
                                NavigationLink(destination: chooseDestination(), isActive: $authenticateSocial) {
                                    
                                    Button(action: {
                                        self.fbmanager.facebookLogin{ (result) in
                                            DispatchQueue.main.async {
                                                print(result)
                                                
                                                var parameter = [String:Any]()
                                                parameter["email"] = result["email"] ?? ""
                                                parameter["sourceSocialId"] = result["id"] ?? ""
                                                parameter["sourceType"] = "Facebook"
                                                
                                                callSocialLoginApi(info: parameter, type: "facebook")
                                            }
                                        }
                                        
                                    }) {
                                        Image("fb")
                                    }
                                    .frame(width: 50,height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                }
                            }.padding(.bottom)
                        }
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                    }
                }
            } .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }else {
                
            }
            
            NavigationLink(destination: chooseDestination(), isActive: $authenticateAppleSocial) {
            }
            NavigationLink(destination: PersonalBusinessView(isSelectPerson: $isSelectPerson, comingFromSocial: .constant(true)), isActive: $isSocialRegisterActive) {
            }
            ActivityIndicatorView(isVisible: $registerVM.loading, type: .default)
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(Constants.AppColor.appPink)
                .blur(radius: shown ? 10 : 0)
        }
        .statusBar(style: .lightContent)
        .alert(isPresented: $error, title: Constants.AppName, message: self.message)
        .onTapGesture {
            self.endEditing()
        }
        .onAppear{
            if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                self.isSelectPerson = true
            }else{
                self.isSelectPerson = false
            }
        }
       
    }
    
    //MARK:- Functions
    func checkValidations() {
        if isSelectPerson == true{
            registerVM.userType = "Person"
        }else {
            registerVM.userType = "Business"
        }
        arrValid = registerVM.callRegisterValidations()
        registerVM.clearData()
    }
    
    
    //MARK:- Call Api
    func callRegisterApi(){
        registerVM.callRegisterApi { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.error = false
                self.phoneNo = "\(response?.data?.phoneNo ?? "")"
                self.authenticate = true
                UserDefaults.standard.set("r", forKey:Constants.UserDefaults.controller)
            }else if result == strResult.error.rawValue{
                self.authenticate = false
                self.message = error ?? ""
                self.error = true
                UserDefaults.standard.set("r", forKey:Constants.UserDefaults.controller)
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.error = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.error = true
            }
        }
    }
    
    func callSocialLoginApi(info: [String:Any] ,type:String){
        
        loginVM.callSocialLoginApi(parameter: info) {  result, response,error  in
            self.message = response?.message ?? ""
            if response?.status == 0 {
                if type == "facebook" {
                    self.authenticateSocial = false
                }else if type == "google"{
                    self.authenticateGoogleSocial = false
                }else if type == "apple"{
                    self.authenticateAppleSocial = false
                }
                self.error = true
            }else {
               
                self.error = false
                
                let registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                if registerDefaultData?["userType"] as! String != ""{
                    controller = selectLoginResgisterController()
                    if type == "facebook" {
                        self.authenticateSocial = true
                    }else if type == "google"{
                        self.authenticateGoogleSocial = true
                    }else if type == "apple"{
                        self.authenticateAppleSocial = true
                    }
                }else{
                    self.isSocialRegisterActive = true
                }
                print(controller)
            }
        }
    }
    
    //MARK: Navigation
    @ViewBuilder
    func chooseDestination() -> some View {
        switch controller {
        case .birthDate: Age(comingFromEdit:.constant(false))
        case .gender: UserGenderView(comingFromEdit: .constant(false))
        case .relationship: Relationship(comingFromEdit: .constant(false))
        case .genderInterest: GenderInterest(comingFromEdit: .constant(false))
        case .username: Username(comingFromEdit: .constant(false))
        case .uploadImage: UploadImage(comingFromEdit: .constant(false))
        case .personalBio: PersonalBio(comingFromEdit: .constant(false),coupleid:.constant(""), relationship: .constant(""))
        case .ineterstList: Interest(comingFromEdit: .constant(false))
        case .restaurant: Restaurant(comingFromEdit: .constant(false))
        case .recordprofilevideo: RecordProfileVideo(comingFromEdit: .constant(false), isNewVideo: .constant(false))
        case .businessPhoto: BusinessPhotoView(comingFromEdit: .constant(false))
        default: BottomMenuView()
        }
    }
    
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

//            self.showLoadingIndicator.toggle()
//            self.message = result.message ?? ""
//            if result.status == 0 {
//                self.authenticate = false
//                self.error = true
//            }else {
//                self.error = false
//                self.phoneNo = "\(result.data?.phoneNo ?? "")"
//                self.authenticate = true
//            }
//
//            print("JSON\(result)", "\(result.data?.fullName)")
//            self.showLoadingIndicator.toggle()
//            UserDefaults.standard.set("r", forKey:Constants.UserDefaults.controller)
            
   
