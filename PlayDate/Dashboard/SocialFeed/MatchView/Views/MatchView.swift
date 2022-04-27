//
//  MatchView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import SwiftUI

struct MatchView: View {
    @State var comeFromMaxView = false
    @State var maxViewMatchData : MatchData!
    @Binding var message : String
    @Binding var showAlert :Bool
   
    var body: some View {
        ZStack{
        //ScrollView{
            VStack(spacing: 20) {
                CardsSection(comeFromMaxView: $comeFromMaxView, maxViewMatchData: $maxViewMatchData,message: $message, showAlert:$showAlert).cornerRadius(10).clipped()
                    .onChange(of: showAlert) { (value) in
                        print(showAlert)
                        print(message)
                    }
            }
       // }
        .padding(.top,20)
        .navigationBarHidden(true)
           
        }.alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
}

