//
//  SearchPartnerListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchPartnerListView: View {
    //MARK:- Properties
    @State var txtSearch  = ""
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject private var SelectPartnerVM = SelectPartnerViewModel()
    @Environment(\.presentationMode) var presentation
    @State var arrPartner : [PartnerData] = []
    @State private var isActive: Bool = false
    @State var partner : PartnerData?
    @State var totalPoints = Int()
    @Binding var dateTypeVirtual : Bool
    
   
    //MARK:- Body
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment:.leading,spacing: 20) {
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .imageScale(.large)
                            .padding()
                            .padding(.top,40)
                            .padding(.leading)
                    }
                    HStack{
                        Image("serach")
                            .padding([.leading,.top,.bottom])
                        
                        ZStack(alignment: .leading) {
                            if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                            
                            TextField("", text: $txtSearch)
                                .onChange(of: txtSearch) {_ in
                                    
                                    self.GetAllPartnerListService()
                                }
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame( height: 50)
                    .background(Constants.AppColor.applightPink)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Constants.AppColor.appPink, lineWidth:1)
                    )
                    .cornerRadius(25)
                    .padding([.bottom,.leading,.trailing])
                    // SearchBar(text: $txtSearch)
                    
                    Text("Date Suggestions For Yoou")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 17.5))
                        .padding(.leading,10)
                        .padding(.trailing,10)
                    
                    ZStack {
                        NavigationLink(destination: DateRequestView(partnerData: $partner, dateTypeVirtual: $dateTypeVirtual), isActive: $isActive) {
                            
                        }
                   
                        List{
                            ForEach(self.arrPartner.filter({($0.username ?? "").contains(txtSearch.lowercased()) || txtSearch.isEmpty} )) { item in
                                Button(action: {
                                    
                                    self.partner = item
                                    
                                    self.isActive = true
                                }) {
                                    // HStack(){
                                    HStack{
                                        //ZStack{
                                        if (item.profilePicPath ?? "") == ""{
                                            Image("profileplaceholder")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                                .clipped()
                                        }else {
                                            WebImage(url: URL(string: (item.profilePicPath ?? "") ))
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                                .clipped()
                                        }
                                        // }
                                        
                                        Text(item.username ?? "")
                                            .foregroundColor(Constants.AppColor.appBlackWhite)
                                            .fontWeight(.bold)
                                            .font(Font.system(size: 13.5))
                                        
                                        
                                        Spacer()
                                        VStack{
                                            Text("\(self.totalPoints)")
                                            Text("Points")
                                        }
                                    }.onAppear{
                                        self.totalPoints = item.totalPoints ?? 0
                                    }
                                    
                                    //}
                                    .onTapGesture {
                                        
                                        
                                        self.partner = item
                                        
                                        self.isActive = true
                                    }
                                }
                            }
                        }
                    }.navigationBarHidden(true)
                    
                    
                    
                } .navigationBarHidden(true)
                
                
            }
            ActivityLoader(isToggle: $SelectPartnerVM.loading)
            
        }.navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .padding(.bottom,2)
        .alert(isPresented:  $showAlert, title: Constants.AppName, message: self.message, dismissButton: .default(Text("Ok")){ presentation.wrappedValue.dismiss() })
        .onAppear{
            self.GetAllPartnerListService()
        }
    }
    
    //MARK:- Call Api
    func GetAllPartnerListService(){
        self.SelectPartnerVM.GetCreatePartnerListService("100", page: "1") { result, response,error  in
            if result == strResult.success.rawValue{
                self.arrPartner = response?.data ?? []
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
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
