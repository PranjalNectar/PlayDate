//
//  MaximizeMatchView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 31/05/21.
//

import SwiftUI

struct MaximizeMatchView: View {
   
    @Binding var maxViewMatchData : MatchData!
    @State var card1 : MatchData!
    @State var comeFromMaxView = true
    @State var message = ""
    @State var showAlert = false
    
    var body: some View {
        ZStack{
            CardsSection(comeFromMaxView: $comeFromMaxView, maxViewMatchData: $card1,message: $message, showAlert:$showAlert)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .ignoresSafeArea()
        }.onAppear{
            self.card1 = maxViewMatchData
            //print(self.card1)
        }
        .onChange(of: showAlert) { (value) in
            print(showAlert)
            print(message)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
}

