//
//  Age.swift
//  PlayDate
//
//  Created by Pranjal on 21/04/21.
//

import SwiftUI

struct Age: View {
    
    init(comingFromEdit:Binding<Bool>) {
        self._comingFromEdit = comingFromEdit
    }
   
    let days = ["01", "02", "03","04", "05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    
    let Months = ["Jan", "Feb", "Mar","Apr", "May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    var year : [String] {
        var year1 : [String] = []
        let current = Calendar.current.component(.year, from: Date()) - 18
        print(current - 18)
        for i in 0...80{
            year1.append(String(current-i))
        }
        return year1
    }
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State var DaySelect = false
    @State var MonthSelect  = false
    @State var YearSelect  = false
    
    @State var selectionDay = ""
    @State var selectionMonth = ""
    @State var selectionYear = ""
    @State var birthDate = ""
    
    @State var txtDay = "Day"
    @State var txtMonth = "Month"
    @State var txtYear = "Year"
    @State private var error: Bool = false
    @State private var Authenticate: Bool = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var message = ""
    @Binding var comingFromEdit: Bool
    @State var isSelectPerson : Bool = true
    @State private var isBusinessBioActive: Bool = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack{
            VStack(spacing: 20.0){
                HStack{
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        NavigationLink(
                            destination: LoginView(),
                            label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.clear)
                                    .imageScale(.large)
                                    .padding()
                            })
                    }else {
                        BackButton().hidden()
                    }
                    Spacer()
                }
                VStack{
                    Image(self.isSelectPerson ? "age" : "bs_lamp")
                }
                VStack(spacing: 40){
                    Text(self.isSelectPerson ? "Age Verification" : "Business Starting Date")
                        .fontWeight(.bold)
                        .font(.custom("Helvetica Neue", size: 18.0))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(self.isSelectPerson ? "Please enter your date of birth " : "Please enter the date the business has started ")
                        .font(.custom("Lato-Bold", size: 17.0))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 0.0){
                    HStack(spacing: 16.0){
                        DOBText(text:txtMonth)
                            .onTapGesture(perform: {
                                self.MonthSelect.toggle()
                            })
                        
                        DOBText(text: txtDay)
                            .onTapGesture(perform: {
                                self.DaySelect.toggle()
                            })
                        
                        DOBText(text:txtYear)
                            .onTapGesture(perform: {
                                self.YearSelect.toggle()
                            })
                    }
                    
                    HStack( spacing: 16.0){
                        ScrollView{
                            ForEach(Months, id: \.self) { string in
                                Text(string)
                                    .frame(width: 100, height: 50, alignment: .center)
                                    .onTapGesture{
                                        self.txtMonth = string
                                        self.selectionMonth = string
                                    }
                                    .background(self.selectionMonth == string ? Constants.AppColor.appPink :  Constants.AppColor.appRegisterbg)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 100)
                        .onAppear{
                            //(UIScrollView.appearance().subviews.last as! UIImageView).backgroundColor = UIColor.white
                            //UIScrollView().subviews.last!.backgroundColor = UIColor.white
                        }
                      
                        ScrollView{
                            ForEach(days, id: \.self) { string in
                                Text(string)
                                    .frame(width: 100, height: 50, alignment: .center)
                                    
                                    .onTapGesture{
                                        self.txtDay = string
                                        self.selectionDay = string
                                    }
                                    .background(self.selectionDay == string ? Constants.AppColor.appPink :  Constants.AppColor.appRegisterbg)
                                    .foregroundColor(.white)
                            }
                        }
                        .onAppear{
                            //(UIScrollView.appearance().subviews.last)!.backgroundColor = UIColor.white
                            UIScrollView().subviews.last?.backgroundColor = UIColor.white
                        }
                        .frame(width: 100)
                        
                        ScrollView{
                            ForEach(year, id: \.self) { string in
                                Text(string)
                                    .frame(width: 100, height: 50, alignment: .center)
                                    .onTapGesture{
                                        self.txtYear = string
                                        self.selectionYear = string
                                    }
                                    .background(self.selectionYear == string ? Constants.AppColor.appPink :  Constants.AppColor.appRegisterbg)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        .frame(width: 100)
                    }
                    
                    Spacer()
                    VStack(alignment: .center){
                        if  self.isSelectPerson{
                            NavigationLink(destination: UserGenderView(comingFromEdit: .constant(false)), isActive: $Authenticate) {
                                Button(action: {
                                    UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                                    if selectionDay == "" || selectionMonth == "" || selectionYear == "" {
                                        self.Authenticate = false
                                        arrValid = [String]()
                                        arrValid.append(MessageString().birthDate)
                                        self.shown = true
                                    }else {
                                        birthDate = "\(selectionYear)-\(selectionMonth)-\(selectionDay)"
                                        self.shown = false
                                        arrValid = [String]()
                                        self.UpdateUserProfielService()
                                    }
                                }, label: {
                                    NextArrow()
                                })
                                .alert(isPresented: self.$error) {
                                    Alert(title: Text(message))
                                }
                            }
                        }else{
                            NavigationLink(destination: PersonalBio(comingFromEdit:.constant(false),coupleid:.constant(""), relationship: .constant("")), isActive: $isBusinessBioActive) {
                                Button(action: {
//                                    self.isBusinessBioActive = true
                                    UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                                    if selectionDay == "" || selectionMonth == "" || selectionYear == "" {
                                        //self.isBusinessBioActive = false
                                        arrValid = [String]()
                                        arrValid.append(MessageString().birthDate)
                                        self.shown = true
                                    }else {
                                        birthDate = "\(selectionYear)-\(selectionMonth)-\(selectionDay)"
                                        self.shown = false
                                        arrValid = [String]()
                                        self.UpdateUserProfielService()
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
                    .padding()
                }
            }.blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
                // arrValid  = [String]()
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
            if getRegisterDefaultData!["birthDate"] != nil{
                birthDate = getRegisterDefaultData!["birthDate"] as! String
                if birthDate != "" {
                    let birthDateFormat = birthDate.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z", ouputDateFormat: "yyyy-MMM-dd")
                    print(birthDateFormat)
                   
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                    guard let date = dateFormatter1.date(from: birthDate) else {
                        return
                    }
                    dateFormatter1.dateFormat = "MMM"
                    let monthString = dateFormatter1.string(from: date)
                    dateFormatter1.dateFormat = "yyyy"
                    let yearString = dateFormatter1.string(from: date)
                    dateFormatter1.dateFormat = "dd"
                    let dayString = dateFormatter1.string(from: date)
                    
                    print(dayString)
                    print(monthString)
                    print(yearString)
                    
                    selectionDay = dayString
                    DaySelect = true
                    
                    selectionMonth = monthString
                    MonthSelect = true
                    
                    selectionYear = yearString
                    YearSelect = true
                    // }
                    
                }
            }

        }
    }
    
    
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: birthDate, type: "birthDate") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                let birthDateFormat = birthDate.toDateString(inputDateFormat: "yyyy-MMM-dd", ouputDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z")
                print(birthDateFormat)
                
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                
                registerDefaultData?["birthDate"] = birthDateFormat
                
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    if isSelectPerson{
                        self.Authenticate = true
                        UserDefaults.standard.set("gender", forKey:Constants.UserDefaults.controller)
                    }else{
                        self.isBusinessBioActive = true
                        UserDefaults.standard.set("personalBio", forKey:Constants.UserDefaults.controller)
                    }
                }
                self.error = false
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


struct DOBText:View {
    var text: String
    var body: some View {
        Text(text)
            .padding()
            .foregroundColor(.white)
            .frame(width: 100, height: 50, alignment: .center)
            .background(Constants.AppColor.appRegisterbg)
            //.cornerRadius(5.0)
    }
}
