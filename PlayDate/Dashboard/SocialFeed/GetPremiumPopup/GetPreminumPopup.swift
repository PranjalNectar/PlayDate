//
//  GetPreminumPopup.swift
//  PlayDate
//
//  Created by Pranjal on 09/06/21.
//

import SwiftUI

struct GetPreminumPopup: View {
    
    @Environment(\.presentationMode) var presentation
    @Binding var isShowPremiumPopup: Bool
    @Binding var isTimerRunning: Bool
    @Binding var timeRemaining : Int
    
    var body: some View {
        //Color(.clear).opacity(0.5)
            
        ZStack(alignment : .topTrailing)
        {
            VStack{
                Image("premiumlogo")
                    .offset(y:6)
                VStack(spacing : 20){
                    VStack{
                        Image("dimond")
                        Text("GET PREMIUM")
                            //.fontWeight(.medium)
                            .font(.custom("Acumin Pro", size: 24.0))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing : 16){
                        GetPreminumText(txt: "Virtual or Real Dates")
                        GetPreminumText(txt: "Dating Games")
                        GetPreminumText(txt: "1000's of New Chats Unlocked")
                        GetPreminumText(txt: "Exclusive Content Unclocked")
                        GetPreminumText(txt: "See Top Fans Stats")
                    }
                    VStack{
                        Text("Get Now")
                            .padding()
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Constants.AppColor.applightPink, lineWidth: 4)
                            )
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Constants.AppColor.applightPink, lineWidth: 2)
                )
                .padding(.all, 5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Constants.AppColor.appPink, lineWidth: 2)
                )
            }
            
            Button(action: {
                self.isTimerRunning = true
                self.isShowPremiumPopup = false
                self.timeRemaining = 200
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Image("premiumcross")
                    .padding()
            })
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.black).opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}




struct GetPreminumText: View {
    @State var txt = ""
    var body: some View {
        HStack{
            Image("reddot")
            Text(txt)
                .font(.custom("Acumin Pro", size: 17.0))
                .foregroundColor(.white)
        }
    }
}
