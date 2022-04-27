//
//  BusinessCouponHeaderView.swift
//  PlayDate
//
//  Created by Pranjal on 21/07/21.
//

import SwiftUI

struct BusinessCouponHeaderView: View {
    
    @Binding var menu: Int
    @State private var isNotiActive  = false
    @State private var isGenerateActive  = false
    @ObservedObject private var notificationVM = NotificationViewModel()
    @State var notiCount = ""
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image("PlayDateSmall")
                    .padding(.vertical, 10)
                Spacer()
            }
            
            HStack{
                Button(action: {
                    self.menu = 0
                }){
                    Text("Coupons")
                        .fontWeight(.bold)
                        .foregroundColor(self.menu == 0 ? .white : .gray)
                        .padding()
                }
                .background(self.menu == 0 ?  Constants.AppColor.appPink : Color.white)
                .frame(height: 30)
                .clipShape(Capsule())
                ZStack {
                    Button(action: {
                        self.isGenerateActive = true
                    }){
                        Text("Generator")
                            .fontWeight(.bold)
                            .foregroundColor(self.menu == 1 ? .white : .gray)
                            .padding()
                    }
                    .background(self.menu == 1 ?  Constants.AppColor.appPink : Color.white)
                    .frame(height: 30)
                    .clipShape(Capsule())
                    
                    NavigationLink(
                        destination: CouponGeneratorView(comingFromEdit: .constant(false)),
                        isActive: $isGenerateActive,
                        label: {
                        })
                        .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                }
                
                Spacer()
                ZStack {
                    Button(action: {
                        self.isNotiActive = true
                    }) {
                        ZStack(alignment : .topTrailing){
                            Image("bel")
                                .padding()
                            if self.notiCount != "" && self.notiCount != "0"{
                                Text(self.notiCount)
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 10))
                                    .foregroundColor(.white)
                                    .padding(2)
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .background(Color("pink"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(.white), lineWidth: 4)
                                    )
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(height: 30)
                    NavigationLink(
                        destination: NotificationView(),
                        isActive: $isNotiActive,
                        label: {
                        })
                        .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear{
            self.GetNotificationCount()
        }
    }
    
    func GetNotificationCount(){
        DispatchQueue.global(qos: .background).async {
            self.notificationVM.GetNotificationCount { result, response,error in
                if response?.data?[0].totalUnreadNotification ?? 0 < 100{
                    self.notiCount = "\(response?.data?[0].totalUnreadNotification ?? 0)"
                }else{
                    self.notiCount = "99+"
                }
            }
        }
    }
}


