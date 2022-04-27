//
//  CoupanMainView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//

import SwiftUI

struct CoupanMainView: View {
    //MARK:- Properties
    @State var menu = 0
    @State var txtSearch = ""
    @State var isSearchClicked = false
    @State var currentPoints = Int()
    
    //MARK:- Body
    var body: some View {
        ZStack{
            VStack {
                GeometryReader { geometry in
                    VStack{
                        CoupanFeedView(menu: $menu, txtSearch: $txtSearch, isSearchClicked: $isSearchClicked, couponCurrentPoints: $currentPoints)
                        if menu == 0 {
                            CouponStoreView(currentPoints: $currentPoints, isSearchClicked: $isSearchClicked, txtSearch: $txtSearch)
                        }else if menu == 1 {
                            MyCouponView(txtSearch: $txtSearch, currentPoints: $currentPoints, isSearchClicked: $isSearchClicked)
                        }
                        
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }.padding(.bottom,100)
    }
}

