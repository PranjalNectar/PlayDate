//
//  Restaurant.swift
//  PlayDate
//
//  Created by Pranjal on 27/04/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct RestItem : Identifiable{
    var id = UUID()
    var name: String
    var isSelected: Bool = false
}

struct Restaurant: View {
    @Environment(\.presentationMode) var presentation
    @State var txtSearch  = ""
//    @State var arrRestaurants : [RestItem] = [
//        RestItem(name: "rest1"),
//        RestItem(name:"rest2"),
//        RestItem(name:"rest3"),
//        RestItem(name:"rest4"),
//        RestItem(name:"rest5"),
//        RestItem(name:"rest6")]
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var comingFromEdit: Bool
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State var restaurantData = [MyRestaurantDataModel]()
    @State var selectedIds = ""
    @State var arrRestaurantId = [String]()
    @State private var authenticate: Bool = false
    @State var message = ""
    @State private var error: Bool = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var restaurantParam = [[String:Any]]()
    @State var selection = ""
    @State private var showAlert: Bool = false
   
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                        
                    }
                    Spacer()
                }
                VStack(spacing: 20){
                    HStack{
                        VStack(alignment : .leading ,spacing: 10.0){
                            Text("Restaurants")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 18.0))
                            
                            Text("Please select your favourite places to eat")
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Image("search")
                            .padding([.leading,.top,.bottom])
                        
                        ZStack(alignment: .leading) {
                            if txtSearch.isEmpty { Text("Search here...").foregroundColor(Constants.AppColor.appBlack.opacity(0.8)) }
                            
                            TextField("Search here...", text: $txtSearch)
                                .onChange(of: txtSearch) {_ in
                                    
                                    callRestaurantApi(filter: txtSearch)
                                }
                                .foregroundColor(Color.black)
                        }
                    }
                    .frame( height: 50)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(25)
                }.padding([.leading, .bottom,.trailing])
                
                VStack(spacing: 25.0){
                    ScrollView
                    {
                        LazyVGrid(columns: columns, spacing : 20) {
                            ForEach(self.restaurantData.filter {$0.name.contains(txtSearch.lowercased()) || txtSearch.isEmpty}) { item in
                                ZStack(alignment: .topTrailing){
                                    //Image(uiImage: UIImage(url: URL(string: item.image ?? "")))
                                    WebImage(url: URL(string: item.image))
                                        .resizable()
                                        .padding()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:120,height: 120)
                                        
                                        //.scaledToFit()
                                        .foregroundColor(selectedIds.contains(item.id) ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                                        
                                        .onTapGesture{
                                            for i in 0..<(self.restaurantData.count) {
                                                
                                                if (self.restaurantData[i].name ==  item.name){
                                                    
                                                    arrRestaurantId.append(self.restaurantData[i].id)
                                                    selectedIds = arrRestaurantId.joined(separator: ",")
                                                    
                                                    let dict = ["name": self.restaurantData[i].name,"id": self.restaurantData[i].id]
                                                    self.restaurantParam.append(dict)
                                                }
                                            }
                                        }
                                        .background( selectedIds.contains(item.id) ? Constants.AppColor.appPink : Color("red"))
                                        //.background( selectedIds.contains(item.id) ? Color("pink") : Color("registerbg"))
                                        //.clipShape(Capsule())
                                        .cornerRadius(15)
                                    
                                    
                                    if selectedIds.contains(item.id){
                                        Image("cancel")
                                            
                                            .padding([ .bottom])
                                            .padding(.top,-12.5)
                                            .padding(.trailing,-10)
                                            // .padding()
                                            .onTapGesture{
                                                for i in 0..<(self.restaurantData.count) {
                                                    
                                                    if (self.restaurantData[i].name ==  item.name){
                                                        
                                                        //remove data
                                                        if selectedIds.contains(item.id) {
                                                            arrRestaurantId = arrRestaurantId.filter(){$0 != item.id}
                                                            
                                                            selectedIds = arrRestaurantId.joined(separator: ",")
                                                           
                                                            
                                                            restaurantParam = restaurantParam.filter{($0["name"] as! String) != item.name}
                                                            print(restaurantParam)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                    }
                                    
                                } .onAppear{
                                    
                                    //Set selected data from response
                                    for j in 0..<(restaurantParam.count) {
                                        let dict = restaurantParam[j]
                                        if (dict["name"] as! String == item.name){
                                            arrRestaurantId.append(item.id)
                                            selectedIds = arrRestaurantId.joined(separator: ",")
                                            print(selectedIds)
                                        }
                                    }
                                    
                                    //Get user default data
                                    if let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.restaurants) {
                                        do {
                                            // Create JSON Decoder
                                            let decoder = JSONDecoder()
                                            
                                            // Decode Note
                                            let notes = try decoder.decode([LoginDataRestaurant].self, from: data)
                                            print(notes)
                                            
                                            
                                        } catch {
                                            print("Unable to Decode Notes (\(error))")
                                        }
                                    }
                                }
                                .frame(width:150,height: 150)
                                .background( selectedIds.contains(item.id) ? Constants.AppColor.appPink: Color("red"))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius:15)
                                        .stroke(Constants.AppColor.appPink, lineWidth: 2)
                                )
                                
                                
                            }
                        }.padding()
                    }
                }
                
                VStack(alignment: .center, spacing : 16){
                    
                    
                    
                    NavigationLink(
                        destination: BottomMenuView(),
                        label: {
                            Text("See More Sugesstions")
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                                .underline()
                        })
                    
                    NavigationLink( destination: RecordProfileVideo(comingFromEdit: .constant(false), isNewVideo: .constant(false)), isActive: $authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if arrRestaurantId.count == 0 {
                                self.shown = true
                                self.arrValid = [String]()
                                self.arrValid.append(MessageString().restaurant)
                            } else {
                                self.arrValid = [String]()
                                self.shown = false
                                self.UpdateUserProfielService()
                            }
                        }, label: {
                            Image("arrow")
                                .padding()
                                .frame(width : 60,height: 60)
                                .background(Constants.AppColor.appRegisterbg)
                                .cornerRadius(30)
                                .padding()
                        })
                        .alert(isPresented: self.$error) {
                            Alert(title: Text(message))
                        }
                    }
                }
            }.blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            .onAppear{
                self.callRestaurantApi(filter: self.txtSearch)
                let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                restaurantParam = getRegisterDefaultData!["restaurant"] as! [[String : Any]]
            }
            if shown
            {
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            ActivityLoader(isToggle: $restaurantListVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .statusBar(style: .lightContent)
    }
    
    func callRestaurantApi(filter:String) {
        restaurantListVM.callRestaurantApi(limit: "100", pageNo: "1", filter: filter) { result, response,error  in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.restaurantData = response?.data ?? []
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
    
    
    func UpdateUserProfielService(){
        
        restaurantListVM.callUserProfileApi(parameters: selectedIds, type: "restaurants") { result, response,error  in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.authenticate = true
                    UserDefaults.standard.set(true, forKey:Constants.UserDefaults.isSuggestionOpen)
                }
                self.error = false
                UserDefaults.standard.set("profileVideoPath", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["restaurant"] = restaurantParam
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
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



