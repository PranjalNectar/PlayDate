//
//  Interest.swift
//  PlayDate
//
//  Created by Pranjal on 26/04/21.
//

import SwiftUI


struct Interest: View {
    @Environment(\.presentationMode) var presentation
    @State var txtSearch  = ""
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Binding var comingFromEdit: Bool
    @State private var error: Bool = false
    @State var message = ""
    @ObservedObject private var interestListVM = InterestListViewModel()
    @State var interestData = [MyInterest]()
    @State var selectedIds = ""
    @State var arrInterestId = [String]()
    @State private var Authenticate: Bool = false
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var interestParam = [[String:Any]]()
    @State private var showAlert: Bool = false
    
   
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                    }
                    Button(action: { }) {
                        Image(systemName: "profileplaceholder")
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                            .imageScale(.large)
                            .padding()
                        
                    }
                    Spacer()
                }
                
                VStack(spacing: 20){
                    HStack{
                        VStack(alignment : .leading ,spacing: 10.0){
                            Text("Interests")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 18.0))
                            
                            Text("Please select your interests")
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Image("search")
                            .padding()
                        ZStack(alignment: .leading) {
                            if txtSearch.isEmpty { Text("Search here...").foregroundColor(Constants.AppColor.appBlack.opacity(0.8)) }
                            TextField("Search here...", text: $txtSearch)
                                .foregroundColor(Color.gray)
                                .onChange(of: txtSearch) {_ in
                                    
                                    callInterestApi(filter: txtSearch)
                                }
                        }
                        
                    }
                    .frame( height: 50)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(25)
                }.padding([.leading, .bottom,.trailing])
                
                VStack(spacing: 25.0){
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing : 30) {
                            ForEach(self.interestData.filter { $0.name.contains(txtSearch.lowercased()) || txtSearch.isEmpty}) { item in
                                ZStack(alignment: .topTrailing){
                                    Text(item.name)
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(width:160,height: 50)
                                        .onTapGesture{
                                            for i in 0..<(self.interestData.count) {
                                                
                                                if (self.interestData[i].name ==  item.name){
                                                    
                                                    arrInterestId.append(self.interestData[i].id)
                                                    selectedIds = arrInterestId.joined(separator: ",")
                                                    
                                                    let dict = ["name": self.interestData[i].name,"id": self.interestData[i].id]
                                                    self.interestParam.append(dict)
                                                }
                                            }
                                        }
                                        
                                        .background( selectedIds.contains(item.id) ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                                        .clipShape(Capsule())
                                    
                                    
                                    if selectedIds.contains(item.id){
                                        Image("cancel")
                                            .padding([.leading, .bottom])
                                            .onTapGesture{
                                                for i in 0..<(self.interestData.count) {
                                                    
                                                    if (self.interestData[i].name ==  item.name){
                                                        
                                                        //remove data
                                                        if selectedIds.contains(item.id) {
                                                            arrInterestId = arrInterestId.filter(){$0 != item.id}
                                                            
                                                            selectedIds = arrInterestId.joined(separator: ",")
                                                            
                                                            interestParam = interestParam.filter{($0["name"] as! String) != item.name}
                                                            print(interestParam)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                    }
                                    
                                }  .onAppear{
                                    
                                    //Set selected data from response
                                    for j in 0..<(interestParam.count) {
                                        let dict = interestParam[j]
                                        if (dict["name"] as! String == item.name){
                                            arrInterestId.append(item.id)
                                            selectedIds = arrInterestId.joined(separator: ",")
                                            print(selectedIds)
                                        }
                                    }
                                    
                                    //Get user default data
                                    if let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.interest) {
                                        do {
                                            // Create JSON Decoder
                                            let decoder = JSONDecoder()
                                            
                                            // Decode Note
                                            let notes = try decoder.decode([LoginDataInterested].self, from: data)
                                            print(notes)
                                            
                                            
                                        } catch {
                                            print("Unable to Decode Notes (\(error))")
                                        }
                                    }
                                }
                            }
                        }.padding()
                    }
                }
                
                VStack(alignment: .center){
                    NavigationLink(destination: Restaurant(comingFromEdit: .constant(false)), isActive: $Authenticate) {
                        
                        Button(action: {
                            //remove redundant values from dictionary
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            var set = Set<String>()
                            interestParam = interestParam.compactMap {
                                guard let name = $0["name"] as? String else { return nil }
                                return set.insert(name).inserted ? $0 : nil
                            }
                            print(interestParam)
                            //remove redundant values fromarray of string
                            arrInterestId = uniqueElementsFrom(array:arrInterestId)
                            
                            print(arrInterestId)
                            selectedIds = arrInterestId.joined(separator: ",")
                            
                            if arrInterestId.count == 0 || arrInterestId.count == 1 {
                                self.shown = true
                                self.arrValid = [String]()
                                self.arrValid.append(MessageString().interest)
                            }else {
                                self.arrValid = [String]()
                                self.shown = false
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
            }.blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
            .onAppear{
                self.callInterestApi(filter: txtSearch)
                
                let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                interestParam = getRegisterDefaultData!["interestList"] as! [[String : Any]]
                
            }
            if shown{
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
            }
            ActivityLoader(isToggle: $interestListVM.loading)
        }
        .statusBar(style: .lightContent)
    }
    
    func callInterestApi(filter:String) {
        interestListVM.callInterestApi(limit: "100", pageNo: "1",filter: filter) { result, response,error  in
            
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.interestData = response?.data ?? []
            }else if result == strResult.error.rawValue{
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
        
        restaurantListVM.callUserProfileApi(parameters: selectedIds, type: "interested") { result, response,error  in
            self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                }
                self.error = false
                
                UserDefaults.standard.set("restaurant", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["interestList"] = interestParam
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
    
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
}

struct InterestText: View {
    var text: String
    public var isSelected = false
    var body: some View {
        ZStack(alignment: .topTrailing){
            Text(text)
                .padding()
                .foregroundColor(.white)
                .clipShape(Capsule())
            if isSelected{
                Image("cancel")
                    .padding([.leading, .bottom])
            }
        }
    }
}

struct BGText: ViewModifier {
    var isSelected = false
    func body(content: Content) -> some View {
        return content
            .background(isSelected ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
    }
}
