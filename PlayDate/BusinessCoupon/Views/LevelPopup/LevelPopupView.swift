//
//  LevelPopupView.swift
//  PlayDate
//
//  Created by Pranjal on 22/07/21.
//

import Foundation
import SwiftUI

extension CouponGeneratorView{
    
    public var LevelPopupView: some View {
        
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "multiply.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding(.all, 5)
                        .onTapGesture {
                            self.isLevelpopupShow = false
                        }
                }
                .padding(.top, 50)
                .padding(.horizontal)
                Spacer()
                
                VStack(spacing : 100){
                    Text("Choose Level")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Arial", size: 28.0))
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.LevelCount > 1{
                                self.LevelCount -= 1
                                self.lblLevelCount = "\(self.LevelCount)"
                            }
                        }, label: {
                            Text("-")
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appPink)
                                .font(.custom("Roboto", size: 70.0))
                        })
                        Spacer()
                        Text(lblLevelCount)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Roboto", size: 70.0))
                        Spacer()
                        Button(action: {
                            self.LevelCount += 1
                            self.lblLevelCount = "\(self.LevelCount)"
                        }, label: {
                            Text("+")
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appPink)
                                .font(.custom("Roboto", size: 70.0))
                        })
                        Spacer()
                    }
                    
                    Button(action: {
                        self.isLevelpopupShow = false
                    }, label: {
                        Text("Confirm")
                            .padding()
                            .foregroundColor(.white)
                            .frame(height: 50)
                    })
                    .frame(width: 300)
                    .background(Constants.AppColor.appPink)
                    .clipShape(Capsule())
                    .padding()
                }
                
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.black).opacity(0.9))
        //.edgesIgnoringSafeArea(.all)
    }
}
