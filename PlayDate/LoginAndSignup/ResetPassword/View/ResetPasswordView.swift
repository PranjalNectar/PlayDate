//
//  ResetPasswordView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 11/05/21.


import SwiftUI
import ActivityIndicatorView

struct ResetPasswordView: View {
    @Binding var phoneNo : String
    @Binding var otp : String
    @Environment(\.presentationMode) var presentation
    @State private var authenticate: Bool = false
    
    @State private var showLoadingIndicator = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    
    @State var shown = false
    @State var isHidePassword = true
    @State var isHideConfirmPassword = true
    @State var message = ""
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State var password = ""
    @State var confirmpassword = ""
    @State var arr = [String]()
    @State var state = MessageString()
    
    @ObservedObject var resetVM: ResetPasswordViewModel = ResetPasswordViewModel()
    func checkValidations() {
        
        
        arr = [String]()
        arr = callValidations()
        
    }
    var body: some View {
        
        ZStack{
            VStack(spacing: 25.0){
                HStack{
                    Image("logo")
                        .padding(.top,20)
                }
                Text("Enter new password")
                    .foregroundColor(Color.white)
                VStack(alignment: .leading, spacing: 20.0) {
                    
                    HStack(alignment: .center) {
                        Image("password").padding([.top,.bottom,.leading])
                        
                        ZStack(alignment: .leading) {
                            if password.isEmpty { Text("New Password")
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                            }
                            if isHidePassword {
                                SecureField("", text: $password)
                                    .foregroundColor(Color.white)
                                    .accentColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                            }else {
                                TextField("", text: $password)
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
                    
                    
                    HStack(alignment: .center) {
                        Image("password").padding([.top,.bottom,.leading])
                        
                        ZStack(alignment: .leading) {
                            if confirmpassword.isEmpty { Text("Confirm Password")
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                            }
                            
                            if isHideConfirmPassword {
                                SecureField("", text: $confirmpassword)
                                    .foregroundColor(Color.white)
                                    .accentColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                                
                            }else {
                                TextField("", text: $confirmpassword)
                                    .foregroundColor(Color.white)
                                    .accentColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                            }
                        }
                        
                        Button(action: {
                            isHideConfirmPassword.toggle()
                        }) {
                            if isHideConfirmPassword {
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
                    
                }.padding(.leading,25)
                .padding(.trailing,25)
                
                VStack(alignment: .center, spacing: 20.0){
                    NavigationLink(destination: LoginView(), isActive: $authenticate) {
                        Button(action: {
                            checkValidations()
                            if arr.count == 0 {
                                self.ResetPasswordService()
                            }else {
                                shown.toggle()
                            }
                        }, label: {
                            Text("RESET PASSWORD")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .background(Color.gray.opacity(0.4))
                                
                                .clipShape(Capsule())
                        })
                        
                    }
                    .alert(isPresented: $showAlert, content: {
                        switch activeAlert {
                        case .error:
                            return  Alert(title: Text("Error"),
                                          message: Text(message),
                                          dismissButton: .default(Text("OK")) { })
                        case .success:
                            return  Alert(title: Text("Success"),
                                          message: Text(message),
                                          dismissButton: .default(Text("OK")) {  self.authenticate = true })
                            
                        }
                    })
                    
                }.padding()
                Spacer()
                
            } .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arr)
            }
            ActivityLoader(isToggle: $resetVM.loading)
                .blur(radius: shown ? 10 : 0)
        }
        .statusBar(style: .lightContent)
        .onTapGesture {
            self.endEditing()
        }
    }
    
    func ResetPasswordService(){
        resetVM.callResetPassApi(phoneNo:phoneNo, otp: otp, password: password) {  result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.activeAlert = .success
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.authenticate = false
                self.activeAlert = .error
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
    
    
    func callValidations() -> [String]{
        isValidPassword()
        isValidConfirmPassword()
        return arr
    }
    
    
    func isValidPassword() {
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count == 0 {
            arr.append(state.password)
        } else if password.count < 6 {
            arr.append(state.vPassword)
        }
    }
    
    func isValidConfirmPassword() {
        confirmpassword = confirmpassword.trimmingCharacters(in: .whitespacesAndNewlines)
        if confirmpassword.count == 0 {
            arr.append(state.confirmPassword)
        } else if confirmpassword != password {
            arr.append(state.vConfirmPassword)
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}


