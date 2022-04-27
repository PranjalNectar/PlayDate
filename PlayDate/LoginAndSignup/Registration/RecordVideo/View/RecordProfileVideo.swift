//
//  RecordVideo.swift
//  PlayDate
//
//  Created by Pranjal on 31/05/21.
//

import SwiftUI
import AVKit

struct RecordProfileVideo: View {
    @State private var timer = 5
    @State private var onComplete = false
    @State private var recording = false
    @ObservedObject var events = UserEvents()
    @Binding var comingFromEdit: Bool
    @Binding var isNewVideo: Bool
    @State private var recordnew = false
    @Environment(\.presentationMode) var presentation
    @State  var authenticate: Bool = false
    
    
    var body: some View {
        ZStack {
            CameraView(events: events, applicationName: Constants.AppName,preferredStartingCameraType: .builtInWideAngleCamera,preferredStartingCameraPosition: .front, doubleTapCameraSwitch: false)
            CameraInterfaceView(events: events, authenticate: $authenticate, comingFromEdit: comingFromEdit, isNewVideo: $recordnew)
        }
        .onChange(of: self.recordnew, perform: { value in
            if self.recordnew{
                self.isNewVideo = true
            }
        })
        .statusBar(style: .darkContent)
        .navigationBarHidden(true)
    }
}

struct CameraInterfaceView: View, CameraActions {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var events: UserEvents
    @State private var recordtime = 0.0
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var isTimerRunning = false
    @State var TipToShow = ""
    @State var TipTimer = 0
    @State var arrTips = ["Tip: The video is 12 Seconds Long",
                          "Tip: Tell the ladies why you joined us",
                          "Tip: First impression always counts",
                          "Tip: A big smile is a powerful weapon",
                          "Tip: Try Out the filters"
    ]
    
    @Binding var authenticate: Bool
    @State  var isFlash: Bool = false
    @State var comingFromEdit : Bool
    @Binding var isNewVideo : Bool
    @State var authEdit = false
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Spacer()
                    Image("flash").onTapGesture {
                        self.changeFlashMode(events: events)
                        if self.isFlash{
                            self.toggleTorch(on: false)
                            self.isFlash = false
                        }else{
                            self.toggleTorch(on: true)
                            self.isFlash = true
                        }
                    }
                }.padding()
                Spacer()
                VStack{
                    HStack(alignment: .center){
                        Text(TipToShow)
                            .fontWeight(.bold)
                            .font(.custom("Arial", size: 16.0))
                            .foregroundColor(Color.white).opacity(0.8)
                            .onReceive(timer) { _ in
                                if TipTimer < 13{
                                    TipTimer += 1
                                    if TipTimer == 1{
                                        self.TipToShow = self.arrTips[0]
                                    }else if TipTimer == 2{
                                        self.TipToShow = self.arrTips[1]
                                    }else if TipTimer == 4{
                                        self.TipToShow = self.arrTips[2]
                                    }else if TipTimer == 6{
                                        self.TipToShow = self.arrTips[3]
                                    }else if TipTimer == 8{
                                        self.TipToShow = self.arrTips[4]
                                        TipTimer = 0
                                    }
                                }
                            }
                    }
                    
                    HStack{
                        Image("filtericon").onTapGesture {
                            
                        }
                        Spacer()
                        ZStack{
                            Image("recordbg").onTapGesture {
                                //self.takePhoto(events: events)
                                self.isTimerRunning = true
                                self.recordtime =  0.0
                            }
                            .frame(width: 50 , height: 50)
                            
                            
                            Image("recordbg").onTapGesture {
                                self.toggleVideoRecording(events: events)
                                self.isTimerRunning = true
                                self.recordtime =  0.0
                            }
                            .frame(width: 40 , height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20 )
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            
                            if self.isTimerRunning{
                                GCProgressView(style: .circle, progress: self.$recordtime)
                                    .accentColor(.black)
                                    .onReceive(timer) { _ in
                                        if recordtime < 1 {
                                            recordtime += 0.084
                                        }else{
                                            self.isTimerRunning = false
                                            self.toggleVideoRecording(events: events)
                                        }
                                    }
                                    .frame(width: 25 , height: 25)
                            }
                        }
                        Spacer()
                        Image("shuffle").onTapGesture {
                            
                        }
                    }.padding()
                    HStack{
                        ZStack{
                            Image("cancelbg").onTapGesture {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.presentation.wrappedValue.dismiss()
                                }
                            }
                            Image("cancelcross").onTapGesture {
                                
                            }
                            .offset(y : -3)
                        }
                    }
                    .padding(.bottom, 8)
                    
                }
                
                NavigationLink(destination: RecoredShowVideoView(comingFromEdit: $comingFromEdit), isActive: $authenticate) {
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .statusBar(style: .darkContent)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.completevideo)){ obj in
            // Change key as per your "userInfo"
            if let userInfo = obj.userInfo, let info = userInfo["info"] {
                print(info)
                print("stop record by me")
                if info as! String == "true"{
                    //self.UploadVideoService()
                    self.isNewVideo = true
                    if comingFromEdit {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentation.wrappedValue.dismiss()
                        }
                    }else {
                        self.authenticate = true
                    }
                }
            }
        }
   // }
        .onDisappear{
            self.timer.upstream.connect().cancel()
            NotificationCenter.default.removeObserver(NSNotification.completevideo)
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}

