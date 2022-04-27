//
//  JoinInviteCodeView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/06/21.
//


import SwiftUI
import ActivityIndicatorView

struct JoinInviteCodeView: View {
    @State var txtOTP: String = ""
    @ObservedObject var joinCodeVM: JoinInviteCodeViewModel = JoinInviteCodeViewModel()
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
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State var relationship = ""
    @Binding var comingFromEdit: Bool
    @State private var Authenticate: Bool = false
    @Binding var localRelationship : String
    func checkValidations() {
        arrValid = joinCodeVM.callValidations()
        joinCodeVM.clearData()
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 20.0){
                HStack{
                      BackButton()
                    Spacer()
                }
               
                VStack(alignment: .center, spacing: 40.0) {
                    
                    Image("balloons_Heart")
                  
                    Text("Your Invite Code")
                        .fontWeight(.bold)
                        .font(.custom("Helvetica Neue", size: 20.0))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                  
                    VStack(spacing : 10){
                        Text("An invitation contaioning a code has been sent to you by your partner. Please type it in below")
                            //.fontWeight(.bold)
                            .font(.custom("Helvetica Neue", size: 14.0))
                            .foregroundColor(.white)
                            .padding([.leading,.trailing],40)
                            .multilineTextAlignment(.center)
                    }
                  
                    ZStack(alignment: .center) {
                     
                        if joinCodeVM.codeTxt == "" {
                            Text("18458974").foregroundColor(Constants.AppColor.appBlack.opacity(0.4))
                                
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(Color.white)
                                
                                .font(.custom("Helvetica Neue", size: 30))
                        }
                        TextField("", text: $joinCodeVM.codeTxt)
                            .frame(width: 200, height: 50, alignment: .center)
                            .multilineTextAlignment(.center)
                            .font(.custom("Helvetica Neue", size: 30))
                            .foregroundColor(Constants.AppColor.appBlack)
                            .border(Constants.AppColor.appPink, width: 2)
                            // .background(Color.white)
                            .background(joinCodeVM.codeTxt == "" ? Color.clear: Color.white)
                            .keyboardType(.numberPad)
                        
                    }
                    
                    VStack{
                        NavigationLink(destination: GenderInterest(comingFromEdit:.constant(false)), isActive: $Authenticate) {
                            Button(action: {
                                checkValidations()
                                if arrValid.count == 0 {
                                    self.UpdateUserProfielService()
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
                }.padding()
                Spacer()
            }.blur(radius: shown ? 10 : 0)
           
            .onAppear{
                let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                relationship = getRegisterDefaultData!["relationship"] as! String
            }
            
            if shown
            {
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            ActivityIndicatorView(isVisible: $joinCodeVM.loading, type: .flickeringDots)
                .foregroundColor(Constants.AppColor.appPink)
                .frame(width: 50.0, height: 50.0)
            
        } .background(BGImage())
        .navigationBarHidden(true)
        .statusBar(style: .lightContent)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
    
    //MARK:- Calling Api
    func JoinCaodeService(){
        self.joinCodeVM.TakenJoinCodeService(inviteCode:joinCodeVM.codeTxt, completion: { result, response,error  in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.Authenticate = true
            }else if result == strResult.error.rawValue{
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        })
    }
    
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: relationship, type: "relationship") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.JoinCaodeService()
                }
                self.error = false
                UserDefaults.standard.set("genderInterest", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["relationship"] =
                localRelationship
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
            }else if result == strResult.error.rawValue{
                self.Authenticate = false
                self.error = true
                //self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                //self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                //self.showAlert = true
            }
        }
    }
}
