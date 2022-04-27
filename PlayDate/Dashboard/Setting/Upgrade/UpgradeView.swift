//
//  UpgradeView.swift
//  PlayDate
//
//  Created by Pranjal on 30/04/21.
//

import SwiftUI

struct UpgradeView: View {
    var body: some View {
        VStack(spacing: 40){
            Text("Premium Plan Upgrade")
                .font(.custom("Arial Rounded MT Bold", size: 20.0))
                .foregroundColor(Constants.AppColor.appPink)
                .multilineTextAlignment(.center)
                .padding()
            
            Image("upgradelogo")
            
            VStack (spacing: 20){
                upgradetext(txt: "5 Play Coins Every Month")
                upgradetext(txt: "5 DM Power Ups Every Month")
                upgradetext(txt: "1 Point Multiplier Unlocked")
                upgradetext(txt: "Exclusive Discounts to Events and \nLocations")
                upgradetext(txt: "Unlimited Game Access")
            }
            
            HStack(alignment : .top, spacing : 20){
                VStack(alignment : .center){
                    Text("Monthly \nPlan")
                        .multilineTextAlignment(.center)
                        .font(.custom("Arial", size: 15.0))
                    Text("$10.99")
                        .font(.custom("Arial Bold", size: 15.0))
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Constants.AppColor.appPink, lineWidth: 2)
                )
                ZStack(alignment : .top){
                    
                    VStack(alignment : .center){
                        Text("Semi -  Annual\nPlan")
                            .foregroundColor(.white)
                            .font(.custom("Arial Bold", size: 15.0))
                            .multilineTextAlignment(.center)
                        Text("$10.99")
                            .foregroundColor(.white)
                            .font(.custom("Arial Bold", size: 20.0))
                    }.padding()
                    .frame(width: 130, height: 120, alignment: .center)
                    .background(Constants.AppColor.appPink)
                    .cornerRadius(8)
                    
                    
                    Image("upgradediamond")
                        .offset(y:-30)
                }
                
                
                VStack(alignment : .center){
                    Text("Yearly \nPlan")
                        .multilineTextAlignment(.center)
                        .font(.custom("Arial", size: 15.0))
                    Text("$10.99")
                        .font(.custom("Arial Bold", size: 15.0))
                }.padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Constants.AppColor.appPink, lineWidth: 2)
                )
                
            }
         
        }
    }
}


struct upgradetext: View {
    @State var txt = ""
    var body: some View {
        HStack{
            Image("upgradecheck")
            Text(txt)
                .font(.custom("Arial Bold", size: 18.0))
        }
    }
}


struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
