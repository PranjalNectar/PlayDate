//
//  PlayerView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @Binding var profileVideo : String
    
    var body: some View {
        VStack{
            HStack{
                BackButton()
                    .padding(.top,50)
                Spacer()
                Text("")
            }
            player(urlVideo: $profileVideo).frame(height: UIScreen.main.bounds.height - 80).padding(.bottom,40)
            Spacer()
        }.background(Color.black)
    }
}


struct player : UIViewControllerRepresentable {
    @Binding var urlVideo: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController{
        
        let controller = AVPlayerViewController()
        let url = urlVideo //"http://139.59.0.106:3000/uploads/userProfileVideo/playdate-user-video-1621832069084.mp4"
        let player1 = AVPlayer(url: URL(string: url)!)
        
        controller.player = player1
       
        return controller
    }
    
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context:  UIViewControllerRepresentableContext<player>) {
        
    }
}
