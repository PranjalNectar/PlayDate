//
//  MainBusinessCouponView.swift
//  PlayDate
//
//  Created by Pranjal on 21/07/21.
//

import SwiftUI

struct MainBusinessCouponView: View {
    
    @State var menu = 0
    @State var txtSearch  = ""
    var tabs = ["Active","Expired"]
    @State var selectedTab = "Active"
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var arrBusinessCouppon : [BusinessCoupopnData] = []
    @ObservedObject var BusinessCouponVM = BusinessCouponViewModel()
    @State var isGenerateActive  = false
    @State var page = 1
    @State var limit = 10
    @State var selectedData : BusinessCoupopnData?
   
    var body: some View {
        ZStack{
            VStack{
                BusinessCouponHeaderView(menu: $menu)
                    .padding(.horizontal)
                
                HStack{
                    Image("serach")
                        .padding([.leading,.top,.bottom])
                    
                    ZStack(alignment: .leading) {
                        if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                        
                        TextField("Search here...", text: $txtSearch)
                            .onChange(of: txtSearch) {_ in
                            }
                            .foregroundColor(Color.white)
                    }
                }
                .frame( height: 50)
                .background(Constants.AppColor.applightPink)
                .cornerRadius(25)
                .padding()
                
                BusinessCouponTabView
            }
            NavigationLink(
                destination: CouponGeneratorView(CouponData : self.selectedData, comingFromEdit: .constant(true)),
                isActive: $isGenerateActive,
                label: {
                })
                .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
            
            ActivityLoader(isToggle: $BusinessCouponVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            self.arrBusinessCouppon.removeAll()
            self.page = 1
            self.GetBusinessCouponService()
        }
        .onChange(of: self.selectedTab) { value in
            self.arrBusinessCouppon.removeAll()
            self.page = 1
            self.GetBusinessCouponService()
        }
    }
    
    func GetBusinessCouponService() {
        BusinessCouponVM.GetCouponService(self.limit, page: self.page, status : selectedTab) { result, response,error  in
            if result == strResult.success.rawValue{
                let arr = response?.data ?? []
                print(arr.count)
                if arr.count != 0{
                    for i in 0..<arr.count {
                        self.arrBusinessCouppon.append(arr[i])
                    }
                }
//                else{
//                    self.message = "Coupons not available"
//                    self.showAlert = true
//                }
                print(self.arrBusinessCouppon.count)
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
    
    func DeleteBusinessCouponService(couponid : String) {
        BusinessCouponVM.DeleteCouponService(couponid) { result, response,error  in
            if result == strResult.success.rawValue{
                self.arrBusinessCouppon.removeAll()
                self.page = 1
                self.GetBusinessCouponService()
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
