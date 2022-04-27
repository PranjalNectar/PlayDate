//
//  DateHome.swift
//  PlayDate
//
//  Created by Pranjal on 09/06/21.
//

import SwiftUI

struct DateHomeView: View {
    @State private var isCreateDate: Bool = false
    @State private var isDateOption: Bool = false
    
    var body: some View {
        ZStack{
            VStack(){
                HStack(alignment : .top){
                    Image("logo")
                        .padding(.top, 100.0)
                        .frame(height : 100)
                        .ignoresSafeArea(edges: .all)
                }
                Spacer()
                
                
                VStack(spacing : 20){
                   // SelectPartnerView
                    NavigationLink(destination: DateOptionView(), isActive: $isCreateDate)  {
                        Button(action: {
                            self.isCreateDate = true
                        }) {
                            Text("Create Date")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                        }
                        .frame(width: UIScreen.main.bounds.width - 100, height : 40)
                        .background(Constants.AppColor.appPink)
                        .cornerRadius(40.0)
                    }
                    
                    NavigationLink(destination: AcceptDateListView(), isActive: $isDateOption)  {
                        
                        Button(action: {
                            self.isDateOption = true
                        }) {
                            Text("Accept Date")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 14.0))
                        }
                        .background(Color.clear)
                        .frame(width: UIScreen.main.bounds.width - 100, height : 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Constants.AppColor.appPink, lineWidth: 3)
                        )
                    }
                }
                .padding()
                .padding(.bottom , 20)
            }
            
            
        }
        .background(DateGB(imgName: "datebg"))
        .navigationBarHidden(true)
    }
}

struct DateHome_Previews: PreviewProvider {
    static var previews: some View {
        DateHomeView()
    }
}


struct DateGB: View {
    @State var imgName = ""
    var body: some View {
        Image(imgName)
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
