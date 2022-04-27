//
//  OTP.swift
//  PlayDate
//
//  Created by Pranjal on 20/04/21.
//

import SwiftUI
import ActivityIndicatorView

struct OTP: View {
    //MARK:- Properties
    @Binding var phoneNo : String
    @Binding var comeFrom : String
    @State var txtOTP: String = ""
    @ObservedObject var otpVM: OTPViewModel = OTPViewModel()
    @State private var showLoadingIndicator = true
    @Environment(\.presentationMode) var presentation
    @State var shown = false
    @State var timeRemaining = 120
    @State var isTimerRunning = true
    @State var arrValid = [String]()
    @State private var authenticate: Bool = false
    @State private var authenticateReset: Bool = false
    @State private var message = ""
    @State private var error: Bool = false
    @State var c: AlertAction?
    @State var from = ""
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State var otp = ""
    @State var arr = [String]()
    @State var state = MessageString()
    @State var isSelectPerson: Bool = true
    
    //MARK:- Body
    var body: some View {
        Background {
            ZStack{
                VStack(spacing: 20.0){
                    HStack{
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 40.0) {
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .default)
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(Constants.AppColor.appPink)
                        
                        Text("We Sent A Code")
                            .font(.custom("Lato-Bold", size: 25.0))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing : 10){
                            Text("Please enter the verification code")
                                .font(.custom("Lato-Bold", size: 16.0))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("that has been sent to you via SMS at")
                                .font(.custom("Lato-Bold", size: 16.0))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(phoneNo.toPhoneNumber())
                                .font(.custom("Lato-Bold", size: 24.0))
                                //.fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        ZStack(alignment: .center) {
                            if otp.isEmpty {  Text("1845").foregroundColor(Constants.AppColor.appBlack.opacity(0.4))
                                
                                .frame(width: 140, height: 50, alignment: .center)
                                .background(Color.white)
                                
                                .font(.custom("Lato-Bold", size: 30))
                            }
                            TextField("", text: $otp)
                                .frame(width: 140, height: 50, alignment: .center)
                                .multilineTextAlignment(.center)
                                .font(.custom("Lato-Bold", size: 30))
                                .foregroundColor(Constants.AppColor.appBlack)
                                .border(Constants.AppColor.appPink, width: 2)
                                .background(otp == "" ? Color.clear: Color.white)
                                .keyboardType(.numberPad)
                        }
                        
                        VStack{
                            if comeFrom == "ForgotPassword"{
                                NavigationLink(destination: ResetPasswordView(phoneNo: $phoneNo, otp: $otp), isActive: $authenticateReset) {
                                    Button(action: {
                                        checkValidations()
                                        if arrValid.count == 0 {
                                            self.authenticateReset.toggle()
                                        }else {
                                            shown.toggle()
                                        }
                                    }, label: {
                                        Text("SUBMIT")
                                            .padding()
                                            .foregroundColor(.white)
                                            .frame(width: 200.0,height: 45)
                                            .background(Constants.AppColor.appRegisterbg)
                                            .cornerRadius(5.0)
                                    })
                                }
                                .alert(isPresented: self.$error) {
                                    Alert(title: Text(message))
                                }
                            }else {
                                NavigationLink(destination: Age(comingFromEdit:.constant(false)), isActive: $authenticate) {
                                    Button(action: {
                                        UserDefaults.standard.set("birthDate", forKey:Constants.UserDefaults.controller)
 //                                       self.authenticate = true
                                        checkValidations()
                                        if arrValid.count == 0 {
                                            //callApi
                                            DispatchQueue.main.async {
                                                callOtpApi()
                                            }
                                        }else {
                                            shown.toggle()
                                        }
                                    }, label: {
                                        Text("SUBMIT")
                                            .padding()
                                            .foregroundColor(.white)
                                            .frame(width: 200.0,height: 45)
                                            .background(Constants.AppColor.appRegisterbg)
                                            .cornerRadius(5.0)
                                    })
                                }
                                .alert(isPresented: self.$error) {
                                    Alert(title: Text(message))
                                }
                            }
                            
                            Spacer()
                            Text("Didn't get a code?")
                                .font(.custom("Lato-Regular", size: 12.0))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            ZStack{
                                if self.isTimerRunning{
                                    Text("Resend OTP option enable with in  \(timeRemaining) sec")
                                        .font(.custom("Lato-Regular", size: 15.0)
                                        )
                                        .onReceive(timer) { _ in
                                            if self.isTimerRunning {
                                                if timeRemaining > 0 {
                                                    timeRemaining -= 1
                                                }else{
                                                    self.isTimerRunning = false
                                                }
                                            }
                                        }
                                        .foregroundColor(.white)
                                }
                                if !self.isTimerRunning{
                                    Text("Resend")
                                        .font(.custom("Lato-Bold", size: 17.0))
                                        .fontWeight(.bold)
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(width: 100.0,height: 45)
                                        .onTapGesture(perform: {
                                            self.isTimerRunning = true
                                            timeRemaining = 120
                                            
                                            DispatchQueue.main.async {
                                                callResendOtpApi()
                                            }
                                        }) .alert(isPresented: $showAlert, content: {
                                            switch activeAlert {
                                            case .error:
                                                return  Alert(title: Text("Error"),
                                                              message: Text(message),
                                                              dismissButton: .default(Text("OK")) { })
                                            case .success:
                                                return  Alert(title: Text("Success"),
                                                              message: Text(message),
                                                              dismissButton: .default(Text("OK")) { })
                                                
                                            }
                                        })
                                }
                            }
                        }
                        Spacer()
                        
                    }
                    .padding()
                }
                .blur(radius: shown ? 10 : 0)
                .background(BGImage())
                .navigationBarHidden(true)
                
                if shown{
                    AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
                }
            }
            .statusBar(style: .lightContent)
          
        }.onTapGesture {
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
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    //MARK:- Functions
    func checkValidations() {
        arrValid = callValidations()
        clearData()
    }
    
    //MARK:- Validation Functions
    
    func callValidations() -> [String]{
        isValidOTP()
        return arr
    }
  
    func clearData() {

        arr = [String]()
    }
    
    func isValidOTP() {
        if otp.count == 0 {
            arr.append(state.OTP)
        }
    }
    //MARK:- Call Api
    
    func callOtpApi() {
        otpVM.callOTPApi(phoneNo: phoneNo , otp: otp) { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.authenticate = true
                self.error = false
                UserDefaults.standard.set("birthDate", forKey:Constants.UserDefaults.controller)
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
    
    func callResendOtpApi() {
        otpVM.callResendOTPApi(phoneNo: phoneNo) { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.error = false
                self.activeAlert = .success
                self.showAlert = true
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
}
