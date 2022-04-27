//
//  ChatRequestView.swift
//  PlayDate
//
//  Created by Pranjal on 21/06/21.
//

import SwiftUI

struct ChatRequestView: View {
    var body: some View {
        HStack{
            ZStack(alignment:.top){
                Image("dumy")
                    .cornerRadius(25)
            }
            .frame(width : 50, height: 50)
            Spacer(minLength: 8)
            VStack(alignment:.leading){
                Text("KatyWilliams22")
                    .fontWeight(.bold)
                    .font(.custom("Arial", size: 16.0))
                Text("Wants to send you a message")
                    .font(.custom("Arial", size: 14.0))
            }
            Spacer()
            HStack(spacing : 10){
                Image("raccept")
                    .padding()
                    .frame(width: 25, height: 25)
                    .background(Constants.AppColor.appPink)
                    .clipShape(Circle())
                    
                Image("rreject")
                    .padding()
                    .frame(width: 25, height: 25)
                    .background(Constants.AppColor.appPink)
                    .clipShape(Circle())
                   
            }
            .frame(width : 50, height: 50)
           
        }
        .padding(.horizontal)
    }
}


