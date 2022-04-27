//
//  RecoredShowVideoView.swift
//  PlayDate
//
//  Created by Pranjal on 01/06/21.
//

import SwiftUI
import AVKit
import ActivityIndicatorView

struct RecoredShowVideoView: View {
    
    @Environment(\.presentationMode) var presentation
    @State private var authenticate: Bool = false
    @ObservedObject var RecordProfileVideVM: RecordProfileVideoViewModel = RecordProfileVideoViewModel()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @Binding var comingFromEdit: Bool
    @State var isNewVideo = false
    @State var isGoToVideo = false
    @State var authEdit = false
    @State var videourl : URL? = nil
   // @State var player = AVPlayer()
    
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    
    var body: some View {
            ZStack{ // (alignment: .bottom)
                VStack{
                    HStack{
                        BackButton()
                        Spacer()
                        Button {
                            if comingFromEdit {
                                self.isGoToVideo = true
                            }
                        } label: {
                            if comingFromEdit {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                            }else{
                                Image("")
                            }
                        }.padding()
                        NavigationLink(destination: RecordProfileVideo(comingFromEdit: $comingFromEdit, isNewVideo: $isNewVideo), isActive: $isGoToVideo) {}
                    }
                    .frame(height : 40)
                    VStack{
                        //VideoPlayer(player: player)
                        if self.videourl != nil{
                            VideoPlayer(url: self.videourl! , play: $play, time: $time)
                        }
                    }
                    Spacer()
                    HStack{
                        NavigationLink(destination: BottomMenuView(), isActive: $authEdit) {
                            Button(action: {
                                //UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                                DispatchQueue.main.async {
                                    self.UploadVideoService()
                                }
                            }, label: {
                                NextArrow()
                            })
                            
                        }
                    }
                }
                if RecordProfileVideVM.loading{
                    VStack{
                        ActivityLoader(isToggle: $RecordProfileVideVM.loading)
                        Text("Please wait while we create your account.")
                            .foregroundColor(.white)
                    }
                }
            }
            
            .background(BGImage())
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
            .statusBar(style: .lightContent)
            .onAppear{
                let videoFilename = FileManager.default.temporaryFileURL(fileName: "profilevideos.mp4")?.path
                let registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                if comingFromEdit {
                    if self.isNewVideo{
                        self.videourl = URL(fileURLWithPath: videoFilename ?? "")
                    }else{
                        self.videourl = URL(string:  registerDefaultData?["profileVideoPath"] as! String)!
                    }
                }else {
                    self.videourl = URL(fileURLWithPath: videoFilename ?? "")
                }
            }
    }
    
    func UploadVideoService(){
        var data = Data()
        do{
            let videoFilename = FileManager.default.temporaryFileURL(fileName: "profilevideos.mp4")?.path
            data = try Data(contentsOf:URL.init(fileURLWithPath: videoFilename ?? ""), options: [])
            print(data)
        }catch{
            print(error)
        }
        
        self.RecordProfileVideVM.RecordProfileVideoService(data) { result, response,error  in
            
            if result == strResult.success.rawValue{
                UserDefaults.standard.set("dashboard", forKey:Constants.UserDefaults.controller)
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["profileVideoPath"] = "\(EndPoints.BASE_URL_IMAGE)\(response?.data?.profileVideoPath ?? "")"
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                
                if comingFromEdit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.authEdit = true
                }
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
}
