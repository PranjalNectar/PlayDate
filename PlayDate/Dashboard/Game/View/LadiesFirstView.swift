//
//  LadiesFirstView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 08/07/21.
//

import SwiftUI

struct LadiesFirstView: View {
    var body: some View {
        ZStack{
            Image("blackBg")
//            BackButton()
//                .padding(.bottom,20)
         //   Spacer()
            VStack(spacing:20){
                
                //Spacer()
                Image("finger")
                   
                Text("Ladies First")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.custom("Antarctican Mono", size: 24.0))
                Text("Kayla chooses the First game")
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .font(.custom("Antarctican Mono", size: 18.0))
               // Spacer()
            }.padding(.top,20)
           // Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct LadiesFirstView_Previews: PreviewProvider {
    static var previews: some View {
        LadiesFirstView()
    }
}
