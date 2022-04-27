//
//  VirtualRestaurantListView.swift
//  PlayDate
//
//  Created by Pranjal on 10/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct VirtualRestaurantListView: View {

    @State private var isDetail: Bool = false
    
    @ObservedObject private var DateRestaurantVM = DateRestaurantViewModel()
    @Environment(\.presentationMode) var presentation
    
    @State var arrRestaurants : [DateRestaurantData] = []
    @State var selectedRestaurantData : DateRestaurantData?
    @State private var showAlert: Bool = false
    @State private var message = ""
    
    var body: some View {
        ZStack{
            VStack(spacing : 10){
                VStack{
                    HStack{
                        BackButton()
                        Spacer()
                    }
                    HStack(alignment : .top){
                        Image("logo")
                            //.padding(.top, 100.0)
                            .frame(height : 100)
                    }
                    
                    Text("Select Restaurant")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Helvetica Neue", size: 25.0))
                        .padding()
                }
                .padding()
                .padding(.top, 10)
               Spacer()
                
                ScrollView{
                    ForEach(self.arrRestaurants){ item in
                        HStack{
                            Spacer()
                            WebImage(url: URL(string: item.image ?? ""))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity)
                                .onTapGesture {
                                    self.selectedRestaurantData = item
                                    self.isDetail = true
                                }
                            
                            Spacer()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Constants.AppColor.appPink, lineWidth: 4)
                        )
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                }
                
                NavigationLink(destination: DateRestaurantDetail(restaurantData : self.selectedRestaurantData), isActive: $isDetail){
                    
                }
            }
            
            ActivityLoader(isToggle: $DateRestaurantVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear{
            self.GetRestaurantList()
        }
    }
    
    
    func GetRestaurantList(){
        self.DateRestaurantVM.GetDateRestaurantListService("51.831289", long: "-0.33344") {  result, response,error  in
            if result == strResult.success.rawValue{
                self.arrRestaurants = response?.data ?? []
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

