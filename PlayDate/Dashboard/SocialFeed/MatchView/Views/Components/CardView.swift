//
//  CardView.swift
//  PlayDate
//
//  Created by Pranjal on 25/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct SwipeView: View {
    
    // MARK: - Drawing Constant
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    @ObservedObject private var matchtVM = MatchViewModel()
    @State var card1 : MatchData!
    @Binding var status : Int
    @Binding var comeFrom : Bool
    @Binding var message : String
    @State private var error: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @Binding var showAlert: Bool
    @State var isActive = false
    @State var isVideoPlay = false
    @State var profileVideoPath = ""
    @Environment(\.presentationMode) var presentation
    @State var item : MatchData!
    var interestedList : [InterestedList]
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    @State var isMsg = false
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    @State var isChatActive = false
    @State var chatId = ""
    
    var body: some View{
        ZStack {
            if card1.profilePicPath == "" || card1.profilePicPath == nil{
                Image("profileplaceholder")
                    .resizable()
                    .cornerRadius(comeFrom ? 0 : 10)
            }else {
                WebImage(url: URL(string: card1.profilePicPath ?? "" ))
                    .renderingMode(.original)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .background(Color.white)
                    .frame( height: comeFrom ? UIScreen.main.bounds.height : UIScreen.main.bounds.height-330 )
                    .cornerRadius(comeFrom ? 0 : 10)
                    .clipped()
                   // .scaleEffect(2.0)
                    .scaleEffect(0.99)
                    //.aspectRatio(1,contentMode: .fit)
            }
            if !comeFrom {
                if self.isVideoPlay {
                    VideoPlayer(url: URL(string:  profileVideoPath)!, play: $play, time: $time)
                        .cornerRadius(25)
                        .onAppear() {
                            self.play = true
                        }
                        .onDisappear() {
                            self.play = false
                        }
                        .background(Color.pink)
                        .cornerRadius(comeFrom ? 0 : 10)
                        .clipped()
                }
                if !comeFrom {
                    if self.isVideoPlay {
                        VideoPlayer(url: URL(string:  profileVideoPath)!, play: $play, time: $time)
                            .cornerRadius(25)
                            .onAppear() {
                                self.play = true
                            }
                            .onDisappear() {
                                self.play = false
                            }
                    }
                }else {
                }
            }
            VStack(alignment:.leading) {
                HStack{
                    NavigationLink(destination: MaximizeMatchView(maxViewMatchData: $item)
                                    .background(Constants.AppColor.appWhite)
                                    .edgesIgnoringSafeArea(.all)
                                    .ignoresSafeArea(),
                                   isActive: $isActive) {
                        Button(action: {
                            if comeFrom
                            {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.presentation.wrappedValue.dismiss()
                                }
                            }else {
                                self.isActive = true
                            }
                        }, label: {
                            Image( comeFrom ? "minimize" : "Icon feather-maximize-2")
                        })
                    }
                    Spacer()

                    if comeFrom{
                        
                        NavigationLink(destination:  PlayerView(profileVideo: $profileVideoPath).background(Constants.AppColor.appWhite.edgesIgnoringSafeArea(.bottom))
                                        .ignoresSafeArea()
                                        .navigationBarHidden(true), isActive: $isVideoPlay) {
                            Button(action: {
                                if self.isVideoPlay{
                                    self.isVideoPlay = false
                                }else{
                                    self.isVideoPlay = true
                                }
                            }, label: {
                                
                                if profileVideoPath != ""{
                                    
                                    if self.isVideoPlay{
                                        Image("play")
                                          
                                    }else{
                                        Image("pause")
                                    }
                                }
                            })
                        }
                    }else {
                        
                        Button(action: {
                            if self.isVideoPlay{
                                self.isVideoPlay = false
                            }else{
                                self.isVideoPlay = true
                            }
                        }, label: {
                            if profileVideoPath != ""{
                                if self.isVideoPlay{
                                    Image("play")
                                }else{
                                    Image("pause")
                                }
                            }
                        })
                    }
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                .padding(.top, comeFrom ? 40 : 0)
                
                Spacer()
                
                VStack(alignment: .leading){
                    HStack {
                        Text(card1.username ?? "").font(.largeTitle).fontWeight(.bold)
                        Text("\(card1.age ?? 0)").font(.largeTitle).fontWeight(.bold)
                        Image("Online")
                        
                    }
                    Text(getInterestNames()).font(.body)
                }
                
                HStack(alignment:.center,spacing:10){
                    Spacer()
                    //Dislike
                    Button {
                        callMatchLikeDislikeApi(action: "Unlike"){ (status) in
                            self.showAlert = true
                        }
                    } label: {
                        Image("matchNo")
                    }
                    
                    Spacer()
                    Button {
                        if  card1.chatStatusFrom?.count == 0 && card1.chatStatusTo?.count == 0  {
                            self.addchatrequest()
                        }
                        else{
                            if card1.chatStatusTo?.count != 0{
                                if card1.chatStatusTo?[0].activeStatus == "Active"{
                                    self.chatId = card1.chatStatusTo?[0].chatId ?? ""
                                    self.isChatActive = true
                                }else if card1.chatStatusFrom?[0].activeStatus == "Pending"{
                                    self.message = "your chat request is pending"
                                    self.showAlert = true
                                }
                            }else if card1.chatStatusFrom?.count != 0{
                                if card1.chatStatusFrom?[0].activeStatus == "Active"{
                                    self.chatId = card1.chatStatusTo?[0].chatId ?? ""
                                    self.isChatActive = true
                                }else if card1.chatStatusFrom?[0].activeStatus == "Pending"{
                                    self.message = "your chat request is pending"
                                    self.showAlert = true
                                }
                            }
                        }
                        
                    } label: {
                        //Image("messenger")
                        Image(isMsg ? "chat_Pink" : "chat_gray")
                            .resizable()
                            .renderingMode( .template)
                            .foregroundColor(isMsg ? Constants.AppColor.appPink:Color.white)
                            .frame(width:50,height:40)
                    }
                    Spacer()
                    
                    //Like
                    Button {
                        callMatchLikeDislikeApi(action: "Like"){ (status) in
                            self.showAlert = true
                        }
                    } label: {
                        Image("matchYes")
                    }
                    Spacer()
                }.padding(.bottom,comeFrom ? 40 : 0)
            }
            .padding()
            .foregroundColor(.white)
            
            if card1.x > 1 {
                Image("")
                    .resizable()
                    .background(Color.white.opacity(0.4))
                    .clipped()
                Image("matchTick")
            }else if card1.x == 0 {
                //Image("")

            }else {
                Image("")
                    .resizable()
                    .background(Color.white.opacity(0.4))
                    .clipped()
                Image("matchCross")
            }
            
            NavigationLink(destination: InboxAndRequestView(chatid : self.chatId),isActive: $isChatActive,label: {
            })
        
        }
        .frame( height: comeFrom ? UIScreen.main.bounds.height : UIScreen.main.bounds.height-330 )
        .cornerRadius(comeFrom ? 0 : 30)
        .clipped()
        .padding(.leading,comeFrom ? 0 : 32)
        .padding(.trailing,comeFrom ? 0 : 32)
        .offset(x: CGFloat(card1.x), y: CGFloat(card1.y))
        .rotationEffect(.init(degrees: card1.degree ?? 0.0))
        .gesture (
            DragGesture()
                .onChanged { value in
                    if !comeFrom{
                        withAnimation(.default) {
                            card1.x = Float(value.translation.width)
                            // MARK: - BUG 5
                            card1.y = Float(value.translation.height)
                            card1.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        }
                    }
                }
                .onEnded { (value) in
                    if !comeFrom{
                        self.play = false
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                card1.x = 0; card1.degree = 0; card1.y = 0
                            case let x where x > 100:
                                card1.x = 500; card1.degree = 12
                                callMatchLikeDislikeApi(action: "Like"){ (status) in
                                    self.showAlert = true
                                    self.isVideoPlay = false
                                }
                            // callMatchLikeDislikeApi(action: "Like")
                            case (-100)...(-1):
                                card1.x = 0; card1.degree = 0; card1.y = 0
                            case let x where x < -100:
                                card1.x  = -500; card1.degree = -12
                                callMatchLikeDislikeApi(action: "Unlike"){ (status) in
                                    self.showAlert = true
                                    self.isVideoPlay = false
                                }
                            //  callMatchLikeDislikeApi(action: "Unlike")
                            default:
                                card1.x = 10; card1.y = 10
                            }
                        }
                    }
                }
        )
        .alert(isPresented: $showAlert, content: {
            switch activeAlert {
            case .error:
                return  Alert(title: Text("Error"),
                              message: Text(message),
                              dismissButton: .default(Text("OK")) { })
            case .success:
                return  Alert(title: Text("Success"),
                              message: Text(message),
                              dismissButton: .default(Text("OK")) { })
                
            }
        })
        .onAppear{
           // print(card1.profilePicPath)
            self.item = card1
            
            if card1.chatStatusTo?.count != 0{
                if card1.chatStatusTo?[0].activeStatus == "Active"{
                    self.isMsg = true
                }
            }else if card1.chatStatusFrom?.count != 0{
                if card1.chatStatusFrom?[0].activeStatus == "Active"{
                    self.isMsg = true
                }
            }else {
                self.isMsg = false
            }
        }
    }
    
    func getInterestNames() -> String{
        var arrStr = [String]()
        for i in 0..<interestedList.count{
            arrStr.append(interestedList[i].name ?? "")
        }
        let str = arrStr.joined(separator: ",")
        return str
    }
    
    func callMatchLikeDislikeApi(action:String,completion: @escaping (Int) -> ()) {
        matchtVM.callMatchLikeDisLiketApi(card1.id ?? "", action: action) { result,response,error  in
            
            
            if result == strResult.success.rawValue{
                self.message = response?.message ?? ""
                self.error = false
                self.activeAlert = .success
                self.status = 1
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.error = true
                self.activeAlert = .error
                self.status = 0
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
            }
            
            if !comeFrom {
                if action == "Like"{
                    card1.x = 500
                    card1.degree = 12
                }else {
                    card1.x  = -500
                    card1.degree = -12
                }
            }
            self.showAlert = true
        }
    }
    
    func addchatrequest(){
        socialSuggestionListVM.AddChatRequestService(card1.id ?? "") { result, responce,error  in
            self.showAlert = true
            self.message = responce?.message ?? ""
            if result == strResult.success.rawValue{
                self.showAlert = true
            }else if result == strResult.error.rawValue{
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




