//
//  ProfileTabViews.swift
//  PlayDate
//
//  Created by Pranjal on 28/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityIndicatorView

struct ProfileTabView: View {
    var tabs = ["My Feed","Liked Media"]
    @State var selectedTab = "My Feed"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @Binding var arrFeedData : [SocialFeedData]
    @State var isClicked = false
    @State var isShown = false
    @Binding var isSheetShow : Bool
    @Binding var isStatus : Int
    @State var feeddata : SocialFeedData?
    @Binding var feedtoSheet : SocialFeedData?
    @Binding var geometryHeight : CGFloat
    @Binding var geometryWidth : CGFloat
    
    var body: some View {
        VStack{
            HStack(spacing : 10){
                ForEach(tabs,id: \.self){tabData in
                    
                    ProfileButton(title: tabData, selectedTab: $selectedTab)
                    
                    if tabData != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }.padding(.leading,20)
            .padding(.trailing,20)
            .background(Color.clear)
            
            if selectedTab == "My Feed" {
                MyFeedView(isAlreadyFriend: .constant(false), userID: .constant(""), comeFromProfileTab: .constant(true), arrFeedData: $arrFeedData, isClicked: $isClicked, isSheetShow: $isShown, feedtoSheet: $feeddata,geometryHeight : $geometryHeight,geometryWidth:$geometryWidth, apistatus: $isStatus).tag("My Feed")
                    .onChange(of: self.isShown, perform: { value in
                        if isShown{
                            self.isSheetShow = true
                            self.feedtoSheet = feeddata
                            self.isShown = false
                        }
                    })
            }else {
                MyLikeView().tag("Liked Media")
            }
            
        }
        .onChange(of: self.selectedTab, perform: { value in
            if self.selectedTab == "My Feed"{
                self.isClicked =  false
            }
        })
        
    }
}

struct ProfileButton : View {
    @State var title : String
    @Binding var selectedTab : String
    var body: some View {
        ZStack{
            Button(action: {
                selectedTab = title
               
            }) {
                VStack(spacing:10){
                    Text(title)
                       
                        .fontWeight(selectedTab == title ?.semibold : .regular)
                        .font(Font.system(size: 17.5))
                        .foregroundColor(selectedTab == title ? Constants.AppColor.appBlackWhite : Color.gray)
                    
                    Capsule()
                        .fill(selectedTab == title ? Color("pink") : Color.gray)
                        .frame(height:3)
                        .padding(.bottom,10)
                }
            }
        }.navigationBarHidden(true)
    }
}

struct MyFeedView: View {
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Binding var isAlreadyFriend : Bool
    @Binding var userID : String
    @Binding var comeFromProfileTab : Bool
    @Binding var arrFeedData : [SocialFeedData]
    @State var isCall = false
    @State var isShown = false
    @Binding var isClicked : Bool
    @Binding var isSheetShow : Bool
   // @Binding var userId : Int
    @State var feed : SocialFeedData?
    @Binding var feedtoSheet : SocialFeedData?
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @Binding var geometryHeight : CGFloat
    @Binding var geometryWidth : CGFloat
    @Binding var apistatus : Int
    @State var page = 1
    @State var limit = 15
    
