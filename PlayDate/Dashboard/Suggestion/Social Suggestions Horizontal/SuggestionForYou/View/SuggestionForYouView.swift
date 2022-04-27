//
//  SuggestionForYouView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 30/04/21.
//

import SwiftUI

struct SuggestionForYouView: View {
    //MARK:- Properties
    @State private var isActive: Bool = false
    @Binding var isSeeMore: Bool
    @Binding var showAlert: Bool
    @Binding var message : String
    
    //MARK:- Body
    var body: some View {
        VStack{
            VStack(spacing: 10) {
                
                Text("Suggestions For You")
                    .fontWeight(.semibold)
                    .font(.custom("Arial Rounded MT Bold", size: 18))
                    .padding(.top,10)
                
                SocialSuggestionsView(showAlert: $showAlert, message: $message)
                
                Button(action: {
                    self.isSeeMore = true
                    UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
                }, label: {
                    Text("See More Suggestions")
                        .fontWeight(.regular)
                        .font(.custom("Arial", size: 12))
                        .foregroundColor(Color.gray)
                        .padding(.bottom,50)
                    
                })
            }
        }
        .padding(.bottom, 20.0)
        .onDisappear{
            UserDefaults.standard.set(false, forKey:Constants.UserDefaults.isSuggestionOpen)
        }
        .navigationBarHidden(true)
        .onChange(of: showAlert, perform: { (value) in
            print(message)
            print(showAlert)
        })
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
    }
}

