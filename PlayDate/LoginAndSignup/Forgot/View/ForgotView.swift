//
//  ForgotView.swift
//  PlayDateApp
//
//  Created by Pranjal Dudhe on 21/04/21.
//

import SwiftUI
enum ActiveAlert {
    case error, success
}

struct ForgotView: View {
    @State var username: String = ""
    @State var comeFrom: String = "ForgotPassword"
    @Environment(\.presentationMode) var presentation
    @ObservedObject var forgotVM: ForgotViewModel = ForgotViewModel()
    @State private var authenticate: Bool = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State private var message = ""
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State var isperson = false
    
    func checkValidations() {
        arrValid = forgotVM.callValidations()
        forgotVM.clearData()
    }
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    BackButton()
                    Image("PlayDate")
                        .padding()
                }
                VStack{
                    VStack(spacing:20){
                        Text("Enter register mobile number")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                            .fontWeight(.medium)
                        
                        HStack(alignment: .center) {
                            Image("phone").padding([.top,.bottom,.leading])
                            
                            ZStack(alignment: .leading) {
                                if forgotVM.phoneNo.isEmpty { Text("Mobile Number")
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                                }
                                TextField("", text: $forgotVM.phoneNo)
                                    .foregroundColor(Color.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                                    .keyboardType(.numberPad)
                            }
                        }
                        .background(Constants.AppColor.appPink)
                        .border(Color.white, width: 1)
                    }
                    .padding(.leading,25)
                    .padding(.trailing,25)
                    
                    NavigationLink(destination: OTP(phoneNo: $forgotVM.phoneNo, comeFrom: $comeFrom, isSelectPerson: isperson), isActive: $authenticate) {
                        Button(action: {
                            checkValidations()
                            if arrValid.count == 0 {
                                self.ForgotService()
                            }else {
                                shown.toggle()
                            }
                        }, label: {
                            Text("RESET PASSWORD")
                                .fontWeight(.medium)
                                .font(.custom("Helvetica Neue", size: 14.0))
                                .foregroundColor(.white)
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
                    .padding(.top,30)
                }.offset(y:60)
                Spacer()
            }
            .blur(radius: shown ? 10 : 0)
            .background(BGImage())
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            ActivityLoader(isToggle: $forgotVM.loading)
                .blur(radius: shown ? 10 : 0)
        }
        .statusBar(style: .lightContent)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func ForgotService(){
        forgotVM.callForgotApi { result, response,error  in
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
}

