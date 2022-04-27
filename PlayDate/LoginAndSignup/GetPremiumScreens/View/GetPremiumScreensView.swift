//
//  GetPremiumScreensView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 13/07/21.
//
struct Premiums: Identifiable {
    var id = UUID()
    var images: String
    var colors: Color
    
}

import SwiftUI

struct GetPremiumScreensView: View {
    @Environment(\.presentationMode) var presentation
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "", bg: "")),
        UIHostingController(rootView: Subview(imageString: "", bg: "")),
        UIHostingController(rootView: Subview(imageString: "", bg: ""))
    ]
    var arr = [Premiums(images: "premium1", colors: Constants.AppColor.appPink),Premiums(images: "premium2", colors: Color.yellow),Premiums(images: "premium3", colors: Color.black)]
    
    var images = ["premium1", "premium2", "premium3"]
    
    @ObservedObject private var GetPremiumScreenViewModelVM = GetPremiumScreenViewModel()
    @State private var offset: CGFloat = -200.0
    @State var currentPageIndex = 0
    @State private var animationAmount: CGFloat = 1
    @State var zoomed = false
    @Binding var isPremium: Bool
    //    @Binding var showAlert: Bool
    //    @Binding var message :String
    @State var page = 1
    @State var limit = 100
    @State var getPremiumData = [GetPremiumDataModel]()
//@State var getPremiumItem = GetPremiumDataModel?()
    
    var body: some View {
        ScrollView(showsIndicators: false){
            ZStack(alignment: .center) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        
                        ForEach(self.getPremiumData) { item in
                            
                            GetPreminumsCard(getPremiumItem: item, isPremium: $isPremium)
                           
                        }
                    }
                }
                
            }.background(Color.white)
            
        }.background(Color.white)
        
        .navigationBarHidden(true)
        .onAppear{
            GetPackagesService()
        }
    }
    
    //MARK:- Call Api
    func GetPackagesService() {
        GetPremiumScreenViewModelVM.GetPackagesService(self.limit, page: self.page) { result, responce,error  in
            if result == strResult.success.rawValue{
                self.getPremiumData = responce?.data ?? []
                print(self.getPremiumData)
                for i in 0..<(self.getPremiumData.count) {
                    if i == 0 {
                        self.getPremiumData[i].colors = "pink"
                    }else if i == 1 {
                        self.getPremiumData[i].colors = "yellow"
                    }else {
                        self.getPremiumData[i].colors = "black"
                    }
                }
                
            }else if result == strResult.error.rawValue{
                //                self.message = responce?.message ?? ""
                //                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                //                self.message = MessageString().Network
                //                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                //                self.message = MessageString().NetworkConnection
                //                self.showAlert = true
            }
        }
    }
}

struct GetPreminumsText: View {
    @State var txt = ""
    var body: some View {
        HStack{
            Image("reddot")
            Text(txt)
                .font(.custom("Acumin Pro", size: 17.0))
                .foregroundColor(.black)
        }
    }
}

struct GetPreminumsCard: View {
    @State var getPremiumItem : GetPremiumDataModel
    @Binding var isPremium: Bool
    @State var arrPackageDescription = [PackageDescriptionModel]()
    var body: some View {
        
        VStack{
            HStack{
                Spacer()
                
                Button(action: {
                    
                    self.isPremium = true
                    
                }, label: {
                    Image("premiumcross")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                    
                    
                })
                .padding(.trailing,20)
            }.onAppear{
                arrPackageDescription = [PackageDescriptionModel]()
                arrPackageDescription = getPremiumItem.packageDescription ?? [PackageDescriptionModel]()
                print(arrPackageDescription)
                
                
            }
            .onChange(of: getPremiumItem.packageType) { (value) in
                arrPackageDescription = [PackageDescriptionModel]()
                arrPackageDescription = getPremiumItem.packageDescription ?? [PackageDescriptionModel]()
                print(arrPackageDescription)
            }
            if getPremiumItem.packageType == "Silver"{
                Image("premium1")
            }else if getPremiumItem.packageType == "Diamond"{
                Image("premium2")
            }else {
                Image("premium3")
            }
            // Image(item.images)
            // .offset(y:6)
            VStack(spacing : 20){
                VStack{
                    Image("dimond")
                    Text("GET PREMIUM")
                        //.fontWeight(.medium)
                        .font(.custom("Acumin Pro", size: 24.0))
                        .foregroundColor(.black)
                }
                
                //  VStack(spacing : 16){
                
                //GetPreminumsText(txt: item.packageDescription)
                ForEach(self.arrPackageDescription) { item1 in
                    VStack(spacing : 16){
                        GetPreminumsText(txt: item1.packageDescription ?? "")
                    }
                }
                
                VStack{
                    if getPremiumItem.packageType == "Silver"{
                        Text("Get Now")
                            .padding()
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Constants.AppColor.appPink, lineWidth: 2)
                            )
                    }else if getPremiumItem.packageType == "Diamond"{
                        Text("Get Now")
                            .padding()
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                    }else {
                        Text("Get Now")
                            .padding()
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(getPremiumItem.packageType == "Silver" ? Constants.AppColor.appPink : getPremiumItem.packageType == "Diamond" ? Color.yellow : Color.black, lineWidth: 6)
            )
            .background(Color.white)
            
        }.background(Color.white)
        
        .frame(width: UIScreen.main.bounds.width - 40)
        .padding([.leading,.trailing],20)
    }
}
