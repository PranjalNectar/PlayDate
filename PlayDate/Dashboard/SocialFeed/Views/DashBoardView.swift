//
//  DashBoardView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 27/04/21.
//

import SwiftUI
import ActivityIndicatorView
import SocketIO

struct DashBoardView: View {
    @State var isShown = false
    @Binding var isDashboardSheetShow : Bool
    @Binding var isCall : Bool
    @State private var array = [1, 1, 2]
    @State var arrFeedData = [SocialFeedData]()
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var feeddata : SocialFeedData?
    @Binding var feedtoSheet : SocialFeedData?
    @State var menu = 0
    @State var isSocialActive = false
    @State var status = 0
    @State var isSeeMore = false
    @State var socialSuggestionInvite = false
    @Binding var apistatus : Int
    @State var isShowPremiumPopup = false
    @State var isTimerRunning = true
    @State var isActive = true
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var relationship = ""
    let socket = SocketIOManager.shared
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 20
    @State var page = 1
    @State var limit = 4

    @State var noti_moduleId : String = ""
    @State var isnotiPushComment : Bool = false
    @State var isnotiPushNotification : Bool = false
    @State var isnotiPushAcceptDate : Bool = false

    var body: some View {
        ZStack{
            VStack {
                GeometryReader { geometry in
                    VStack{
                        SocialFeedView(menu: $menu,userSearch:.constant(true),socialSuggestionInvite: $socialSuggestionInvite,relationship:$relationship)
                            .onAppear{
                                let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                              relationship = (getRegisterDefaultData?["relationship"] ?? "") as! String
                                
                                print(relationship)
                            }
                            .onChange(of: socialSuggestionInvite, perform: { value in
                                if self.socialSuggestionInvite{
                                    print("")
                                }
                            })
                        //Spacer()
                        
                        if menu == 0{
                            let isSuggestionOpen = UserDefaults.standard.bool(forKey: Constants.UserDefaults.isSuggestionOpen)
                            if isSuggestionOpen || self.arrFeedData.count == 0{
                              
                                SuggestionForYouView(isSeeMore:$isSeeMore,showAlert:$showAlert,message:$message).tag("social")
                                    .navigationBarHidden(true)
                            }else {
                              //  VStack {
                                    if self.socialSuggestionInvite{
//                                        CustomScrollView(width: 50, height: 50, viewModel: SocialFeedViewModel())  {
                                            
//                                        }
                                        ScrollView(showsIndicators: false) {
                                            ScrollViewReader { proxy in
                                                LazyVStack {
                                                    ForEach(self.arrFeedData) { item in
                                                        FeedCellView(isShown: $isShown,feed : item, sendfeed: $feeddata, isCall: $isCall,status:$apistatus)
                                                            .onAppear{
                                                                if self.arrFeedData.last?.id == item.id{
                                                                    self.page += 1
                                                                    self.GetSocailFeedService()
                                                                }
                                                            }
                                                            .onChange(of: self.apistatus) { (value) in
                                                                print(self.isCall)
                                                                if self.isCall == false{
                                                                    print("call service")
                                                                    self.page = 1
                                                                    self.GetSocailFeedService()
                                                                    self.isCall = true
                                                                }
                                                            }
                                                    }
                                                }
                                            }
                                           // .LegacyScrollView()
                                        }
                                        
                                        .padding()
                                    }else {
                                        if isSeeMore == true{
                                            SuggestedInviteListView().tag("social").ignoresSafeArea().tag("social")
                                                .background(Color.white)
                                                .navigationBarHidden(true)
                                                .navigationBarBackButtonHidden(true)
                                                .edgesIgnoringSafeArea(.all)
                                                //.padding(.bottom,30)
                                        }else {
                                            SuggestionForYouView(isSeeMore:$isSeeMore,showAlert:$showAlert,message:$message).tag("social")//.background(Constants.AppColor.appWhite.edgesIgnoringSafeArea(.bottom))
                                                // .ignoresSafeArea()
                                                .navigationBarHidden(true)
                                        }
                                    }
                               // }
                            }
                        }else if menu == 1{
                            MatchView(message: $message, showAlert: $showAlert)
                        }
                    }
                }
                .onChange(of:  self.isSeeMore, perform: { value in
                    if isSeeMore {
                        isSeeMore = false
                    }else {
                        isSeeMore = true
                    }
                })
               
            }.onChange(of: self.apistatus) { (value) in
                print(self.isCall)
                if self.isCall == false{
                    print("call service")
                    self.arrFeedData.removeAll()
                    self.page = 1
                    self.GetSocailFeedService()
                    self.isCall = true
                }
            }
            
            NavigationLink(destination: CommentView(postId: self.noti_moduleId, commentStatus: true), isActive:$isnotiPushComment){
                EmptyView()
            }
            
            NavigationLink(destination: NotificationView(), isActive:$isnotiPushNotification){
                EmptyView()
            }
            
            NavigationLink(destination: AcceptDateListView(), isActive:$isnotiPushAcceptDate){
                EmptyView()
            }
          
            ActivityLoader(isToggle: $SocailFeedVM.loading)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
        .statusBar(style: .lightContent)
        .fullScreenCover(isPresented: $isShowPremiumPopup, content: {
            GetPreminumPopup(isShowPremiumPopup: $isShowPremiumPopup, isTimerRunning: $isTimerRunning, timeRemaining: $timeRemaining)
                .background(BackgroundClearView())
        })
        .onReceive(timer) { _ in
            if self.isTimerRunning  {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                   // isShowPremiumPopup = true
                }else{
                    self.isTimerRunning = false
                    if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                        self.isShowPremiumPopup = true
                    }
                    print(timeRemaining)
                }
                print(timeRemaining)
            }
        }
        .onChange(of:  self.isShown, perform: { value in
            if self.isShown{
                self.isDashboardSheetShow = true
                self.isShown = false
                self.feedtoSheet = feeddata
            }
        })
        .onAppear(perform: {
        
            socket.establishConnection()
            if self.isCall == false{
                print("call service")
                self.arrFeedData.removeAll()
                self.page = 1
                self.GetSocailFeedService()
                self.isCall = true
            }
            if isSeeMore{
                isSeeMore = false
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "PushNotification")), perform: { obj in
            self.NavigationOnScreen(userInfo: obj.userInfo ?? [:])
        })
        
