//
//  InviteSentView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/06/21.
//

import SwiftUI

struct InviteSentView: View {
    @Environment(\.presentationMode) var presentation
    @State private var Authenticate: Bool = false
    @Binding var comingFromEdit: Bool
    
    var body: some View {
        VStack{
            HStack{
                let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                if backButton {
                    BackButton()
                }else {
                    BackButton().hidden()
                }
                Spacer()
            }
            Spacer()
            Image("balloons")
            
            Spacer()
            
            Text("Invite Sent")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 20.0))
            
            Spacer()
            
            NavigationLink(destination:GenderInterest(comingFromEdit:$comingFromEdit), isActive: $Authenticate) {
                
                Button(action: {
                    if comingFromEdit{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentation.wrappedValue.dismiss()
                        }
                        
                    }else{
                        self.Authenticate = true
                    }
                }){
                    NextArrow()
                }
            }
        }
        .background(BGImage())
        .navigationBarHidden(true)
    }
}

