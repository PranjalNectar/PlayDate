//
//  ChatInboxOptionPopup.swift
//  PlayDate
//
//  Created by Pranjal on 21/06/21.
//

import SwiftUI

struct ChatInboxOptionPopup: View {
    
    @Environment(\.presentationMode) var presentation
    @Binding var isHide : Bool
    @Binding var selectedOption : Int
    
    var body: some View {
        ZStack(alignment : .topTrailing)
        {
            VStack{
                HStack{
                    Spacer()
                    Image("premiumcross")
                        .padding()
                        .padding(.top, 20)
                        .onTapGesture {
                            //self.presentation.wrappedValue.dismiss()
                            self.isHide = false
                        }
                }
                .padding()
                Spacer()
                VStack{
                    HStack{
                        Text("Delete message")
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.selectedOption = 1
                                self.isHide = false
                            }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top)
                    
                    HStack{
                        Text("Block User")
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.selectedOption = 2
                                self.isHide = false
                            }
                        Spacer()
                        Image("block")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top)
                    
                    HStack{
                        Text("Report User")
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.selectedOption = 3
                                self.isHide = false
                            }
                        Spacer()
                        Image("report")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top)
                    
                    HStack{
                        Text("View Profile")
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.selectedOption = 4
                                self.isHide = false
                            }
                        Spacer()
                    }
                    .padding()
                }
                .frame(maxWidth : .infinity)
                .background(Constants.AppColor.appDarkGary)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.black).opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}

