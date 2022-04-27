//
//  CorouselSelectDateView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 22/06/21.
//


import SwiftUI
import SDWebImageSwiftUI

struct CorouselSelectDateView : View {
    @ObservedObject private var SelectPartnerVM = SelectPartnerViewModel()
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 190
    @State var op : CGFloat = 0
  //  @State var partnerData : [PartnerData]
    @State private var isActive: Bool = false
    @State var partner : PartnerData?
    @Binding var dateTypeVirtual: Bool
    @State var arrPartner : [PartnerData] = []
    @State private var showAlert: Bool = false
    @State private var message = ""
    
    var body : some View{
        VStack{
            Spacer()
            HStack(spacing: 15){
                ForEach(arrPartner){i in
                    NavigationLink(destination: DateRequestView(partnerData: $partner, dateTypeVirtual: $dateTypeVirtual), isActive: $isActive) {
                        
                    }
                    CardView(data: i)
                       // .onTapGesture {
                        .onLongPressGesture {
                            self.updateHeight(value: Int(self.count))
                            // i.show = true
                            self.partner = i
                            
                            self.isActive = true
                        }
                        .offset(x: self.x)
                        .highPriorityGesture(DragGesture()
                                                
                                                .onChanged({ (value) in
                                                    
                                                    if value.translation.width > 0{
                                                        
                                                        self.x = value.location.x
                                                    }
                                                    else{
                                                        
                                                        self.x = value.location.x - self.screen
                                                    }
                                                    
                                                })
                                                .onEnded({ (value) in
                                                    
                                                    if value.translation.width > 0{
                                                        
                                                        
                                                        if value.translation.width > ((self.screen - 200) / 2) && Int(self.count) != 0{
                                                            
                                                            
                                                            self.count -= 1
                                                            self.updateHeight(value: Int(self.count))
                                                            self.x = -((self.screen + 20) * self.count)
                                                        }
                                                        else{
                                                            
                                                            self.x = -((self.screen + 20) * self.count)
                                                        }
                                                    }
                                                    else{
                                                        
                                                        
                                                        if -value.translation.width > ((self.screen - 200) / 2) && Int(self.count) !=  (self.arrPartner.count - 1){
                                                            
                                                            self.count += 1
                                                            self.updateHeight(value: Int(self.count))
                                                            self.x = -((self.screen + 20) * self.count)
                                                        }
                                                        else{
                                                            
                                                            self.x = -((self.screen + 20) * self.count)
                                                        }
                                                    }
                                                })
                        )
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .offset(x: self.op)
            Spacer()
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .animation(.spring())
        .onAppear {
          self.GetAllPartnerListService()
        }
      
    }
    
    func updateHeight(value : Int){
        for i in 0..<arrPartner.count{
            arrPartner[i].show = false
        }
        arrPartner[value].show = true
    }
    
    //MARK:- Call Api
    func GetAllPartnerListService(){
        self.SelectPartnerVM.GetCreatePartnerListService("100", page: "1") { result, response,error  in
            if result == strResult.success.rawValue{
                self.arrPartner = response?.data ?? []
                if arrPartner.count != 0 {
                    self.op = ((self.screen + 20) * CGFloat(self.arrPartner.count / 2)) - (self.arrPartner.count % 2 == 0 ? ((self.screen + 20) / 2) : 0)
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


struct CardView : View {
    
    var data : PartnerData?
    
    var body : some View{
        VStack(spacing : 8){
            if data?.show ?? false{
                Image("crown")
            }
            
            WebImage(url: URL(string: data?.profilePicPath ?? ""))
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                
                .overlay(
                    RoundedRectangle(cornerRadius:  data?.show ?? false  ? (UIScreen.main.bounds.width-200)/2 :  (UIScreen.main.bounds.width-200)/2)
                        .stroke(Constants.AppColor.appPink.opacity(0.7), lineWidth: 05)
                )
                .cornerRadius( data?.show ?? false  ? (UIScreen.main.bounds.width-200)/2 :  (UIScreen.main.bounds.width-200)/2)
                .clipped()
            
            if data?.show ?? false {
                Text("\(data?.totalPoints ?? 0) points")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.custom("Antarctican Mono", size: 24.0))
                    
                    .padding(.top,10)
                Text(data?.username ?? "")
                    .foregroundColor(.white)
                    .font(.custom("Arial", size: 15.0))
                
            }
            
        }
        .frame(width:  data?.show ?? false  ? UIScreen.main.bounds.width-200 :  UIScreen.main.bounds.width-200, height: data?.show ?? false  ? UIScreen.main.bounds.width-80 :  UIScreen.main.bounds.width-200)
        .padding(.bottom,data?.show ?? false  ? 0 : 150)
        .clipped()
    }
}

