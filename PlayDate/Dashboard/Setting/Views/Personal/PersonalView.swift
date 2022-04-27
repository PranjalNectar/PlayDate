//
//  PersonalView.swift
//  PlayDate
//
//  Created by Pranjal on 29/04/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct PersonalView: View {
    @Binding var isPresentedUpgrade: Bool
    @State var editRelationship : Bool = false
    @State var editGender : Bool = false
    @State var editGenderInterestedIn : Bool = false
    @State var editAge : Bool = false
    @State var email = ""
    @State var phoneNo = ""
    @State var gender = ""
    @State var relationship = ""
    @State var date = ""
    @State var interestedIn = ""
    @State var birthDate = ""
    @State var strDate = ""
    @State var profilePicPath = ""
    @State var editImage : Bool = false
    
    let registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
    
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
                        TextHeading(txtTitle : "Gender")
                        Spacer()
                        NavigationLink(destination: UserGenderView(comingFromEdit: $editGender), isActive: $editGender) {
                            
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editGender = true
                                }
                        }
                    }.padding([.leading, .trailing])
                    
                    
                    if gender == "" {
                        TextNormal(txtNormal : "Male")
                    }else {
                        TextNormal(txtNormal : gender)
                    }
                    
                }
                
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Date Of Birth")
                        Spacer()
                        //                        NavigationView {
                        NavigationLink(destination: Age(comingFromEdit: $editAge), isActive: $editAge) {
                            
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editAge = true
                                }
                        }
                        // }
                    }.padding([.leading, .trailing])
                    
                    
                    if birthDate == "" {
                        TextNormal(txtNormal : "05-03-1994")
                    }else {
                        TextNormal(txtNormal : strDate)
                    }
                    
                    
                }
                
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Sexual orientation")
                        Spacer()
                        NavigationLink(destination: GenderInterest( comingFromEdit: $editGenderInterestedIn), isActive: $editGenderInterestedIn) {
                            
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editGenderInterestedIn = true
                                }
                        }
                    }.padding([.leading, .trailing])
                    
                    
                    if interestedIn == "" {
                        TextNormal(txtNormal : "Straight")
                    }else {
                        TextNormal(txtNormal : interestedIn)
                    }
                    
                    
                }
                
                VStack(alignment:.leading, spacing : 10){
                    HStack{
                        TextHeading(txtTitle : "Relationship Status")
                        Spacer()
                        NavigationLink(destination: Relationship(comingFromEdit: $editRelationship), isActive: $editRelationship) {
                            
                            Image("edit")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .onTapGesture {
                                    self.editRelationship = true
                                }
                        }
                    }.padding([.leading, .trailing])
                    
                    
                    if relationship == "" {
                        TextNormal(txtNormal : "Single")
                    }else {
                        TextNormal(txtNormal : relationship)
                    }
                    
                }
                
                Upgrade(isPresentedUpgrade: $isPresentedUpgrade)
                
            }.padding()
            .onAppear{
                if
                    let loginResultDataEncode = UserDefaults.standard.value(forKey: Constants.UserDefaults.userData) as? Data,
                    let _ = try? JSONDecoder().decode(LoginResultModel.self, from: loginResultDataEncode) {
                }
                
                let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                
                email = "\(registerDefaultData?["email"] ?? "")"
                phoneNo = "\(registerDefaultData?["phoneNo"] ?? "")"
                gender = "\(registerDefaultData?["gender"] ?? "")"
                relationship = "\(registerDefaultData?["relationship"] ?? "")"
                date = "\(registerDefaultData?["date"] ?? "")"
                interestedIn = "\(registerDefaultData?["interestedIn"] ?? "")"
                birthDate = "\(registerDefaultData?["birthDate"] ?? "")"
                
                print(birthDate)
                if birthDate != "" {
                    
                    strDate = birthDate.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z", ouputDateFormat: "yyyy-MM-dd")
                    
                    
                }
                profilePicPath = "\(registerDefaultData?["profilePicPath"] ?? "")"
            }
        }
    }
}

struct PersonalView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalView(isPresentedUpgrade: .constant(false))
    }
}
extension String
{
    func toDateString( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat :
                        String) ->  String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        
        return dateFormatter.string(from: date!)
    }
}

