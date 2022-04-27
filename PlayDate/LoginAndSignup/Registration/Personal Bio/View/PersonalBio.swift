//
//  PersonalBio.swift
//  PlayDate
//
//  Created by Pranjal on 22/04/21.
//

import SwiftUI

struct PersonalBio: View {
    
    @Binding var comingFromEdit: Bool
    @State private var Authenticate: Bool = false
    @State var txtBio: String = ""
    @Environment(\.presentationMode) var presentation
    @State private var error: Bool = false
    @State var message = ""
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State var showSelf = false
    @State var isSelectPerson: Bool = true
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @Binding var coupleid : String
    @Binding var relationship : String
    
    init(comingFromEdit:Binding<Bool>,coupleid:Binding<String>,relationship:Binding<String>) {
        self._comingFromEdit = comingFromEdit
        self._coupleid = coupleid
        self._relationship = relationship
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack(spacing: 20){
            HStack{
                let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                if backButton {
                    BackButton()
                }else {
                    BackButton().hidden()
                }
                Spacer()
            }
            HStack{
                VStack(alignment : .leading ,spacing: 10.0){
                    Text( self.isSelectPerson ? "Personal Bio" : "Business Bio")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Helvetica Neue", size: 18.0))
                    
                    Text(self.isSelectPerson ? "Write a short bio that will be displayed on your profile" : "Write a short bio about your business")
                        .foregroundColor(.white)
                        .font(.custom("Helvetica Neue", size: 14.0))
                }
                Spacer()
            }.padding(.leading, 16)
           
            VStack(alignment : .leading,spacing: 25.0){
                //HStack(alignment: .center) {
                ZStack(alignment: .top) {
                    HStack{
                        if txtBio.isEmpty {
                            
                            Text("Type Personal Bio")
                                .padding(.all, 25)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    
                    TextEditor(text: $txtBio)
                        .background(Constants.AppColor.appRegisterbg
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5.0).stroke(Color.white, lineWidth: 1)
                                        )
                        )
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .frame(maxHeight : 150)
                        .padding([.all], 16.0)
                }
            }
            Spacer()
            
            VStack(alignment: .center){
                NavigationLink(destination: UploadImage(comingFromEdit: .constant(false)), isActive: $Authenticate) {
                    
                    Button(action: {
//                        self.Authenticate = true
                        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                        if !txtBio.isEmpty{
                            if relationship == "Taken" {
                                self.callUpdateCoupleProfileApi()
                            }else {
                                self.UpdateUserProfielService()
                            }
                           
                        }else {
                            self.Authenticate = false
                        }
                    }, label: {
                        NextArrow()
                    })
                    .alert(isPresented: self.$error) {
                        Alert(title: Text(message))
                    }
                }
            }
        }
        .statusBar(style: .lightContent)
        .onAppear{
            
            if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                self.isSelectPerson = true
            }else{
                self.isSelectPerson = false
            }
            
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            if getRegisterDefaultData!["personalBio"] != nil{
                txtBio = getRegisterDefaultData!["personalBio"] as! String
            }
            
        }
        .background(BGImage())
        .navigationBarHidden(true)
    }
    
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: txtBio, type: "personalBio") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.error = false
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                }
                UserDefaults.standard.set("uploadImage", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["personalBio"] = txtBio
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
    
    func callUpdateCoupleProfileApi(){
        var parameters = [String:Any]()
        parameters["coupleId"] = coupleid
        parameters["bio"] = txtBio
        
        let userId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
        parameters["userId"] = userId
        
        ProfileVM.callUpdateCoupleProfileApi(parameters: parameters) { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.error = false
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                }
                UserDefaults.standard.set("uploadImage", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["personalBio"] = txtBio
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
