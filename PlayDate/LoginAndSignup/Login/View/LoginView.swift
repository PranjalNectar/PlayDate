//
//  LoginView.swift
//  PlayDateApp
//
//  Created by Pranjal Dudhe on 21/04/21.
//

import SwiftUI
import Combine
import FBSDKLoginKit
import AuthenticationServices
import Firebase
import GoogleSignIn

struct LoginView: View {
    //MARK:- Properties
    @ObservedObject var loginVM: LoginViewModel = LoginViewModel()
    @State private var authenticate: Bool = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @ObservedObject var fbmanager = UserFBLoginManager()
    @ObservedObject var AppleData = UserSettings()
    @State private var isActive: Bool = false
    @State private var isRegisterActive: Bool = false
    @State private var isSocialRegisterActive: Bool = false
    @State var isHidePassword = true
    @State private var error: Bool = false
    @State var phoneNo = ""
    @State var user =  Auth.auth().currentUser
    @State private var showEmailAlert = false
    @State private var isSelectPerson = true
    @State private var message = ""
    @State private var controller: Controller = .dashboard
    @State var name = ""
    @State private var showAlert: Bool = false
    
    //MARK:- Body
    var body: some View {
        ZStack{
            VStack(spacing:25){
                HStack{
                    Image("PlayDate")
                        .padding(.top,40)
                }
                Spacer()
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false){
                        VStack{
                            //Mark:-Contains UserName &Password
                            VStack(alignment: .leading, spacing: 30.0) {
                                HStack(alignment: .center) {
                                    Image("smallProfile").padding([.top,.bottom,.leading])
                                    ZStack(alignment: .leading) {
                                        if loginVM.keyward.isEmpty { Text("Email / Mobile Number")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        TextField("", text: $loginVM.keyward)
                                            .foregroundColor(Color.white)
                                            .accentColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                                
                                HStack(alignment: .center) {
                                    Image("password").padding([.top,.bottom,.leading])
                                    
                                    ZStack(alignment: .leading) {
                                        if loginVM.password.isEmpty { Text("Password")
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                        
                                        if isHidePassword {
                                            SecureField("", text: $loginVM.password)
                                                .foregroundColor(Color.white)
                                                .accentColor(.white)
                                                .font(.custom("Helvetica Neue", size: 14.0))
                                        }else {
                                            TextField("", text: $loginVM.password)
                                                .foregroundColor(Color.white)
                                                .accentColor(.white)
                                                .font(.custom("Helvetica Neue", size: 14.0))
                                        }
                                    }
                                    
                                    Button(action: {
                                        isHidePassword.toggle()
                                    }) {
                                        if isHidePassword {
                                            Image("eyeon")
                                                .padding()
                                        }else {
                                            Image("eyeoff")
                                                .padding()
                                        }
                                    }
                                }
                                .background(Constants.AppColor.appPink)
                                .border(Color.white, width: 1)
                            }.padding([.leading, .trailing],25)
                            .padding(.top, 15)
                            
                            Spacer()
                            NavigationLink(destination: ForgotView(), isActive: $isActive) {
                                Button(action: {
                                    self.isActive = true
                                }, label: {
                                    Text("Forgot Your Password?")
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 15.0))
                                    
                                })
                            }
                            
                            Spacer()
                            //Mark:-Contains Forgot ,Login ,Register
                            VStack(spacing:30){
                                
                                // .padding(.top,30)
                                
                                NavigationLink(destination: chooseDestination(), isActive: $authenticate) {
                                    Button(action: {
                                        checkValidations()
                                        if arrValid.count == 0 {
                                            //callApi
                                            DispatchQueue.main.async {
                                                callLoginApi()
                                            }
                                            
                                        }else {
                                            shown.toggle()
                                        }
                                        
                                    }, label: {
                                        Text("LOGIN")
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 15.0))
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width - 150)
                                            
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Constants.AppColor.appPink, lineWidth: 2)
                                            )
                                    })
                                    
                                }
                                .alert(isPresented: self.$error) {
                                    Alert(title: Text(message))
                                }
                                
                                //Navigation
                                NavigationLink(destination: PersonalBusinessView(isSelectPerson: $isSelectPerson, comingFromSocial: .constant(false)), isActive: $isRegisterActive) {
                                    
                                    Button(action: {
                                        self.isRegisterActive = true
                                    }, label: {
                                        Text("REGISTER")
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 15.0))
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width - 150)
                                            .background(Color.gray.opacity(0.4))
                                            
                                            .clipShape(Capsule())
                                    })
                                }
                                
                            }.padding(.top,30)
                            
                            Spacer()
                            VStack{
                                
                                LabelDividerView(label: "OR")
                                //MARK:- Contains Social login buttons
                             
                                HStack(spacing: 50.0){
                                    
                                    //MARK:- Apple
                                    SignUpWithAppleView(name: $name)
                                        .frame(width: 50, height: 50)
                                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.appleLogin))
                                        { obj in
                                            
                                            if let userInfo = obj.userInfo, let info = userInfo["info"] {
                                                print(info)
                                                DispatchQueue.main.async {
                                                    callSocialLoginApi(info: info as! [String : Any])
                                                }
                                            }
                                        }
                                    
                                    //MARK:- Google
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
                                                callSocialLoginApi(info:info as! [String : Any])
                                            }
                                        }
                                    }
                                    
                                    //MARK:- Facebook
                                    Button(action: {
                                        self.fbmanager.facebookLogin{ (result) in
                                            DispatchQueue.main.async {
                                                print(result)
                                                
                                                var parameter = [String:Any]()
                                                parameter["email"] = result["email"] ?? ""
                                                parameter["sourceSocialId"] = result["id"] ?? ""
                                                parameter["sourceType"] = "Facebook"
                                                
                                                callSocialLoginApi(info:parameter)
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
                                }.padding(.bottom)
                            }
                        }
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            NavigationLink(destination: PersonalBusinessView(isSelectPerson: $isSelectPerson, comingFromSocial: .constant(true)), isActive: $isSocialRegisterActive) {
            }
            
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            
            UserDefaults.standard.setValue("", forKey: Constants.UserDefaults.token)
            UserDefaults.standard.setValue([String:Any](), forKey: Constants.UserDefaults.loginData)
            UserDefaults.standard.setValue(Data(), forKey: Constants.UserDefaults.userData)
            UserDefaults.standard.synchronize()
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance()?.disconnect()
            UserDefaults.standard.set("login", forKey:Constants.UserDefaults.controller)
            //  AccessToken.setCurrent(nil)
            LoginManager().logOut()
        }
        //  }
        .statusBar(style: .lightContent)
        .onTapGesture {
            self.endEditing()
        }
    }
    
    func checkValidations() {
        arrValid = loginVM.callLoginValidations()
        loginVM.clearData()
    }
    
    //MARK:- Call Api
    
    func callLoginApi(){
        loginVM.callLoginApi { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.authenticate = true
                self.error = false
                UserDefaults.standard.set(true, forKey:Constants.UserDefaults.isSuggestionOpen)
                controller = selectLoginResgisterController()
                print(controller)
            }else if result == strResult.error.rawValue{
                self.authenticate = false
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
    
    
    func callSocialLoginApi(info: [String:Any]){
        loginVM.callSocialLoginApi(parameter: info) {  result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.authenticate = true
                self.error = false
                UserDefaults.standard.set(true, forKey:Constants.UserDefaults.isSuggestionOpen)
                let registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                if registerDefaultData?["userType"] as! String != ""{
                    controller = selectLoginResgisterController()
                }else{
                    self.isSocialRegisterActive = true
                }
                print(controller)
            }else if result == strResult.error.rawValue{
                self.authenticate = false
                self.error = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
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
    
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if phoneNo.count > upper {
            phoneNo = String(phoneNo.prefix(upper))
        }
    }
    
}

//MARK:-Facebook
class UserFBLoginManager: ObservableObject {
    //  @ObservedObject var loginVM: LoginViewModel = LoginViewModel()
    let loginManager = LoginManager()
    
    func facebookLogin(completion: @escaping (NSDictionary) -> ()) {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(String(describing: accessToken))")
                GraphRequest(graphPath: "me", parameters: ["fields": "id,email, name, first_name"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                        completion(fbDetails)
                    }
                })
            }
        }
    }
}

struct Background<Content: View>: View {
    private var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Color.white
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .overlay(content)
    }
}


