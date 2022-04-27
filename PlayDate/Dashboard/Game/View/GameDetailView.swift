//
//  GameDetailView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 08/07/21.
//

import SwiftUI

struct GameDetailView: View {
    @Environment(\.presentationMode) var presentation
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack{
            ScrollView(showsIndicators: false){
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
                    
                }
                // .padding()
                .padding(.top,20)
                
                HStack(alignment:.center){
                    VStack(spacing:10){
                        Button(action: {  }) {
                            Image("")
                        }.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        
                        Button(action: {  }) {
                            Image("")
                        }.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        
                        Button(action: {  }) {
                            ZStack{
                                Image("dollar")
                                Image("Repeat Grid 7")
                            }
                          
                        }.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        
                        Button(action: {  }) {
                            ZStack{
                            Image("dollar")
                            Image("messenges")
                            }
                        }.frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                    }
                    
                    Text("36 Questions To Fall In Love")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.custom("Antarctican Mono", size: 26.0))
                    
                    
                    VStack(spacing:10){
                        Button(action: {  }) {
                            ZStack{
                            Image("dollar")
                            Image("shopping-cart")
                            }
                        } .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        Button(action: {  }) {
                            
                            Image("game2")
                        } .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        Button(action: {  }) {
                            ZStack{
                            Image("dollar")
                            Image("video-game")
                            }
                        } .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        NavigationLink(destination: GameStoreView(), isActive: $isActive) {
                            
                        }
                        Button(action: {
                            isActive = true
                        }) {
                            ZStack{
                            Image("dollar")
                            Image("game3")
                            }
                        } .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    }
                   
                }
                
              //  Spacer()
                
                Image("solid")
                    .padding(.top,-30)
                Spacer()
                
                Button(action: {  }) {
                    Text("START GAME")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.custom("Antarctican Mono", size: 30.0))
                }
                .padding(.bottom,16)
                
            }
            
            
            //  ActivityLoader(isToggle: $SelectPartnerVM.loading)
        }
    }
        //   .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Constants.AppColor.applightPink)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

