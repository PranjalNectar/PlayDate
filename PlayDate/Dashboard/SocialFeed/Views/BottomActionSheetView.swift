//
//  BottomActionSheet.swift
//  PlayDate
//
//  Created by Pallavi Jain on 29/04/21.
//

import SwiftUI

struct BottomActionSheetView: View {
    @State private var isOn = false
    
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    //    @State var isOn = false
    @State var status = 0
    
    var body: some View {
        VStack(spacing : 15) {
            
            Button(action: {
                self.show3.toggle()
            }, label: {
                HStack {
                    Text("Turn Post Notfication ON")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("bookmark")
                }
            })
            
            Button(action: {
                self.show3.toggle()
            }, label: {
                HStack {
                    Text("Block User")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("block")
                }
            })
            
            Button(action: {
                self.show2.toggle()
            }, label: {
                HStack {
                    Text("Report Post")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("report")
                }
            })
            
            Toggle(isOn: self.$show1, label: {
                Text("")
                    .font(Font.system(size: 12.5))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            })
            
            .toggleStyle(
                ColoredToggleStyle(label: "Turn Posts ON For This User",
                                   onColor: .white,
                                   offColor: .white,
                                   onThumbColor: Color("pink"), isOn: $isOn, postId: .constant(""), apiStatus: $status, comeFromComment: .constant(false)))
            
        }
        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top,20)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct UseSheet: View {
    
    @State var show = false
    
    var body : some View {
        ZStack{
            Button(action: {
                self.show.toggle()
            }, label: {
                Text("Action Sheet")
            })
            
            VStack {
                Spacer()
                BottomActionSheetView().offset(y: self.show ? 0 : UIScreen.main.bounds.height)
            }.background((self.show ? Color.black.opacity(0.3) : Color.clear).onTapGesture {
                self.show.toggle()
            })
        }  .edgesIgnoringSafeArea(.bottom)
    }
}

