//
//  CommonViews.swift
//  PlayDate
//
//  Created by Pranjal on 13/06/21.
//

import Foundation
import SwiftUI
import ActivityIndicatorView


struct BackButton: View {
    @Environment(\.presentationMode) var presentation
    var body: some View {
        Button(action: { presentation.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
                .padding()
        }
    }
}

struct BGImage: View {
    
    var body: some View {
        Image("bg")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}


struct ActivityLoader: View {
    @Binding var isToggle : Bool
    var body: some View {
        ActivityIndicatorView(isVisible: $isToggle, type: .flickeringDots)
            .foregroundColor(Constants.AppColor.appPink)
            .frame(width: 50.0, height: 50.0)
    }
}


struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
