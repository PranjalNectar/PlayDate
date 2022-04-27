//
//  Setting.swift
//  PlayDate
//
//  Created by Pranjal on 29/04/21.
//

import SwiftUI

struct SettingView: View {
    @State var showingAddCard = false
    @State var showingUpgrade = false
    @State var menu = 0
    
    var body: some View {
     //   NavigationView{
            VStack{
                
                    Image("PlayDateSmall")
                        //.padding(.top,40)
                    HStack{
                        Text("Account")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(self.menu == 0 ? .white : Color.gray)
                            .background(self.menu == 0 ?  Constants.AppColor.appPink : Color.white)
                            .frame(height: 40)
                            .clipShape(Capsule())
                            .onTapGesture {
                                self.menu = 0
                                self.showingUpgrade = false
                            }
                        Spacer()
                        if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                            Text("Personal")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(self.menu == 1 ? .white : Color.gray)
                                .background(self.menu == 1 ?  Constants.AppColor.appPink : Color.white)
                                .frame(height: 40)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    self.menu = 1
                                    self.showingUpgrade = false
                                }
                            Spacer()
                            Text("Payment")
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(self.menu == 2 ? .white : Color.gray)
                                .background(self.menu == 2 ? Constants.AppColor.appPink : Color.white)
                                .frame(height: 40)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    self.menu = 2
                                }
                        }
                    }.padding()
                ScrollView(showsIndicators: false){
                    if self.menu == 0{
                        if !showingUpgrade{
                            AccountView(isPresentedUpgrade: $showingUpgrade)
                        }else{
                            UpgradeView()
                        }
                    }
                    if self.menu == 1{
                        if !showingUpgrade{
                            PersonalView(isPresentedUpgrade: $showingUpgrade)
                        }else{
                            UpgradeView()
                        }
                        
                    }
                    if self.menu == 2{
                        if showingAddCard{
                            AddPaymentView(isAddPayment: $showingAddCard)
                        }else{
                            PaymentView(isPresentedAddPayment: $showingAddCard)
                        }
                    }
                }
                //.edgesIgnoringSafeArea(.all)
            }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
