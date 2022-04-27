//
//  DateRequestView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 22/06/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct DateRequestView: View {
    
    @ObservedObject private var SelectPartnerVM = SelectPartnerViewModel()
    @Environment(\.presentationMode) var presentation
    @Binding var partnerData : PartnerData?
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State private var isAccpected: Bool = false
    @State private var isActive: Bool = false
    @State var requestId = ""
    @State private var controller: Controller = .Person
    @Binding var dateTypeVirtual: Bool
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack{
                        BackButton()
                        Spacer()
                        
                        Image("smallCross")
                            .onTapGesture{
                                self.DeleteDateRequestPartnerService()
                            }.padding(.trailing,10)
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
                
                VStack(spacing : 8){
                    
                    Image("crown")
                    
                    WebImage(url: URL(string: partnerData?.profilePicPath ?? ""))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity)
                        .aspectRatio(contentMode: .fill)
                        .padding(.all,4)
                        .frame(width: partnerData?.show ?? false ? 200 : 180, height: partnerData?.show ?? false ? 200 : 180)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: partnerData?.show ?? false ? 100 : 90)
                                .stroke(Constants.AppColor.appPink.opacity(0.7), lineWidth: 10)
                        )
                        
                        .cornerRadius(partnerData?.show ?? false ? 100 : 90)
                    
                    
                    Text("\(partnerData?.totalPoints ?? 0) points")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.custom("Antarctican Mono", size: 24.0))
                        .frame(width: partnerData?.show ?? false  ? 200 : 180)
                        .padding(.top,10)
                    Text(partnerData?.username ?? "")
                        .foregroundColor(.white)
                        .font(.custom("Arial", size: 15.0))
                        .frame(width: partnerData?.show ?? false ? 200 : 180)
                    
                }
                
                Spacer()
                if isAccpected == false {
                    ActivityLoader(isToggle: .constant(true))
                    Text("Waiting for partner...")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.custom("Antarctican Mono", size: 24.0)).onTapGesture{
                            self.isAccpected = true
                        }
                    
                }else {
                 
                    NavigationLink(destination: chooseDestination(), isActive: $isActive) {
                        
                    }
                    Image("purple-check")
                    Text("Partner has accepted")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.custom("Antarctican Mono", size: 24.0))
                        .onTapGesture {
                            selectController()
                            self.isActive = true
                        }
                }
                
                Spacer()
            }
            
            
            ActivityLoader(isToggle: $SelectPartnerVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        
        .onAppear {
            self.PostDateRequestPartnerService()
        }
        
        
    }
    
    //MARK:- Call Api
    func PostDateRequestPartnerService(){
        self.SelectPartnerVM.RequestToPartnerService("\(partnerData?.id ?? "")") { result, response,error  in
            if result == strResult.success.rawValue{
                self.message = response?.message ?? ""
                self.requestId = response?.data?.requestId ?? ""
                self.showAlert = true
               // self.isAccpected = true
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
    
    //MARK:- Call Api
    func DeleteDateRequestPartnerService(){
        self.SelectPartnerVM.DeleteRequestToPartnerService( self.requestId) { result, response,error  in
            if result == strResult.success.rawValue{
                // self.message = response?.message ?? ""
                //  self.showAlert = true
                presentation.wrappedValue.dismiss()
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
    
    enum Controller {
        case Person, Virtual
    }
    
    @ViewBuilder
    func chooseDestination() -> some View {
        switch controller {
        case .Person: DateLocationView()
        default: VirtualRestaurantListView()
        }
    }
    
    func selectController(){
        if dateTypeVirtual {
            controller = .Virtual
        }else{
            controller = .Person
        }
    }
}
