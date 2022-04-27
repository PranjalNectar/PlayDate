//
//  BusinessCouponActiveTabView.swift
//  PlayDate
//
//  Created by Pranjal on 21/07/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BusinessCouponActiveTabView: View {
    
    var ComeFrom = ""
    @State var CouponData : BusinessCoupopnData?
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                WebImage(url: URL(string: CouponData?.couponImage ?? ""))
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding([.top, .leading], 8)
                    .padding(.bottom, 10)
          
                VStack(alignment: .leading, spacing: 10){
                    Text(CouponData?.user?[0].fullName ?? "")
                            .fontWeight(.bold)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .font(.custom("Arial", size: 18.0))
                            .padding(.trailing)
                    Text(CouponData?.couponTitle ?? "")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .font(.custom("Arial", size: 14.0))
                        .padding(.trailing)
                    if self.ComeFrom == "Active"{
                        HStack{
                            Text("Live")
                                .foregroundColor(Color.white)
                                .font(.custom("Arial", size: 14.0))
                                .padding(.horizontal, 8)
                                .background(Constants.AppColor.appPink)
                                //.frame(height: 26, alignment: .center)
                            Spacer()
                            Text("Expires " + common.getDateFromString(strDate: CouponData?.couponValidTillDate ?? "").toString(dateFormat: "dd/MM"))
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .font(.custom("Arial", size: 14.0))
                                .padding(.horizontal)
                        }
                    }else{
                        HStack{
                            Text("EXPIRED")
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .font(.custom("Arial", size: 14.0))
                                
                            Spacer()
                           Image("bs_exchange")
                            .padding(.horizontal)
                            
                        }
                    }
                }
            }
            
//            .onAppear{
//                if self.arrCoupansList.last?.id == item.id{
//                    if self.arrCoupansList.count > limit{
//                        self.page += 1
//                        self.CoupanStoreListService()
//                    }
//                }
//            }
            
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 0).stroke(Constants.AppColor.appPink, lineWidth: 2)
        )
        .padding(.bottom,8)

    }
}

struct BusinessCouponActiveTabView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCouponActiveTabView()
    }
}
