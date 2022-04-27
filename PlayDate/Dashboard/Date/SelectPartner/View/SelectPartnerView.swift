//
//  SelectPartnerView.swift
//  PlayDate
//
//  Created by Pranjal on 11/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SelectPartnerView: View {
  
    @ObservedObject private var SelectPartnerVM = SelectPartnerViewModel()
    @Environment(\.presentationMode) var presentation
   // @State var arrPartner : [PartnerData] = []
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State private var isActive: Bool = false
    @Binding var dateTypeVirtual: Bool
    
    var body: some View {
        
        ZStack{
//            ScrollView(showsIndicators: false) {
//                ScrollViewReader{ proxy in
                    VStack{
                        VStack{
                            HStack{
                                BackButton()
                                Spacer()
                            }
                            HStack(alignment : .top){
                                Image("logo")
                                    //.padding(.top, 100.0)
                                    .frame(height : 100)
                            }
                        }
                        .padding()
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        ZStack{
                            VStack(spacing : 10){
                                CorouselSelectDateView(dateTypeVirtual: $dateTypeVirtual)
                            }
                        }.padding(.top,20)
                        
                        Spacer()
                        Text("OR")
                            .foregroundColor(.white)
                            .font(.custom("Arial", size: 15.0))
                        
                        Spacer()
                        NavigationLink(destination: SearchPartnerListView( dateTypeVirtual: $dateTypeVirtual), isActive: $isActive) {
                            Button(action: {
                                self.isActive = true
                            }) {
                                Text("Search Date Partner")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, height : 50)
                            .background(Constants.AppColor.appPink)
                            .cornerRadius(40.0)
                            .padding()
                            .padding(.bottom, 20)
                        }
                    }
                    
                    ActivityLoader(isToggle: $SelectPartnerVM.loading)
//                }
//            }
            
            //        .onAppear{
            //            self.GetAllPartnerListService()
            //        }
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
//    //MARK:- Call Api
//    func GetAllPartnerListService(){
//        self.SelectPartnerVM.GetCreatePartnerListService("100", page: "1") { result, response,error  in
//            if result == strResult.success.rawValue{
//                self.arrPartner = response?.data ?? []
//            }else if result == strResult.error.rawValue{
//                self.message = response?.message ?? ""
//                self.showAlert = true
//            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
//            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
//            }
//        }
//    }
//}

}
