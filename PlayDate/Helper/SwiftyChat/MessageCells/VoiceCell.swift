//
//  VoiceCell.swift
//  PlayDate
//
//  Created by Pranjal on 02/07/21.
//


import SwiftUI

internal struct VoiceCell<Message: ChatMessage>: View {
    
    public let media: VoiceItem
    public let message: Message
    public let size: CGSize
    @State var audiourl : URL?
    @State var sliderValue: Double = 0
    @EnvironmentObject var style: ChatMessageCellStyle
    
    @ObservedObject var audiosettings = audioSettings()
    @State private var playButton: Image = Image("pause")
    
    private var cellStyle: ImageCellStyle {
        style.imageCellStyle
    }
    
    private var maxWidth: CGFloat {
        size.width * (UIDevice.isLandscape ? 0.6 : 0.75)
    }
    
    public var body: some View {
        VStack{
            Text(message.date.chatFormate())
                .font(Font.custom("Arial", size: 9))
                .foregroundColor(.black)
            
            VoiceView
                .background(cellStyle.cellBackgroundColor)
                .cornerRadius(cellStyle.cellCornerRadius)
        }
        
        .onAppear(perform: {
            print(media.url)
            self.downloadFileFromURL(url: media.url) {
               // print(self.audiourl!)
            }
        })
    }
    
     func downloadFileFromURL(url:URL, complition : @escaping ()->()){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.audiourl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: self.audiourl!.path) {
            print("The file already exists at path")
            complition()
        } else {
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: audiourl!)
                    
                    //self.play(url: destinationUrl)
                    print("File moved to documents folder")
                    complition()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
    
    
    @ViewBuilder private var VoiceView: some View {
       
        HStack{
            Button {
                if (self.playButton == Image("pause")) {
                    print("All Done")
                    //self.downloadFileFromURL(url: media.url, compete: )
                    self.audiosettings.playSound(sound: "filename", type: "wav", url: self.audiourl!)
                    self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    self.playButton = Image("play")
                    
                } else {
                    
                    self.audiosettings.pauseSound()
                    self.playButton = Image("pause")
                }
            } label: {
                //Image("pause")
                self.playButton
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal)
            ZStack(alignment:.bottomLeading){
                
                Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration, onEditingChanged: { _ in
                    self.audiosettings.changeSliderValue()
                })
                .padding(.trailing)
                .accentColor(.white)
                
//                Text("\(self.audiosettings.playerDuration)")
//                    .font(Font.custom("Arial", size: 12))
//                    .foregroundColor(.white)
                
            }
           // Slider(value: $sliderValue, in: 0...20)
                
            
            .onReceive(audiosettings.timer) { _ in
                
                if self.audiosettings.playing {
                    if let currentTime = self.audiosettings.audioPlayer?.currentTime {
                        self.audiosettings.playValue = currentTime
                        
                        if currentTime == TimeInterval(0.0) {
                            self.audiosettings.playing = false
                            self.playButton = Image("pause")
                        }
                    }
                    
                }
                else {
                    self.audiosettings.playing = false
                    self.audiosettings.timer.upstream.connect().cancel()
                }
            }
                
        }
        .clipped()
        .background(Color("pink"))
        .frame(
            width: maxWidth,
            height: 60
        )
    }
    
}



public protocol VoiceItem {
    /// The url where the media is located.
    var url: URL { get }
}

import AVFoundation

class audioSettings: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    var playerDuration: TimeInterval = 0.0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var playerItem:AVPlayerItem?
    
    func playSound(sound: String, type: String, url : URL) {
       // if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        audioPlayer = try AVAudioPlayer(contentsOf:  url)
                        playerItem = AVPlayerItem(url: url)
                        
                        let duration : CMTime = playerItem!.asset.duration
                        playerDuration = CMTimeGetSeconds(duration)
                        
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
       // }
    }

    func stopSound() {
        if playing == true {
            audioPlayer?.stop()
            audioPlayer = nil
            playing = false
            playValue = 0.0
        }
    }
    
    func pauseSound() {
        if playing == true {
            audioPlayer?.pause()
            playing = false
        }
    }
    
    func changeSliderValue() {
        if playing == true {
            pauseSound()
            audioPlayer?.currentTime = playValue
        }
        
        if playing == false {
            audioPlayer?.play()
            playing = true
        }
    }
}
