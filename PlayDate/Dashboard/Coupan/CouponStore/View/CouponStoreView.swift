//
//  CouponStoreView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//

import SwiftUI
import ActivityIndicatorView
import SDWebImageSwiftUI

struct CouponStoreView: View {
    //MARK:- Properties
    @ObservedObject var CoupanStoreVM: CoupanStoreViewModel = CoupanStoreViewModel()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var arrCoupansList = [CoupanStoreDataModel]()
    @State var restaurentData = [CoupanStorRestaurant]()
    @State private var isActive: Bool = false
    @State var couponData : CoupanStoreDataModel?
    @State var isCall = false
    @State var mainData : CoupanStoreAllDataModel?
    @Binding var currentPoints : Int
    @Binding var isSearchClicked : Bool
    @Binding var txtSearch : String
    @State var page = 1
    @State var limit = 20
    
    //MARK:- Body
    var body: some View {
        ZStack{
            ScrollView(showsIndicators: false){
                VStack{
                    
                    if !self.isSearchClicked {
                        ZStack{
                            Image("points")
                                .resizable()
                                .scaledToFill()
                                .padding(.bottom,20)
                            
                            VStack(spacing:0){
                                Text("CURRENT POINTS")
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 22.0))
                                    .padding(.top,20)
                                
                                Text("\(currentPoints)")
                                    .fontWeight(.bold)
                                    .foregroundColor(Constants.AppColor.appPink)
                                    .font(.custom("Helvetica Neue", size: 28.0))
                                    .padding([.leading,.trailing],40)
                                    .padding([.top,.bottom],10)
                                    .background(Color.white)
                                    .frame(height: 40, alignment: .center)
                                    .cornerRadius(12)
                                    .padding(.bottom,10)
                                    .padding(.top,20)
                                
                                LottieView(name: .constant("surprise"))
                                    .frame(width: 50, height: 50, alignment: .center)
                                
                            }
                            
                        }
                    }
                    ForEach(self.arrCoupansList.filter({ txtSearch.isEmpty ? true : $0.couponTitle?.contains(txtSearch) ?? false})) { item in
                        VStack() {
                            
                            NavigationLink(destination: PurchaseCouponView(txtPoints: self.currentPoints, currentPoints: currentPoints, couponData: $couponData), isActive: $isActive) {
                            }
                            HStack(alignment: .center){
                                
                                WebImage(url: URL(string: item.couponImage ?? ""))
                                    .resizable()
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 10){
                                    HStack{
                                        if (item.restaurants ?? [CoupanStorRestaurant]()).count != 0 {
                                            Text((item.restaurants ?? [CoupanStorRestaurant]())[0].username ?? "")
                                                .fontWeight(.bold)
                                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                                .font(.custom("Helvetica Neue", size: 18.0))
                                        }
                                        Spacer()
                                        
                                        if item.purchased?.count != 0 {
                                            LottieView(name: .constant("tick"))
                                                .frame(width: 30, height: 30, alignment: .center)
                                        }
                                    }
                                    
                                    Text(item.couponTitle ?? "")
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                        .font(.custom("Helvetica Neue", size: 14.0))
                                    
                                    Text("\(item.couponPurchasePoint ?? 0) POINTS")
                                        .foregroundColor(Color.white)
                                        .font(.custom("Helvetica Neue", size: 14.0))
                                        .padding(.all,5)
                                        .background(Constants.AppColor.appPink)
                                        .frame(height: 26, alignment: .center)
                                        .cornerRadius(6)
                                }
                            }
                            
                            .onAppear{
                                if self.arrCoupansList.last?.id == item.id{
                                    if self.arrCoupansList.count > limit{
                                        self.page += 1
                                        self.CoupanStoreListService()
                                    }
                                }
                            }
                            
                            .onTapGesture{
                                
                                self.couponData = item
                                self.isActive = false
                                if self.couponData?.purchased?.count != 0 {
                                    self.message = "This coupon is already purchased!"
                                    self.showAlert = true
                                    self.isActive = false
                                }else if currentPoints < item.couponPurchasePoint ?? 0 {
                                    self.message = "Insufficient wallet points to purchase!"
                                    self.showAlert = true
                                    self.isActive = false
                                }else {
                                    self.showAlert = false
                                    self.isActive = true
                                }
                            }
                            .padding(.all,10)
                            
                        }
                        
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Constants.AppColor.appPink, lineWidth: 2)
                        )
                        .padding(.bottom,8)
                    }
                    
                }
            }.padding([.leading,.trailing],20)
            .padding(.top,8)
            ActivityLoader(isToggle: $CoupanStoreVM.loading)
        }
        .onAppear{
            self.arrCoupansList.removeAll()
            CoupanStoreListService()
            self.isCall = true
        }
        
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
    
    //MARK:- Call Api
    func CoupanStoreListService(){
        CoupanStoreVM.GetAllCoupansService(self.limit, page: self.page) { result,response,error  in
            
            if result == strResult.success.rawValue{
                self.mainData = response?.data
                //self.arrCoupansList = response?.data?.coupondata ?? []
                self.currentPoints = response?.data?.account?.currentPoints ?? 0
                
                let arr = response?.data?.coupondata ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrCoupansList.append(arr[i])
                }
                
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
}