    var body: some View {
        VStack{
            if !self.isClicked{
                    LazyVGrid(columns: columns, spacing : 10) {
                        ForEach(self.arrFeedData) { item in
                           
                            if !comeFromProfileTab && isAlreadyFriend == false{
                                ZStack{
                                    Image("")
                                        .frame(width: 115, height: 136)
                                        .background(Constants.AppColor.appDarkGary)
                                        .cornerRadius(15)
                                    Image("profileLock")
                                }
                            }else{
                                if item.media![0].mediaType == "Image"{
                                    WebImage(url: URL(string: item.media![0].mediaFullPath!))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity).accentColor(.pink)
                                        .frame(width: 115, height: 136)
                                        .scaledToFill()
                                        .cornerRadius(15)
                                        .onTapGesture {
                                            self.isClicked = true
                                        }
                                        .onAppear{
                                            self.pageCalculator(feed: item)
                                        }
                                }else{
                                    ZStack{
                                        WebImage(url: URL(string: item.media![0].mediaThumbName ?? ""))
                                            .resizable()
                                            .placeholder {
                                                Rectangle().foregroundColor(.gray)
                                            }
                                            .indicator(.activity).accentColor(.pink)
                                            .scaledToFill()
                                            .frame(width: 115, height: 136)
                                            .cornerRadius(15)
                                        
                                        Image("play")
                                    }
                                    .onTapGesture {
                                        self.isClicked = true
                                    }
                                    .onAppear{
                                        self.pageCalculator(feed: item)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear{
                        UIScrollView().bounces = false
                        UIScrollView().isScrollEnabled = false
                    }
                    .padding()
               // }
            }else{
                ScrollView() {
                    ScrollViewReader { proxy in
                        LazyVStack {
                            ForEach(self.arrFeedData) { item in
                                FeedCellView(isShown: $isShown,feed : item, sendfeed: $feed, isCall: $isCall, status: $apistatus)
                                
                            }
                        }
                    }
                }
                .padding()
                .onChange(of: self.apistatus, perform: { value in
                    if self.apistatus  == 1{
                        self.GetmyfeedService()
                       // self.apistatus = 0
                    }
                })
            }
        }//.padding()
        .navigationBarHidden(true)
        .onChange(of: self.isShown, perform: { value in
            if self.isShown{
                self.isSheetShow = true
                self.feedtoSheet = feed
                self.isShown = false
                //self.isCall = false
            }
        })
        .onAppear(perform:{
            self.arrFeedData.removeAll()
            self.GetmyfeedService()
        })
    }
    
    func pageCalculator(feed : SocialFeedData){
        if self.arrFeedData.last?.id == feed.id{
            if self.arrFeedData.count > limit{
                self.page += 1
                self.GetmyfeedService()
            }
        }
    }
    
    func GetmyfeedService(){
      
        ProfileVM.GetMyFeedService(self.limit, page: self.page, userId: userID, comeFromProfileTab: comeFromProfileTab) { result, response,error in
            if result == strResult.success.rawValue{
                //self.arrFeedData = response?.data ?? []
                
                let arr = response?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrFeedData.append(arr[i])
                }
            }else if result == strResult.error.rawValue{
//                self.message = response?.message ?? ""
//                self.showAlert = true
                self.arrFeedData = []
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
                self.arrFeedData = []
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
                self.arrFeedData = []
            }
        }
    }
}

struct MyLikeView: View {
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @State var arrSaveGalleryData = [ProfileSaveGalleryData]()
    @State var isCall = false
    @State var page = 1
    @State var limit = 15
    
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false){
                LazyVGrid(columns: columns, spacing : 10) {
                    ForEach(self.arrSaveGalleryData) { item in
                        if item.mediaType == "Image"{
                            WebImage(url: URL(string: item.mediaFullPath!))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity).accentColor(.pink)
                                .scaledToFill()
                                .frame(width: 115, height: 136)
                                .cornerRadius(15)
                                .onAppear{
                                    self.pageCalculator(feed: item)
                                }
                        }else{
                            ZStack{
                                WebImage(url: URL(string: item.mediaThumbName ?? ""))
                                    .resizable()
                                    .placeholder {
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .indicator(.activity).accentColor(.pink)
                                    .scaledToFill()
                                    .frame(width: 115, height: 136)
                                    .cornerRadius(15)
                                    .onAppear{
                                        self.pageCalculator(feed: item)
                                    }
                                Image("play")
                            }
                        }
                    }
                }
                .onAppear{
                    UIScrollView().bounces = false
                    UIScrollView().isScrollEnabled = false
                }
            }
                
        }.padding()
        .onAppear(perform: {
            if self.isCall == false{
                self.GetLikeGalleryService()
                self.isCall = true
            }
        })

    }
    
    func pageCalculator(feed : ProfileSaveGalleryData){
        if self.arrSaveGalleryData.last?.id == feed.id{
            if self.arrSaveGalleryData.count > limit{
                self.page += 1
                self.GetLikeGalleryService()
            }
        }
    }
    
    func GetLikeGalleryService(){
        ProfileVM.GetSaveGalleryService(self.limit, page: self.page) { result, response,error in
         //   self.arrSaveGalleryData = arrData
            
            print(arrSaveGalleryData)
            
            if result == strResult.success.rawValue{
                //self.arrSaveGalleryData = response?.data?.uniqueIDSRemove{$0.id ?? ""} ?? []
                let arr = response?.data?.uniqueIDSRemove{$0.id ?? ""} ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.arrSaveGalleryData.append(arr[i])
                }
            }else if result == strResult.error.rawValue{
//                self.message = response?.message ?? ""
//                self.showAlert = true
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
        }
    }
    
    
}
