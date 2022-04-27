//
//  LikeView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 08/06/21.
//

import SwiftUI
import Lottie

struct LikeView : UIViewRepresentable{
    @Binding var animationInProgress: Bool
    
    func makeUIView(context: Context) -> some AnimationView{
        let lottieAnimationView = AnimationView(name:"5603-like-animation-in-lottie")
        lottieAnimationView.play { complete in
            if complete {
                animationInProgress = false
            }
        }
        return lottieAnimationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
//5603-like-animation-in-lottie
//836-like-button
