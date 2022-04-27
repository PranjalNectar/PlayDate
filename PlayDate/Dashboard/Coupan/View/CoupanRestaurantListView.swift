//
//  CoupanRestaurantListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoupanRestaurantListView: View {
    //MARK:- Properties
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State var restaurantData = [MyRestaurantDataModel]()
    @State var isActive = false
    @Binding var isSearchClicked : Bool
    @Binding var txtSearch : String
    
    //MARK:- Body
    var body: some View {
        
        if isSearchClicked{
            
            HStack(spacing:16){
                Image("serach")
                    .padding([.leading,.top,.bottom])
                
                ZStack(alignment: .leading) {
                    if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                    
                    TextField("", text: $txtSearch)
                        .onChange(of: txtSearch) {_ in
                        }
                        .foregroundColor(Color.white)
                }
                
                Image("cancelcross")
                    .onTapGesture {
                        self.isSearchClicked = false
                    }.padding()
            }
            .frame( height: 50)
            .background(Constants.AppColor.applightPink)
            .cornerRadius(25)
            .padding([.top,.bottom],16)
            
        }else{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack( spacing:15) {
                    NavigationLink(destination: UserSearchListView()
                                    .ignoresSafeArea()
                                    .navigationBarHidden(true), isActive: $isActive) {
                        Button(action: {
                            //  self.isActive = true
                            self.isActive = false
                            
                            self.isSearchClicked = true
                            
                        }, label: {
                            if !self.isSearchClicked {
                                VStack{
                                    Image("serach")
                                        // .resizable()
                                        .frame(width: 60, height: 60)
                                        .background(Constants.AppColor.applightPink)
                                        .clipShape(Circle())
                                    
                                    Text("")
                                        .foregroundColor(.black)
                                        .frame(width: 60, alignment: .center)
                                        .font(Font.system(size: 12.5))
                                }
                            }
                            
                        })
                    }
                    
                    
                    ForEach(self.restaurantData) { item in
                        
                        Button(action: {
                        }, label: {
                            VStack(alignment: .center ,spacing:0) {
                                
                                WebImage(url: URL(string: item.image))
                                    .resizable()
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity).accentColor(.pink)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())

                                
                                Text(item.name)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .frame(width: 60, alignment: .center)
                                    .font(Font.system(size: 12.5))
                                    .lineLimit(1)
                            }
                        })
                    }
                }
            }//.frame(maxWidth: .infinity)
            .padding(.top,10)
            .onAppear{
                self.isSearchClicked = false
                self.callRestaurantApi(filter: "")
            }
        }
        
    }
    
    //MARK:- Call api
    func callRestaurantApi(filter:String) {
        restaurantListVM.callRestaurantApi(limit: "100", pageNo: "1", filter: filter) { result, response,error  in
            if result == strResult.success.rawValue{
                self.restaurantData = response?.data ?? []
            }else if result == strResult.error.rawValue{
//                self.authenticate = false
//                self.showAlert = true
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
        }
        
    }
}
