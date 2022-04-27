//
//  ChatTabView.swift
//  PlayDate
//
//  Created by Pranjal on 21/06/21.
//

import SwiftUI

struct ChatInboxTabView: View {
    var tabs = ["Inbox","Requests"]
    @State var selectedTab = "Inbox"
    @Binding var isPopupShow : Bool
    @State var selectedItem : InboxUserListData?
    
    var body: some View {
        VStack{
            HStack(spacing : 20){
                ForEach(tabs,id: \.self){tabData in
                    
                    InboxRequestButton(title: tabData, selectedTab: $selectedTab)
                    
                    if tabData != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }.padding(.leading,20)
            .padding(.trailing,20)
            .background(Color.clear)
            
            if selectedTab == "Inbox" {
                ScrollView{
                    ForEach(0..<20){ i in
                        ChatInboxView(isPopupShow: $isPopupShow, selectedData: $selectedItem).tag("Inbox")
                            .padding(.top, 8)
                            .onTapGesture {
                                self.isPopupShow = true
                                
                            }
                    }
                }
                .padding(.horizontal)
            }else {
                ZStack{
                    ScrollView{
                        ForEach(0..<20){ i in
                            ChatRequestView().tag("Requests")
                                .padding(.top, 8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .onChange(of: self.selectedTab, perform: { value in
            if self.selectedTab == "Inbox"{
                //self.isClicked =  false
            }
        })
    }
}


struct InboxRequestButton : View {
    @State var title : String
    @Binding var selectedTab : String
    
    var body: some View {
        ZStack{
            Button(action: {
                selectedTab = title
                
            }) {
                VStack(spacing:10){
                    ZStack(alignment : .topTrailing){
                        Text(title)
                            .fontWeight(selectedTab == title ?.semibold : .regular)
                            .font(Font.system(size: 20))
                            .foregroundColor(selectedTab == title ? Constants.AppColor.appBlackWhite : Color.gray)
//                        Text("*")
//                            .foregroundColor(selectedTab == title ? Constants.AppColor.appPink : Constants.AppColor.applightPink)
//                            .offset(x:5,y:-5)
//                            .font(Font.system(size: 20))
                    }
                    Capsule()
                        .fill(selectedTab == title ? Color("pink") : Color.gray)
                        .frame(height:3)
                        .padding(.bottom,10)
                        .padding(.horizontal,20)
                }
            }
        }.navigationBarHidden(true)
    }
}

