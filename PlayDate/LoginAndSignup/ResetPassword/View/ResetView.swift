//
//  ResetView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 13/05/21.
//

import SwiftUI

struct ResetView: View {
    @State var password = ""
    @State var isHidePassword = true
    var body: some View {
        ZStack(alignment: .leading) {
            if password.isEmpty { Text("Password").foregroundColor(.white) }
            
            if isHidePassword {
            SecureField("", text:$password)
                    .foregroundColor(Color.white)
                    .accentColor(.white)
                .background(Color.black)
            }else {
                TextField("", text:$password)
                    .foregroundColor(Color.white)
                    .accentColor(.white)
                
            }
        }
        .statusBar(style: .lightContent)
    }
}

