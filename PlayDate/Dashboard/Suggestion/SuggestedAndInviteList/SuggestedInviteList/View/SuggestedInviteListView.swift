//
//  SuggestedInviteListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 01/05/21.
//

import SwiftUI

struct SuggestedInviteListView: View {
    var tabs = ["Suggested","Invite"]
    @State var selectedTab = "Suggested"
    @State var filter = ""
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    @State var isPremium = false
    
    var body: some View {
        VStack{
            HStack{
                ForEach(tabs,id: \.self){tabData in
                    NabButton(title: tabData, selectedTab: $selectedTab)
                    if tabData != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            } .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            
            if selectedTab == "Suggested"{
                SuggestedList(filter: $filter).tag("Suggested")
               
            }else {
                if isPremium {
                    InviteListView().tag("Invite")
                }else {
                    GetPremiumScreensView(isPremium: $isPremium).tag("Invite")
                }
            }
        }
        .padding(.top, 10)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}


struct SuggestedInviteListView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestedInviteListView()
    }
}


struct NabButton : View {
    @State var title : String
    @Binding var selectedTab : String
    var body: some View {
        ZStack{
            Button(action: {
                selectedTab = title
               
            }) {
                VStack(spacing:0){
                    Text(title)
                       
                        .fontWeight(.semibold)
                        .font(Font.system(size: 17.5))
                        .foregroundColor(selectedTab == title ? Constants.AppColor.appBlackWhite : Color.gray)
                    
                    Capsule()
                        .fill(selectedTab == title ? Constants.AppColor.appPink : Color.clear)
                        .frame(height:2)
                        .padding(.bottom,10)
                        .padding(.top,5)
                }
            }
        }.navigationBarHidden(true)
    }
}


