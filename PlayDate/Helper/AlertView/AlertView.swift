//
//  AlertView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/04/21.
//

import SwiftUI



enum AlertAction {
    case ok
    case cancel
    case others
}
struct AlertView: View {
  
     @Binding var shown: Bool
     @Binding var closureA: AlertAction?
     var message: String
     var arr : [String] = [String]()
   
     var body: some View {
        VStack(alignment:.center ,spacing: 10) {
            
            Text("PlayDate")
                .foregroundColor(Color.black)
                .fontWeight(.bold)
                
                .padding()
           
            // Text(message).foregroundColor(Color.black)
               // .padding(.bottom)
            ForEach(arr, id: \.self) { item in
                Text(item.description)
                    .foregroundColor(Color.black)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .font(.subheadline)
            }
            
            HStack {
            Button("Ok") {
                closureA = .ok
                shown.toggle()
                   
            }
            .frame(width: UIScreen.main.bounds.width-50,height: 40)
            .foregroundColor(.white)
            }.background(Constants.AppColor.appPink)
            .padding(.top,10)
            
          
     }.frame(width: UIScreen.main.bounds.width-50)
         
         .background(Color.white.opacity(1))
       // .border(Color.pink, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
         .cornerRadius(8)
     
         .clipped()
        .navigationBarHidden(true)
     }
 }
