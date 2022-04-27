//
//  GameTabView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 07/07/21.
//

import SwiftUI

struct GameTabView: View {
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "", bg: "")),
        UIHostingController(rootView: Subview(imageString: "", bg: "")),
        UIHostingController(rootView: Subview(imageString: "", bg: ""))
    ]
    
    @ObservedObject var CoupanStoreVM: CoupanStoreViewModel = CoupanStoreViewModel()
    @State private var offset: CGFloat = -200.0
    @State private var isActive: Bool = false
    @State var currentPageIndex = 0
    @State var arrCoupansList = [CoupanStoreDataModel]()
    var tabs = ["Popular","New Games","Trending"]
    @State var selectedTab = "Popular"
    var body: some View {
        VStack{
            HStack(spacing : 10){
                ForEach(tabs,id: \.self){tabData in
                    
                    GameButtons(title: tabData, selectedTab: $selectedTab)
                    
                    if tabData != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }.padding(.leading,20)
            .padding(.trailing,20)
            .background(Color.clear)
           
            ZStack{

            ScrollView(showsIndicators: false){
                
                LazyVGrid(columns: columns, spacing : 30) {
                ForEach(self.arrCoupansList) { item in
                    ZStack{
                        Image("game1")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                }
                }
            }.padding()
            
           
                //}
            }
           
            PageControl(numberOfPages: tabs.count, currentPageIndex: $currentPageIndex)
                .onTapGesture {
                    print("yes")
                    if self.currentPageIndex+1 == self.subviews.count {
                        self.currentPageIndex = 0
                        selectedTab = "Popular"
                    } else {
                        self.currentPageIndex += 1
                        if currentPageIndex == 1 {
                            selectedTab = "New Games"
                        }else {
                            selectedTab = "Trending"
                        }
                    }

                
                }
            NavigationLink(destination: GameDetailView(), isActive: $isActive) {
                
            }
            Image("shuffle")
                .padding()
                .background(Constants.AppColor.appPink)
                .frame(width: 50, height: 50)
                .cornerRadius(25)
                .onTapGesture {
                    isActive = true
                }
        }
        .onAppear{
            CoupanStoreListService()
        }
    }
    
    //MARK:- Call Api
    func CoupanStoreListService(){
        CoupanStoreVM.GetAllCoupansService(100, page: 1) { result,response,error  in

            if result == strResult.success.rawValue{
                self.arrCoupansList = response?.data?.coupondata ?? []
              //  self.currentPoints = response?.data?.account?.currentPoints ?? 0
            }else if result == strResult.error.rawValue{
             //   self.message = response?.message ?? ""
             //   self.showAlert = true
            }else if result == strResult.Network.rawValue{
              //  self.message = MessageString().Network
              //  self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
              //  self.message = MessageString().NetworkConnection
              //  self.showAlert = true
            }
        }
    }
}

struct GameButtons : View {
    @State var title : String
    @Binding var selectedTab : String
    var body: some View {
        ZStack{
            Button(action: {
                selectedTab = title
               
            }) {
                VStack(spacing:10){
                    Text(title)
                       
                        .fontWeight(selectedTab == title ?.semibold : .regular)
                        .font(Font.system(size: 17.5))
                        .foregroundColor(selectedTab == title ? Constants.AppColor.appPink : .white)
                    
                    Capsule()
                        .fill(selectedTab == title ?  Constants.AppColor.appPink : .clear)
                        .frame(height:3)
                        .padding(.bottom,10)
                }
            }
        }.navigationBarHidden(true)
    }
}

