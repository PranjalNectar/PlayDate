//
//  UploadFeedView.swift
//  PlayDate
//
//  Created by Pranjal on 23/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit
import ActivityIndicatorView

struct names : Identifiable {
    var id = UUID()
    var name : String
}

struct UploadFeedView: View {
    @State var txtDescription = ""
    @State var txtLocation = ""
    @State var image : UIImage
    @State var mediaid : String
    @State var mediatype : String
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentation
    @ObservedObject var lm = LocationManager()
    @State var istagSelected = false
    @State var isBottom = false
    @State var arrname : [names] = []
    @State var friendtagids : String = ""
    @State private var showAlert: Bool = false
    @State private var message = ""
    
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    @State var isPost = false
    
    
    var player : AVPlayer{
        let videoFilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "feedvideo.mp4"//return your filename from the getFileName function
        let player = AVPlayer(url: URL(fileURLWithPath: videoFilename))
        return player
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image("bback")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .imageScale(.large)
                            .padding()
                    }
                    
                    Text("Upload Photo")
                        .fontWeight(.bold)
                        .font(.custom("Arial", size: 18.0))
                    Spacer()
                    
                    NavigationLink(
                        destination: BottomMenuView(),
                        isActive: $isBottom,
                        label: {
                            Image("uright")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .padding()
                                .onTapGesture {
                                    if !isPost{
                                        isPost = true
                                        self.AddPostFeedService()
                                    }
                                   
                                }
                        })
                }
                //.padding()
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack(spacing : 20){
                            let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                            let profilePicPath = "\(registerDefaultData?["profilePicPath"] ?? "")"
                            WebImage(url: URL(string: profilePicPath ))
                                .resizable()
                                .cornerRadius(15)
                                .frame(width:30,height : 30)
                            Text(registerDefaultData?["username"]  as! String)
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 15.0))
                            Spacer()
                        }
                        .padding([.leading, .bottom])
                        if self.mediatype == "image"{
                            Image(uiImage: image)
                                .resizable()
                                .cornerRadius(25)
                                .clipped()
                                .aspectRatio(contentMode: .fill)
                                .padding(.top,5)
                                .padding(.leading,10)
                                .padding(.trailing,10)
                                .padding(.bottom,5)
                        }else{
                            let videoFilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "feedvideo.mp4"
                            VideoPlayer(url: URL(fileURLWithPath: videoFilename), play: $play, time: $time)
                                .cornerRadius(25)
                                .padding(.top,5)
                                .padding(.leading,10)
                                .padding(.trailing,10)
                                .padding(.bottom,5)
                                .frame(width: 350, height: 250)
                        }
                        
                        VStack(alignment:.leading){
                            Text("Description")
                                .font(.custom("Arial", size: 17.0))
                            HStack{
                                ZStack(alignment: .leading) {
                                    if self.txtDescription.isEmpty { Text("Enter description").foregroundColor(.gray) }
                                    TextField("", text: $txtDescription)
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                        .accentColor(Constants.AppColor.appBlackWhite)
                                }
                                Image("edit")
                                    .padding()
                            }
                            
                            Text("Location")
                                .font(.custom("Arial", size: 17.0))
                            HStack{
                                Text(self.txtLocation)
                                    .fontWeight(.bold)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                Spacer()
                                Image("upin")
                                    .padding()
                            }
                            HStack{
                                Text("Tag a friend")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 17.0))
                                Spacer()
                                Image("edit")
                                    .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .padding()
                            }
                            HStack{
                                HStack{
                                    NavigationLink(
                                        destination: TagFriendList(),
                                        isActive: $istagSelected,
                                        label: {
                                            Image("uplus")
                                                .padding([.top, .bottom, .trailing], 8.0)
                                                .onTapGesture {
                                                    self.istagSelected = true
                                                }
                                        })
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack{
                                        if self.arrname.count != 0{
                                            
                                            ForEach(self.arrname){ item in
                                                // Text(self.arrname[i])
                                                Text(item.name)
                                                    .padding()
                                                    .foregroundColor(.white)
                                                    .background(Color("pink"))
                                                    .frame(height : 30)
                                                    .cornerRadius(15)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .onAppear{
                self.arrname.removeAll()
                print(self.mediaid)
                let arr = UserDefaults.standard.value(forKey: "tagUsername") as? [String] ?? []
                for i in 0..<arr.count{
                    self.arrname.append(names.init(name: arr[i]))
                }
                
                let userids =  UserDefaults.standard.value(forKey: "tagUserids") as? [String] ?? []
                self.friendtagids = userids.joined(separator: ",")
            }
            .onChange(of: lm.placemark, perform: { value in
                self.txtLocation = ((lm.placemark?.thoroughfare ?? "") + ", " + (lm.placemark?.subAdministrativeArea ?? ""))
            })
            
            ActivityLoader(isToggle: $ProfileVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
    }
    
    func AddPostFeedService(){
        self.txtLocation = ((lm.placemark?.thoroughfare ?? "") + ", " + (lm.placemark?.subAdministrativeArea ?? ""))
        print(self.mediaid)
        self.ProfileVM.AddPostFeedService(self.txtLocation, mediaId: mediaid, postType: "Normal", txtdescription: self.txtDescription,friendtag: self.friendtagids) { result, response,error in
            
            if result == strResult.success.rawValue{
                self.isBottom = true
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
