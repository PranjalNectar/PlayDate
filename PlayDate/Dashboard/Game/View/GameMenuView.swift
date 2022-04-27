//
//  GameMenuView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 07/07/21.
//

import SwiftUI

struct GameMenuView: View {
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 16){
                VStack{
                    HStack{
                    
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image("stage_white")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding()
                        }
                       
                        Spacer()
                        Image("Icon ionic-md-timer_white")
                        Text("29:59")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                        Image("smallCross")
                            .onTapGesture{
                              //  self.DeleteDateRequestPartnerService()
                            }.padding(.trailing,16)
                    }
                    HStack(alignment : .top){
                        Image("logo")
                            //.padding(.top, 100.0)
                            .frame(height : 100)
                    }
                }
               // .padding()
                .padding(.top,20)
                
                Text("Choose your game")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.custom("Antarctican Mono", size: 24.0))
                    .padding(.bottom, 10)
                GameTabView()
                
                Spacer()
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

