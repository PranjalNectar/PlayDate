//
//  CoupanFeedView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//

import SwiftUI

struct CoupanFeedView: View {
    //MARK:- Properties
    @Binding var menu: Int
    @State private var isNotiActive  = false
    @Binding var txtSearch : String
    @Binding var isSearchClicked : Bool
    @Binding var couponCurrentPoints : Int
    
    //MARK:- Body
    var body: some View {
        
        VStack(){
            Image("PlayDateSmall")
                .padding(.top, 40)
                .padding(.bottom,10)
            
            HStack{
                
                Button(action: {
                    
                    self.menu = 0
                    
                }) {
                    
                    Text("Store")
                        .fontWeight(.bold)
                        .foregroundColor(self.menu == 0 ? .white : .gray)
                        .padding()
                }
                .background(self.menu == 0 ?  Constants.AppColor.appPink : Color.white)
                .frame(height: 30)
                .clipShape(Capsule())
                
                Button(action: {
                    
                    self.menu = 1
                    
                }) {
                    
                    Text("My Coupons")
                        .fontWeight(.bold)
                        .foregroundColor(self.menu == 1 ? .white : .gray)
                        .padding()
                }
                .background(self.menu == 1 ?  Constants.AppColor.appPink : Color.white)
                .frame(height: 30)
                .clipShape(Capsule())
            }
            
            CoupanRestaurantListView(isSearchClicked: $isSearchClicked, txtSearch: $txtSearch).padding([.leading,.trailing],16)
            
            
        } .navigationBarHidden(true)
        .buttonStyle(PlainButtonStyle())
    }
    
    
}