        .onDisappear{
            self.isCall = false
            self.timer.upstream.connect().cancel()
            self.isTimerRunning = false
        }
        
    }
    
    func GetSocailFeedService() {
        SocailFeedVM.GetSocialFeedService(self.limit, page: self.page) { result, response,error  in
            if result == strResult.success.rawValue{
                let arr = response?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrFeedData.append(arr[i])
                }
                print(self.arrFeedData.count)
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                //self.showAlert = true
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


extension DashBoardView{
    func NavigationOnScreen(userInfo : [AnyHashable : Any]){
        let notiType = userInfo["notificationType"] as! String
        self.noti_moduleId = userInfo["moduleId"] as! String
        if notiType == PushNotificationType.RELATIONSHIP_REQUEST.rawValue{
            
        }
        else if notiType == PushNotificationType.POST_COMMENT.rawValue{
            self.isnotiPushComment = true
        }
        else if notiType == PushNotificationType.POST_TAGGED.rawValue{
            self.isnotiPushNotification = true
        }
        else if notiType == PushNotificationType.POST_LIKED.rawValue{
            self.isnotiPushNotification = true
        }
        else if notiType == PushNotificationType.FRIEND_REQUEST.rawValue{
            self.isnotiPushNotification = true
        }
        else if notiType == PushNotificationType.MATCH_REQUEST.rawValue{
            self.isnotiPushNotification = true
        }
        else if notiType == PushNotificationType.DATE_REQUEST.rawValue{
            self.isnotiPushAcceptDate = true
        }
        else if notiType == PushNotificationType.CHAT_REQUEST.rawValue{
            self.isnotiPushNotification = true
        }
        
    }
}

enum PushNotificationType : String{
    case RELATIONSHIP_REQUEST
    case POST_COMMENT
    case POST_TAGGED
    case POST_LIKED
    case FRIEND_REQUEST
    case MATCH_REQUEST
    case DATE_REQUEST
    case CHAT_REQUEST
}

enum PushNotificationModuleType : String{
    case FRIEND
    case MATCH
    case DATE
    case RELATIONSHIP
    case POST
    case CHAT
}
