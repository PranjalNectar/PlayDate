//
//  ThankYouPageView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 22/06/21.
//

import SwiftUI

struct ThankYouPageView: View {
    //MARK:- Properties
    @Environment(\.presentationMode) var presentation
    
    //MARK:- Body
    var body: some View {
        ZStack{
            Image("darkGrayBG")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            LottieView(name: .constant("blast"))
            
            VStack(alignment:.center, spacing:30){
                ZStack{
                    Image("medal")
                    Image("questionMark").padding(.top,-50)
                }
                Text("Thank you for your answer!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.custom("Helvetica Neue", size: 25.0))
                    .multilineTextAlignment(.center)
                
                Text("Its's nice to be helpful")
                    .foregroundColor(.white)
                    .font(.custom("Helvetica Neue", size: 18.0))
                
                VStack{
                    Text("Level 1")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Helvetica Neue", size: 20.0))
                    ZStack{
                        
                        Image("pointsBG")
                        HStack{
                            Text("+ 50")
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appPink)
                                .font(.custom("Helvetica Neue", size: 18.0))
                                .padding()
                                .frame(height: 40)
                                .background(Color.white)
                                .cornerRadius(20)
                            
                            Spacer()
                        }
                    }
                }
                
                Image("matchNo")
                    .onTapGesture {
                        presentation.wrappedValue.dismiss()
                    }
            }
            .padding([.leading,.trailing],30)
            
        }.navigationBarHidden(true)
    }
}

struct ThankYouPageView_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouPageView()
    }
}
