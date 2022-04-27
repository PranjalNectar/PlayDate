//
//  AudioRecorderView.swift
//  PlayDate
//
//  Created by Pranjal on 05/07/21.
//

import SwiftUI

struct AudioRecorderView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @State var isrecord = false
    @ObservedObject var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentation
    @Binding var isSend : Bool
    // var audioURL: URL
    
    var body: some View {
        VStack {
            //RecordingsList(audioRecorder: audioRecorder)
            Spacer()
            Image(systemName: "mic.circle.fill")
                .resizable()
                .foregroundColor(Color("pink"))
                .frame(width: 200, height: 200)
            
            Spacer()
            if isrecord{
                HStack{
                    Button(action: {
                        self.audioRecorder.deleteRecording(urlsToDelete: [self.audioRecorder.recordings[0].fileURL])
                        self.isrecord = false
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    })
                    .padding()
                    
                    Spacer()
                    
                    if audioPlayer.isPlaying == false {
                        Button(action: {
                            self.audioPlayer.startPlayback(audio: self.audioRecorder.recordings[0].fileURL)
                        }) {
                            Image(systemName: "play.circle")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                        }
                        .padding()
                    } else {
                        Button(action: {
                            self.audioPlayer.stopPlayback()
                        }) {
                            Image(systemName: "pause.circle")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.isSend = true
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Circle().fill(Constants.AppColor.appPink)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "paperplane.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .offset(x: -1, y: 1)
                                    .padding(8)
                            )
                    })
                    .padding()
                }
                .padding()
            }else{
                if audioRecorder.recording == false {
                    Button(action: {self.audioRecorder.startRecording()}) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                } else {
                    Button(action: {
                        self.audioRecorder.stopRecording()
                        if (self.audioRecorder.recordings.count != 0){
                            self.isrecord = true
                        }
                     
                    }) {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(.black).opacity(0.9))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
        }
    }
}
