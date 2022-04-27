//
//  ContentView.swift
//  PlayDateApp
//
//  Created by Pranjal Dudhe on 21/04/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var name = ""
    @State private var isActive: Bool = false
    @EnvironmentObject var authorizationStatus: UserSettings
    
    var body: some View {
        
        VStack{
            if self.name.isEmpty {
//                SignUpWithAppleView(name: $name)
//                .frame(width: 200, height: 50)
            }
            else{
                Text("Welcome\n\(self.name)")
                    .font(.headline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
