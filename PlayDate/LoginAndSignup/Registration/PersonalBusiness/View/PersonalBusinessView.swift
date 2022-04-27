//
//  PersonalBusinessView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 07/05/21.
//


import SwiftUI

struct PersonalBusinessView: View {
    //MARK:- Properties
    @Binding var isSelectPerson: Bool
    @State private var didTapS:Bool = true
    @State private var didTapT:Bool = false
    @Environment(\.presentationMode) var presentation
    @Binding var comingFromSocial: Bool
    @State private var isRegisterActive: Bool = false
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State private var authenticate: Bool = false
    //MARK:- Body
    var body: some View {
        VStack{
            HStack{
                BackButton()
                Image("PlayDate")
                    .padding()
            }
            Spacer()
            VStack(){
                
                HStack(alignment :.top){
                    
                    VStack(alignment : .center ,spacing: 10.0){
                        
                        Text("Which one are you?")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                            .padding(.bottom)
                    }
                    
                }.padding(.leading, 16.0)
                
                VStack(spacing: 25.0){
                    Button(action: {
                        if !self.didTapS{
                            self.didTapS = true
                            self.didTapT = false
                        }
                        self.isSelectPerson = true
                        SharedPreferance.setAppUserType(UserType.Person.rawValue)
                    }) {
                        RelationText(text: "PERSON")
                            .background(didTapS ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }
                    
                    OrText()
                    
                    Button(action: {
                        if !self.didTapT{
                            self.didTapT = true
                            self.didTapS = false
                        }
                        self.isSelectPerson = false
                        SharedPreferance.setAppUserType(UserType.Business.rawValue)
                    }) {
                        RelationText(text:"BUSINESS")
                            .background(didTapT ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }
                }
            }
            Spacer()
            VStack(alignment: .center){
                Button {
                    if comingFromSocial{
                        self.UpdateUserProfielService()
                    }else{
                        self.isRegisterActive = true
                    }
                } label: {
                    NextArrow()
                }
            }
            
            NavigationLink(
                destination: Register(),isActive: $isRegisterActive){
            }
            NavigationLink(destination: chooseDestination(), isActive: $authenticate) {
            }
        }
        .statusBar(style: .lightContent)
        .background(BGImage())
        .navigationBarHidden(true)
        .onAppear{
            SharedPreferance.setAppUserType(UserType.Person.rawValue)
        }
    }
    
    func UpdateUserProfielService(){
        restaurantListVM.callUserProfileApi(parameters: "", type: "usertype") { result, response,error  in
            if result == strResult.success.rawValue{
                //self.Authenticate = true
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["userType"] = SharedPreferance.getAppUserType()
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                controller = selectLoginResgisterController()
                self.authenticate = true
            }else if result == strResult.error.rawValue{
//                self.Authenticate = false
//                self.error = true
                //self.showAlert = true
            }else if result == strResult.Network.rawValue{
                //self.message = MessageString().Network
                //self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                //self.message = MessageString().NetworkConnection
                //self.showAlert = true
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
    
}


struct RelationText: View {
    var text: String
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .padding()
            .foregroundColor(.white)
            .frame(width:250,height: 60)
    }
}

struct OrText: View {
    var body: some View {
        Text("Or")
            .foregroundColor(.white)
            .font(.custom("Helvetica Neue", size: 14.0))
            .fontWeight(.bold)
    }
}

struct AndText: View {
    var body: some View {
        Text("And")
            .foregroundColor(.white)
            .font(.custom("Helvetica Neue", size: 14.0))
            .fontWeight(.bold)
    }
}

struct NextArrow: View {
    var body: some View {
        Image("arrow")
            .padding()
            .frame(width : 60,height: 60)
            .background(Constants.AppColor.appRegisterbg)
            .cornerRadius(30)
            .padding()
    }
}


