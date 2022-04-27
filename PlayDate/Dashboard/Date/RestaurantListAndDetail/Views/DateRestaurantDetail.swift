//
//  DateRestaurantDetail.swift
//  PlayDate
//
//  Created by Pranjal on 10/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DateRestaurantDetail: View {
    
    @State var restaurantData : DateRestaurantData?
    
    var body: some View {
        ZStack{
            VStack(spacing : 0){
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
                }
                .padding()
                .padding(.top, 10)
                //Spacer()
                GeometryReader { geometry in
                    ScrollView{
                        VStack{
                            VStack{
                                WebImage(url: URL(string: restaurantData?.image ?? ""))
                                    .resizable()
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity)
                                    .padding()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .greatestFiniteMagnitude)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Constants.AppColor.appPink, lineWidth: 3)
                            )
                            .padding()
                            
                            VStack(alignment : .leading){
                                Text(restaurantData?.name ?? "")
                                    .foregroundColor(.white)
                                    .font(.custom("Lovelo Line", size: 35.0))
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                                Text(restaurantData?.address ?? "")
                                    .foregroundColor(.white)
                                    .font(.custom("Arial", size: 21.0))
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                            }
                            
                            Image("openrest")
                            
                            // Spacer()
                            
                            Button(action: {
                                // self.isCreateDate = true
                            }) {
                                Text("Proceed")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 14.0))
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, height : 40)
                            .background(Constants.AppColor.appPink)
                            .cornerRadius(40.0)
                            .padding()
                            
                        }.padding()
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                        
                    }
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct DateRestaurantDetail_Previews: PreviewProvider {
    static var previews: some View {
        DateRestaurantDetail()
    }
}
