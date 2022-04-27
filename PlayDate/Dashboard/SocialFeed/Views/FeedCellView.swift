//
//  FeedCellView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 27/04/21.
//


import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct FeedCellView: View {
    @State  var isLiked = false
    @State  var isSave = false
    @State  var people = false
    @State  var isPostLiked = false
    @State  var isThreeDotClicked = false
    @State  var commentSelected = false
    @State  var ResponceSelected = false
    @State private var arrayComment = [1, 1, 2]
    @Binding var isShown : Bool
    @State var feed : SocialFeedData
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var isVideoPlay = false
    @State var LikeStatus = ""
    @State var SaveStatus = ""
    @State var CommentStatus = true
    @State var arrComment : [CommentsData] = []
    @Binding var sendfeed : SocialFeedData?
    @Binding var isCall : Bool
    @Binding var status : Int
    @State private var play: Bool = false
    @State private var time: CMTime = .zero
    
    @State var likeAniMate = false
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                //Header
                if feed.postType == "Normal"{
                    HStack {
                        if feed.media?.count ?? 0 > 0{
                            WebImage(url: URL(string: feed.postedBy![0].profilePicPath ?? ""))
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                }
                                .indicator(.activity).accentColor(.pink)
                                .cornerRadius(15)
                                .frame(width:30,height : 30)
                        }
                        VStack(alignment: .leading) {
                            Text(feed.postedBy![0].username ?? "")
                                .font(Font.system(size: 13.5))
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Image("threeDots").onTapGesture {
                            self.isThreeDotClicked = true
                            
                            self.isShown = true
                            self.sendfeed = feed
                        }
                    }
                    .padding(.horizontal, 5)
                    //Post
                    
                    //VStack{
                        ZStack{
                            if feed.media?.count != 0{
                                if feed.media?[0].mediaType == "Image"{
                                    WebImage(url: URL(string: feed.media![0].mediaFullPath!))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .cornerRadius(25)
                                        .clipped()
                                        .aspectRatio(contentMode: .fill)
                                        .padding(.top,5)
                                        .padding(.leading,5)
                                        .padding(.trailing,5)
                                        .padding(.bottom,5)
                                    
                                    Button(action: {
                                        if self.isLiked == false{
                                            self.LikeStatus = "Like"
                                            self.isLiked = true
                                            self.isPostLiked = true
                                            self.feed.likes! += 1
                                            feed.isLike! = 1
                                        }else{
                                            self.LikeStatus = "Unlike"
                                            self.isLiked = false
                                            self.isPostLiked = false
                                            if self.feed.likes! > 0{
                                                self.feed.likes! -= 1
                                                feed.isLike! = 0
                                            }
                                        }
                                        self.LikeDislike()
                                    }, label: {
                                        HeartBigButton(isLiked: $isLiked, isPostLiked: $isPostLiked, likeAniMate: $likeAniMate)
                                    })
                                   
                                }else{
                                    ZStack{
                                        if self.isVideoPlay {
                                        VideoPlayer(url: URL(string: feed.media![0].mediaFullPath ?? "")!, play: $play, time: $time)
                                                .cornerRadius(25)
                                                .clipped()
                                                .aspectRatio(1, contentMode: .fit)
                                                .onAppear() {
                                                    self.play = true
                                                }
                                                .onDisappear() {
                                                    self.play = false
                                                    self.isVideoPlay = false
                                                }
                                        }else{
                                            Button(action: {
                                                self.isVideoPlay = true
                                            }, label: {
                                                WebImage(url: URL(string: feed.media![0].mediaThumbName ?? ""))
                                                    .resizable()
                                                    
                                                    .placeholder {
                                                        Rectangle().foregroundColor(.gray)
                                                    }
                                                    .indicator(.activity)
                                                    .cornerRadius(25)
                                                    .clipped()
                                                    .aspectRatio(1, contentMode: .fill)
                                            })
                                        }
                                        Button(action: {
                                            if self.isVideoPlay{
                                                self.isVideoPlay = false
                                            }else{
                                                self.isVideoPlay = true
                                            }
                                        }, label: {
                                            if self.isVideoPlay{
                                                Image("play")
                                            }else{
                                                Image("pause")
                                            }
                                        })
                                        
                                    }
                                    .padding(.top,5)
                                    .padding(.leading,5)
                                    .padding(.trailing,5)
                                    .padding(.bottom,5)
                                }
                            }
                        }

                        HStack {
                                Button(action: {
                                    if self.isLiked == false{
                                        self.LikeStatus = "Like"
                                        self.likeAniMate = true
                                        self.isLiked = true
                                        self.isPostLiked = true
                                        self.feed.likes! += 1
                                        feed.isLike! = 1
                                    }else{
                                        self.LikeStatus = "Unlike"
                                        self.likeAniMate = false
                                        self.isLiked = false
                                        self.isPostLiked = false
                                        if self.feed.likes! > 0{
                                            self.feed.likes! -= 1
                                            feed.isLike! = 0
                                        }
                                    }
                                    self.LikeDislike()
                                }, label: {
                                    HeartButton(isLiked: $isLiked, isPostLiked: $isPostLiked)
                                })
                                .frame(width : 25, height : 22)
                       
                            ZStack {
                                NavigationLink(
                                    destination: CommentView(postId: self.feed.postId!, commentStatus: self.CommentStatus),
                                    isActive: $commentSelected,
                                    label: {
                                       
                                    })
                                    .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                                
                                Button(action: {
                                    self.commentSelected = true
                                }, label: {
                                    Image("comment")
                                        .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                        .cornerRadius(8)
                                })
                                .onDisappear{
                                    self.commentSelected = false
                                }
                            }
                           
                            Spacer()
                            
                            Button(action: {
                                if self.isSave == false{
                                    self.isSave = true
                                    self.SaveStatus = "Save"
                                    feed.isGallerySave! = 1
                                }else{
                                    self.isSave = false
                                    self.SaveStatus = "Delete"
                                    feed.isGallerySave! = 0
                                }
                                self.SaveGalleryService()
                            }, label: {
                                if self.isSave == false{
                                    Image("saveImage")
                                }else{
                                    Image("saveImagefill")
                                }
                            })
                        }
                        .padding(.horizontal, 5)
                        Text("\(feed.likes!) Loves")
                            .font(Font.system(size: 10.5))
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)

                    
                    VStack(alignment:.leading,spacing:1) {
                        if feed.media?.count ?? 0 > 0{
                            HStack(spacing:8){
                                if (feed.tag  ?? "") != "" {
                                    Group{
                                        Text(feed.postedBy![0].username ?? "")
                                            .fontWeight(.bold)
                                            +
                                            Text(" ")
                                            +
                                            Text(feed.tag  ?? "")
                                    }
                                    .font(.custom("Arial", size: 11.5))
                                    .lineLimit(2)
                                }
                             
                                Spacer()
                            }
                        }
                    } .padding(.horizontal, 5)
                    
                    VStack(alignment:.leading,spacing:1) {
                       
                        if self.arrComment.count != 0 {
                            ForEach(self.arrComment){item in
                                    HStack(spacing:8){
                                        Group{
                                            Text(item.commentBy![0].username ?? "")
                                                .fontWeight(.bold)
                                                +
                                                Text(" ")
                                                +
                                                Text(item.comment ?? "")
                                        }
                                        .font(.custom("Arial", size: 11.5))
                                        .lineLimit(2)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                        
                        Button(action: {
                            self.commentSelected = true
                        }, label: {
                            Text("Add a comment...")
                                .foregroundColor(.gray)
                                .font(Font.system(size: 10.5))
                                .frame(height: 30)
                        })
                        .padding(.bottom, 8)
                        .padding(.horizontal, 5)
                    
                }else if feed.postType == "Question"{
                    VStack{
                        HStack {
                            Image("qheart")
                                .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                .foregroundColor(isLiked ? Constants.AppColor.appPink : Constants.AppColor.appBlackWhite)
                            Text("Anonymous Question")
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 13.5))
                            Spacer()
                            Image("qmedal")
                        }
                        .padding([.bottom, .top], 8.0)
                        .padding(.horizontal, 5)
                        Spacer()
                        
                        VStack{
                            VStack{
                                Text(feed.tag ?? "")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 21.0))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            VStack{
                                Text(String(UnicodeScalar( Int(feed.emojiCode ?? "") ?? 0x0) ?? "-"))
                                    .font(.custom("Arial", size: 100.0))
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top,5)
                        .padding(.leading,8)
                        .padding(.trailing,8)
                        .padding(.bottom,5)
                        .background(Color(hex: feed.colorCode ?? "D13A6F"))
                        .cornerRadius(20)
                    }
                    //.padding()
                        
                    HStack(alignment : .center){ // spacing : 40
                        Spacer()
                        ZStack (alignment : .center){
                            Button(action: {
                                self.ResponceSelected = true
                            }) {
                                Text("Respond")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .font(.custom("Arial", size: 14.0))
                                    .padding()
                            }
                            .frame(width : 150)
                            .background(Color("pink"))
                            .cornerRadius(25)
                            
                            NavigationLink(
                                destination: AnonymousAnswerView(commentStatus: self.CommentStatus, postId: self.feed.postId!),
                                isActive: $ResponceSelected,
                                label: {
                                })
                                .buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0.0)
                        }
                       
                        if (feed.userId!) == (UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""){
                            
                            Spacer()
                            
                            Button(action: {
                                GetDeletePostService()
                            }, label: {
                                Text("Delete")
                                    .fontWeight(.medium)
                                    .foregroundColor(Constants.AppColor.appBlackWhite)
                                    .font(.custom("Arial", size: 14.0))
                                    .padding()
                            })
                            .frame(width : 150)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color("pink"), lineWidth: 3)
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 5)
                    
                    if self.arrComment.count != 0 {
                        VStack(spacing : 5){
                            HStack{
                                Text("\(self.arrComment.count) Answer")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 11.5))
                                Spacer()
                            }
                            //.padding([.leading], 10.0)
                            ForEach(self.arrComment){item in
                                HStack(spacing:8){
                                    Group{
                                        Text(item.commentBy![0].username ?? "")
                                            .fontWeight(.bold)
                                            +
                                            Text(" ")
                                            +
                                            Text(item.comment ?? "")
                                    }
                                    .font(.custom("Arial", size: 11.5))
                                    .lineLimit(2)
                                    Spacer()
                                }
                                //.padding([.leading, .bottom, .trailing], 10.0)
                            }
                        }
                        .padding(.bottom, 8)
                        .padding(.horizontal, 5)
                    }else{
                        
                        VStack( alignment : .leading, spacing : 8){
                            Text("No Answers")
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 14.0))
                            Text("Be the first to answer...")
                                .font(.custom("Arial", size: 12.0))
                                .foregroundColor(.gray)
                        }
                        .padding([.leading, .bottom, .trailing], 5.0)
                    }
                }
            }
            .padding(.leading,0)
            .padding(.trailing,0)
            //.buttonStyle(PlainButtonStyle())
        }
        
        .onAppear{
            if self.feed.commentsList?.count != 0{
                self.arrComment = self.feed.commentsList!
                self.CommentStatus = self.feed.commentStatus ?? true
            }
            if feed.isLike == 0{
                self.LikeStatus = "Like"
                self.isLiked = false
                self.isPostLiked = false
            }else{
                self.LikeStatus = "Unlike"
                self.isLiked = true
                self.isPostLiked = true
            }
            if feed.isGallerySave == 0{
                self.SaveStatus = "Save"
                self.isSave = false
            }else{
                self.SaveStatus = "Delete"
                self.isSave = true
            }
        }
    }
    
    func LikeDislike(){
        print(self.LikeStatus)
        SocailFeedVM.PostLikeUnlikeService(feed.postId!, status: self.LikeStatus) { result,error  in
            
            if result == strResult.success.rawValue{
                
            }else if result == strResult.error.rawValue{
//                self.message = responce?.message ?? ""
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
    
    func SaveGalleryService(){
        print(self.SaveStatus)
        SocailFeedVM.PostSaveService(feed.postId!, status: self.SaveStatus) { result,error in
            if result == strResult.success.rawValue{
                
            }else if result == strResult.error.rawValue{
//                self.message = responce?.message ?? ""
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

    func GetDeletePostService() {
        SocailFeedVM.GetDeletePostService(postId : feed.postId ?? "") { result, response,error  in
           
            if result == strResult.success.rawValue{
                self.isCall = false
                self.status = 1
            }else if result == strResult.error.rawValue{
                self.isCall = true
                self.status = 0
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


struct HeartButton: View {
    @Binding var isLiked: Bool
    @Binding var isPostLiked : Bool
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isLiked ? 0.9 : 0.3
    }
    @State private var animate = false
    
    var body: some View{
        Image(isLiked ? "fillHearts" : "unfillHearts")
            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
            .foregroundColor(isLiked ? Constants.AppColor.appPink : Constants.AppColor.appBlackWhite)
            .scaleEffect(animate ? animationScale : 1)
            .animation(.easeIn(duration: animationDuration))

    }
}


struct HeartBigButton: View {
    @Binding var isLiked: Bool
    @Binding var isPostLiked : Bool
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isPostLiked ? 0.9 : 0.3
    }
    @State private var animate = false
    @State var animationInProgress = false
    @Binding var likeAniMate: Bool
    
    
    var body: some View{
        ZStack{
            Button(action: {
                self.animate = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration, execute: {
                    self.animate = false
                    self.isPostLiked.toggle()
                    self.isLiked.toggle()
                    self.animationInProgress.toggle()
                })
            }, label: {
                if likeAniMate{
                    LikeView(animationInProgress: $likeAniMate)
                }
            })
            .scaleEffect(animate ? animationScale : 1)
            .animation(.easeIn(duration: animationDuration))
        }
    }
}
