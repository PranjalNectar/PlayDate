//
//  AcceptDateListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/06/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct AcceptDateListView: View {
    //MARK:- Properties
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject private var AcceptPartnerVM = AcceptDateListViewModel()
    @Environment(\.presentationMode) var presentation
    @State var arrPartner : [AcceptDateListDataModel] = []
    @State private var isActive: Bool = false
    @State var partner : AcceptDateListDataModel?
    @State var requestID = ""
    @State var status = 0
    
    //MARK:- Body
    var body: some View {
        ZStack{
            
            VStack(alignment:.leading,spacing: 20) {
                Button(action: { presentation.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .imageScale(.large)
                        .padding()
                        .padding(.top,40)
                        .padding(.leading)
                }
                
                Text("Accept Date List")
                    .fontWeight(.semibold)
                    .font(Font.system(size: 17.5))
                    .padding([.leading,.trailing],16)
                
                ZStack {
                    
                    GeometryReader { geometry in
                        List{
                            ForEach(self.arrPartner) { item in
                                
                                HStack{
                                    ZStack{
                                        if (item.profilePicPath ?? "") == "" || (item.profilePicPath ?? "") == nil{
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
                                    }
                                    
                                    Text(item.username ?? "")
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                        .fontWeight(.bold)
                                        .font(Font.system(size: 13.5))
                                    
                                    
                                    Spacer()
                                    HStack(spacing:20){
                                        // Spacer()
                                       
//                                            Button {
//
//                                                callDateUpdateApi(requestID: item.requestId ?? "",status : "Accepted"){ (status) in
//                                                    self.showAlert = true
//                                                }
//
//                                            } label: {
//                                                Image("Icon awesome-check")
//
//
//                                            }.padding()
//
                                            
                                       // }
//                                    .background(Constants.AppColor.appPink)
//                                        .frame(width: 35, height: 25)
//                                        .cornerRadius(12.5)
                                        
                                        
//                                        Button {
//
//
//                                                    callDateUpdateApi(requestID: item.requestId ?? "",status : "Rejected"){ (status) in
//                                                        self.showAlert = true
//                                                    }
//                                                } label: {
//
//
//                                                    Image("Icon metro-cancel")
//
//                                                }.padding()
//
//
//                                            .background(Constants.AppColor.appPink)
//                                            .frame(width: 35, height: 25)
//                                            .cornerRadius(12.5)
                                        
                                        
                                        
                                        Image("Icon awesome-check")

                                            .padding()
                                            .background(Constants.AppColor.appPink)
                                            .frame(width: 35, height: 25)
                                            .cornerRadius(12.5)
                                            .onTapGesture {
                                                callDateUpdateApi(requestID: item.requestId ?? "",status : "Accepted"){ (status) in
                                                    self.showAlert = true
                                                }
                                            }
                                        
                                        
                                        Image("Icon metro-cancel")

                                            .padding()
                                            .background(Constants.AppColor.appPink)
                                            .frame(width: 35, height: 25)
                                            .cornerRadius(12.5)
                                            .onTapGesture {
                                                callDateUpdateApi(requestID: item.requestId ?? "",status : "Rejected"){ (status) in
                                                    self.showAlert = true
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                
                            }.navigationBarHidden(true)
                            
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                        }
                        
                    }
                    
                } .navigationBarHidden(true)
                
                
                
                ActivityLoader(isToggle: $AcceptPartnerVM.loading)
                
            }.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom,2)
            .alert(isPresented:  $showAlert, title: Constants.AppName, message: self.message, dismissButton: .default(Text("Ok")){ presentation.wrappedValue.dismiss() })
            .onAppear{
                self.GetAcceptPartnerListService()
            }
            
        }
        
        //MARK:- Call Api
        func GetAcceptPartnerListService(){
            self.AcceptPartnerVM.GetAcceptPartnerListService("100", page: "1") { result, response,error  in
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
        
        func callDateUpdateApi(requestID:String,status:String,completion: @escaping (Int) -> ()) {
            AcceptPartnerVM.callDateUpdateApi(requestID, status: status) { result, response,error in
                
                self.message = response?.message ?? ""
                if result == strResult.success.rawValue{
                    self.status = 1
                    self.showAlert = true
                }else if result == strResult.error.rawValue{
                    self.status = 0
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

