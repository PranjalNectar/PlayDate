//
//  MyCouponView.swift
//  PlayDate
//
//  Created by Pranjal on 15/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyCouponView: View {
    //MARK:- Properties
    @ObservedObject var MyCoupanVM: MyCouponViewModel = MyCouponViewModel()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var arrCoupansList = [MyCoupanDataModel]()
    @State var isCallApi = false
    @Binding var txtSearch : String
    @State var mainData : MyCoupanAllDataModel?
    @Binding var currentPoints : Int
    @Binding var isSearchClicked : Bool
    
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
                                // .padding(.all,20)
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

                    ForEach(self.arrCoupansList.filter({$0.couponTitle!.contains(txtSearch.lowercased()) || txtSearch.isEmpty} )) { item in
                        ZStack{
                            Image("mycouponbg")

                            HStack(spacing : 0){
                                VStack(alignment:.leading){
                                if (item.restaurants ?? [MyCoupanRestaurant]()).count != 0 {
                                    WebImage(url: URL(string: item.restaurants?[0].businessImage ?? ""))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .padding(.top , 38)
                                        .padding(.bottom , 36)
                                        .padding(.leading , 18)
                                        .padding(.trailing , 10)
                                }  else {
                                    WebImage(url: URL(string: ""))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .padding(.top , 38)
                                        .padding(.bottom , 36)
                                        .padding(.leading , 18)
                                        .padding(.trailing , 10)
                                }
                                }
                                Spacer()
                                VStack(alignment:.leading){

                                    Text(item.couponTitle ?? "")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 16.0))
                                        .padding(.vertical, 8)

                              //      Text(item.couponDescription ?? "")
                                       // .font(.custom("Arial", size: 12.0))
                                     //  .padding(.bottom, 4)

                                    Text("Valid until \(common.getDateInFormate(date: common.getDateFromString(strDate: item.couponValidTillDate ?? "")))")
                                        .font(.custom("Arial", size: 10.0))
                                        .padding(.bottom, 4)
                                    HStack{
                                        VStack{
                                            Text("Your Discount Coupon")
                                                .font(.custom("Arial", size: 10.0))
                                                .foregroundColor(.white)

                                            Text(item.couponCode ?? "")
                                                .fontWeight(.bold)
                                                .font(.custom("Arial", size: 18.0))
                                                .foregroundColor(.white)
                                        }
                                        //Spacer()
                                        Divider()
                                            .frame(maxWidth: 2)
                                            .frame(height : 20)
                                            .background(Color.white)

                                        Text("Copy\nCode")
                                            .font(.custom("Arial", size: 10.0))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 150, height: 40, alignment: .center)
                                    .background(Constants.AppColor.appPink)
                                    .padding(.bottom, 4)
                                }
                                .padding(.top , 24)
                                .padding(.bottom , 21)
                                .padding(.leading , 8)
                                .padding(.trailing , 40)
                            }
                            .frame(width : 300, height: 150)
                            ActivityLoader(isToggle: $MyCoupanVM.loading)
                        }.alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
                    }
                }
            }.padding([.leading,.trailing],20)
        }
        .onAppear{
            self.MyCoupanListService()
            self.isCallApi = true
        }
    }
    
    //MARK:- Call Api
    func MyCoupanListService(){
        MyCoupanVM.GetMyCoupansService() { result, response,error  in
            
            if result == strResult.success.rawValue{
                self.mainData = response?.data
                self.arrCoupansList = response?.data?.coupondata ?? []
                self.currentPoints = response?.data?.account?.currentPoints ?? 0
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


