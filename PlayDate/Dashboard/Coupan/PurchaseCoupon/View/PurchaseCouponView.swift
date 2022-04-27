
//
//  GetCouponView.swift
//  PlayDate
//
//  Created by Pranjal on 15/06/21.
//

import SwiftUI

struct PurchaseCouponView: View {
    
    @State var inviteLink = ""
    @State var shareSheetItems: [Any] = []
    @State private var showShareSheet: Bool = false
    @ObservedObject private var PurchaseCouponVM = PurchaseCouponViewModel()
    @Environment(\.presentationMode) var presentation
    @State var txtPoints : Int
    @State var currentPoints : Int
    @State var couponStatus = 0
    @Binding var couponData : CoupanStoreDataModel?
    @State var arrFAQ = [FAQDataModel]()
    @State private var showAlert: Bool = false
    @State private var message = ""
    
    var body: some View {
        ZStack{
            ScrollView(showsIndicators: false){
                VStack(spacing : 0){
                    // ScrollView{
                    VStack(){
                        HStack{
                            BackButton()
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.horizontal)
                        VStack{
                            ////////////  Title ////////
                            if self.couponStatus == 0{
                                CouponTitleText(txtTitle: "Play and Earn")
                            }else if self.couponStatus == 1{
                                CouponTitleText(txtTitle: "Refer your Friends \n and Earn Points")
                                    .frame(height:90)
                            }else if self.couponStatus == 2{
                                CouponTitleText(txtTitle: "Uh oh...\n Something went wrong")
                                    .frame(height:90)
                            }
                            
                            ///////// image ///////////
                            if self.couponStatus == 0 || self.couponStatus == 1{
                                Image("couponsuccess")
                            }else{
                                Image("couponerror")
                            }
                            
                            ///////////  Points //////////
                            Text("\(self.txtPoints) Points")
                                .font(.custom("Arial Rounded MT Bold", size: 25.0))
                                .foregroundColor(.white)
                            //.padding()
                            
                            /////////////// Sub Title ////////
                            if self.couponStatus == 0{
                                CouponSubTitleText(txtSubTitle: "Earn more points by playing Dating Games \n or by answering Small Talk and Deep Talk !")
                                    .frame(height:60)
                            }else if self.couponStatus == 1{
                                CouponSubTitleText(txtSubTitle: "Every time one of your friends signs up, \n you will both receive 25 Points !")
                                    .frame(height:60)
                            }else if self.couponStatus == 2{
                                CouponSubTitleText(txtSubTitle: "It looks like you don't have enough \n points to purchase this coupon")
                                    .frame(height:60)
                            }
                            
                            /////////////// Coupon Code ////////
                            VStack{
                                if self.couponStatus == 0{
                                    Text("GET CODE")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 21.0))
                                        .foregroundColor(.white)
                                        .padding()
                                        .onTapGesture{
                                            self.purchaseCouponService()
                                        }
                                }else if self.couponStatus == 1{
                                    HStack{
                                        VStack{
                                            Text("Your Discount Coupon")
                                                .font(.custom("Arial", size: 12.0))
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text(couponData?.couponCode ?? "")
                                                .fontWeight(.bold)
                                                .font(.custom("Arial", size: 22.0))
                                                .foregroundColor(.white)
                                                .onAppear{
                                                    self.shareSheetItems = [couponData?.couponCode ?? ""]
                                                }
                                        }.padding()
                                        
                                        //Spacer()
                                        Divider()
                                            .frame(maxWidth: 2)
                                            .frame(height : 40)
                                            .background(Color.white)
                                        
                                        Text("Copy\nCode")
                                            .font(.custom("Arial", size: 12.0))
                                            .foregroundColor(.white)
                                            .padding()
                                            .onTapGesture() {
                                                UIPasteboard.general.string = couponData?.couponCode ?? ""
                                            }
                                    }
                                }
                                else if self.couponStatus == 2{
                                    Text("EARN MORE POINTS")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 21.0))
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                
                            }
                            .frame(width: 250, height: 70, alignment: .center)
                            .background(Color.init(hex: "2ED1E2"))
                            .border(Color.white, width: 4)
                            .padding()
                            
                            if self.couponStatus == 0 || self.couponStatus == 1{
                                
                                Text("Share Coupon Code via")
                                    .font(.custom("Arial", size: 14.0))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 45)
                                //.padding()
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.init(hex: "7B0063"),Color.init(hex: "D13A6F") ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(radius: 45, corners: [.bottomLeft, .bottomRight])
                    
                    if self.couponStatus == 0 || self.couponStatus == 1{
                        HStack(spacing : 15){
                            InviteSocialIcon(strIcon: "invitetwitter")
                                .background(Color.blue)
                                .cornerRadius(15.0)
                                .onTapGesture {
                                    if self.couponStatus == 1  {
                                        self.showShareSheet = true
                                    }
                                  
                                }
                            
                            InviteSocialIcon(strIcon: "invitefb")
                                .background(Color.blue)
                                .cornerRadius(15.0)
                                .onTapGesture {
                                    if self.couponStatus == 1 {
                                        self.showShareSheet = true
                                    }
                                }
                            
                            InviteSocialIcon(strIcon: "inviteinsta")
                                .background(Color.gray)
                                .cornerRadius(15.0)
                                .onTapGesture {
                                    if self.couponStatus == 1 {
                                        self.showShareSheet = true
                                    }
                                }
                            
                            InviteSocialIcon(strIcon: "invitemessage")
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .onTapGesture {
                                    if self.couponStatus == 1 {
                                        self.showShareSheet = true
                                    }
                                }
                        }
                        .offset(y :-30)
                    }
                    
                    //  }
                    Spacer()
                    
                    ///////////////// ASKed Question ///////
                    VStack{
                        VStack(alignment : .leading, spacing : 10){
                            HStack{
                                Text("Frequently Asked Questions")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 14.0))
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .padding()
                                
                                Spacer()
                            }
                        }
                        .padding([ .leading, .trailing])
                        
                        ScrollView(showsIndicators: false){
                            
                            ForEach(self.arrFAQ){ item in
                                VStack(alignment:.leading){
                                    HStack{
                                        Text(item.question ?? "")
                                            .font(.custom("Arial", size: 14.0))
                                            .foregroundColor(Constants.AppColor.appBlackWhite)
                                            .padding(.top)
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                    }.onTapGesture {
                                        
                                        for i in 0..<self.arrFAQ.count{
                                            if self.arrFAQ[i].id == item.id{
                                                self.arrFAQ[i].showAnswer = true
                                            }else{
                                                self.arrFAQ[i].showAnswer = false
                                            }
                                        }
                                    }
                                    
                                    if item.showAnswer ?? false {
                                        Text(item.answer ?? "")
                                            .font(.custom("Arial", size: 14.0))
                                            .foregroundColor(Constants.AppColor.appDarkGary)
                                            .padding(.top,5)
                                            .padding(.horizontal)
                                    }
                                    
                                }
                                
                            }
                            
                            .frame(maxWidth: .infinity)
                            .padding([ .leading, .trailing,.bottom])
                        }
                        .padding(.trailing)
                        
                    }
                    
                    
                //    self.shareSheetItems = [couponData?.couponCode ?? ""]
                }
                .sheet(isPresented: $showShareSheet, content: {
                    ActivityViewController(activityItems: self.$shareSheetItems)
                })
                ActivityLoader(isToggle: $PurchaseCouponVM.loading)
            }.onAppear{
                UIScrollView().bounces = false
                UIScrollView().isScrollEnabled = false
            }
        }
        .statusBar(style: .lightContent)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            self.faqCouponService()
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
   
    //MARK:- Call API
    func purchaseCouponService(){
       
        self.PurchaseCouponVM.PurchaseCouponService(couponData?.couponId ?? ""){ result, response,error  in
            
            if result == strResult.success.rawValue{
                self.couponStatus = 1
                self.txtPoints = currentPoints - txtPoints
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.couponStatus = 2
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    func faqCouponService(){
        self.PurchaseCouponVM.FAQCouponService(requestId: couponData?.couponId ?? ""){ result, response,error  in
            if result == strResult.success.rawValue{
                arrFAQ = response?.data ?? [FAQDataModel]()
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

struct CouponTitleText: View {
    @State var txtTitle = ""
    var body: some View {
        Text(self.txtTitle)
            .font(.custom("Arial Rounded MT Bold", size: 30.0))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding([.leading, .bottom, .trailing])
            .lineLimit(2)
    }
}

struct CouponSubTitleText: View {
    @State var txtSubTitle = ""
    var body: some View {
        Text(self.txtSubTitle)
            .fontWeight(.bold)
            .font(.custom("Arial", size: 14.0))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding(.horizontal)
    }
}
