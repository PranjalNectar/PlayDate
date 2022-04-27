//
//  CommentView.swift
//  PlayDate
//
//  Created by Pranjal on 27/05/21.
//

import SwiftUI
import ActivityIndicatorView

struct CommentView: View {
    
    @State var txtPost = ""
    var postId = ""
    var commentStatus = true
    @ObservedObject var CommentVM: CommentViewModel = CommentViewModel()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var arrComment : [GetCommentPost] = []
    @Environment(\.presentationMode) var presentation
    @State var isDelete = false
    @State var ShowCommentSheet = false
    @State var selectedItem: GetCommentPost?
    @State var isDeletePopupShow = false
    @State var apistatus = 0
    

    init(postId : String, commentStatus : Bool) {
        self.postId = postId
        self.commentStatus = commentStatus
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image("bback")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                    }
                    Spacer()
                    Image("PlayDateSmall")
                    Spacer()
                    Image("threeDots")
                        .onTapGesture {
                            if self.selectedItem != nil{
                                self.ShowCommentSheet = true
                            }
                        }
                }.padding()
                HStack{
                    Text("Comments")
                        .fontWeight(.bold)
                        .font(.custom("Arial", size: 20.0))
                    Spacer()
                }.padding([.leading, .bottom, .trailing])
                
                
                if self.commentStatus{
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(self.arrComment){ item in
                            CommentList(CommentVM: self.CommentVM, isSheetShown: $isDelete, CommentData: item)
                                .onChange(of: self.isDelete, perform: { value in
                                    if self.isDelete{
                                        if self.isDelete {
                                            self.isDeletePopupShow = false
                                            self.DeleteCommentService()
                                        }
                                    }
                                })
                                .modifier(CommentBGModifier(checked: item.id == self.selectedItem?.id))
                                .onLongPressGesture {
                                    if self.selectedItem != nil{
                                        self.selectedItem = nil
                                        self.selectedItem = item
                                        for i in 0..<self.arrComment.count{
                                            if self.arrComment[i].id == self.selectedItem?.id{
                                                self.arrComment[i].commentSelected = true
                                            }else{
                                                self.arrComment[i].commentSelected = false
                                            }
                                        }
                                    }else{
                                        for i in 0..<self.arrComment.count{
                                            if self.arrComment[i].id == item.id{
                                                self.selectedItem = item
                                                self.arrComment[i].commentSelected = true
                                            }
                                        }
                                    }
                                }
                                .onAppear{
//                                    if self.arrComment.last?.id == item.id{
//                                        if self.arrComment.count >= self.limit{
//                                            self.page += 1
//                                            self.GetCommentService()
//                                        }
//                                    }
                                }
                        }
                    }
                    
                    Spacer()
                    VStack{
                        HStack{
                            ZStack(alignment: .leading) {
                                if self.txtPost.isEmpty { Text("Add a comment...").foregroundColor(.gray) }
                                TextField("", text: $txtPost)
                                    .font(.custom("Arial", size: 18.0))
                                    .foregroundColor(.white)
                                    .accentColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                if !self.txtPost.isEmpty{
                                    self.PostCommentService()
                                }
                            }, label: {
                                Text("Post")
                                    .padding()
                                    .foregroundColor(.white)
                            })
                            .disabled(self.txtPost.isEmpty ? true : false)
                        }
                    }
                    .padding()
                    .background(Constants.AppColor.appDarkGary)
                }
                else{
                    VStack{
                        Text("Comments for this post have been disabled")
                            .font(.custom("Arial", size: 14.0))
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
            }
            if self.isDeletePopupShow{
                DeleteMessageSheet(isShown: $isDeletePopupShow)
            }
            
            if self.ShowCommentSheet{
                CommentOptionView(showSheet: self.$ShowCommentSheet, selectedComment: selectedItem, showAlert: $showAlert, showMsg: $message, postId: postId, status: $apistatus)
                    .onChange(of: self.message != "") { (value) in
                        if apistatus == 1 {
                            self.PostCommentService()
                            self.apistatus = 0
                        }
                        self.showAlert = true
                        print(message)
                    }
            }
            
            ActivityIndicatorView(isVisible: $CommentVM.loading, type: .flickeringDots)
                .foregroundColor(Constants.AppColor.appPink)
                .frame(width: 50.0, height: 50.0)
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
        .onChange(of: self.isDelete, perform: { value in
            if self.isDelete{
                if self.isDelete {
                    self.isDeletePopupShow = false
                    self.DeleteCommentService()
                }
            }
        })
        .onAppear{
            self.GetCommentService()
        }
    }
    
    func PostCommentService(){
        self.CommentVM.AddPostCommentService(self.postId, comment: self.txtPost) {  result, response,error  in
            if result == strResult.success.rawValue{
                self.txtPost = ""
                self.GetCommentService()
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
    
    func GetCommentService(){
        print(self.postId)
        self.CommentVM.GetPostCommentsService(self.postId) { result, response,error  in
            
            if result == strResult.success.rawValue{
                self.arrComment = response?.data ?? []
//                let arr = response?.data ?? []
//                print(arr.count)
//                for i in 0..<arr.count {
//                    self.arrComment.append(arr[i])
//                }
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.arrComment = []
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
    
    func DeleteCommentService(){
        self.CommentVM.DeletePostCommentService(self.postId, commentId: (selectedItem?.comments?.commentId)!) { (result) in
            
            if result == strResult.success.rawValue{
                
                self.isDeletePopupShow = true
                self.isDelete = false
                self.GetCommentService()
            }else if result == strResult.error.rawValue{
                //self.message = responce?.message ?? ""
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

struct CommentList : View{
    
    @ObservedObject var CommentVM: CommentViewModel
    @Binding var isSheetShown : Bool
    @State var CommentData : GetCommentPost
    
    @State var model = ToggleModel()
    
    var body: some View {
        //  ZStack{
        VStack(alignment : .leading,spacing : 8){
            HStack(spacing:8){
                Group{
                    Text(CommentData.username ?? "")
                        .fontWeight(.bold)
                        +
                        Text(" ")
                        +
                        Text(CommentData.comments?.comment ?? "")
                }
                
                .foregroundColor(
                    SharedPreferance.getAppDarkTheme() ? ((self.CommentData.commentSelected ?? false) ? .black: .white) : (self.CommentData.commentSelected ?? false) ? .white : .black
                )
                .font(.custom("Arial", size: 17.0))
                // Spacer()
            }
            .padding(.horizontal, 16.0)
            
            HStack(spacing:15){
                Text( common.getDateFromString(strDate: CommentData.comments?.entryDate ?? "").timeAgoSinceDate() )
                    .font(Font.system(size: 14))
                    .foregroundColor(.gray)
                
                Text("Like")
                    .font(Font.system(size: 14))
                    .foregroundColor(.gray)
                
                Text("Reply")
                    .font(Font.system(size: 14))
                    .foregroundColor(.gray)
                if CommentData.userId == UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""{
                    if (self.CommentData.commentSelected ?? false) {
                        Button(action: {
                            self.isSheetShown = true
                        }, label: {
                            Image("wdelete")
                                .padding([.all], 8.0)
                        })
                    }
                }
                Spacer()
            }.onChange(of: isSheetShown, perform: { (value) in
                print(isSheetShown)
            })
            .padding(.horizontal, 16.0)
        }
        .padding([.bottom,.top], 4.0)
    }
}

struct DeleteMessageSheet : View{
    
    @Binding var isShown : Bool
    @State var isDeleteNotiOpen = false
    
    var body: some View {
        ZStack{
            HalfModalView(isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen, modalHeight: .constant(100), color: Color("darkgray")){
                
                HStack(){
                    Text("Comment has been deleted")
                        .foregroundColor(Constants.AppColor.appWhite)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct CommentOptionView: View {
    
    @State var isShown = false
    @State var textFieldVal = ""
    @State var filters:[String] = []
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    @Binding var showSheet : Bool
    @State var selectedComment : GetCommentPost?
    @State var isDeleteNotiOpen = false
    @ObservedObject var CommentVM: CommentViewModel = CommentViewModel()
    @Binding var showAlert : Bool
    @Binding var showMsg : String
    @State private var message = ""
    @State var isOn = false
    @State var postId : String
    @Binding var status : Int
    @State var apiStatus = 0
    @State var isMyPost = false
    @State var comeFrom = true
    @ObservedObject var SocailFeedVM: SocialFeedViewModel = SocialFeedViewModel()
    @State var height = CGFloat()
    
    var body: some View {
        ZStack{
            HalfModalView(isShown: $showSheet, isDeleteNotiOpen: $isDeleteNotiOpen, modalHeight: $height, color: Color("darkgray")){
                
                VStack(spacing:15){
                    Image("LineNotch")
                        .padding(.bottom,20)
                    if self.isMyPost {
                        Toggle(isOn: self.$show1, label: {
                            Text("")
                                .font(Font.system(size: 12.5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .onAppear{
                                    self.height = self.height + 50.0
                                    
                                }
                        })
                        
                        .toggleStyle(
                            ColoredToggleStyle(label: "Turn Commenting Off",
                                               onColor: .white,
                                               offColor: .white,
                                               onThumbColor: Constants.AppColor.appPink, isOn: $isOn,postId: $postId, apiStatus: $apiStatus, comeFromComment: $comeFrom))
                        .onChange(of: apiStatus) { (value) in
                            if apiStatus == 1 {
                                
                                
                            }else {
                                
                            }
                            self.status = apiStatus
                        }
                    }
                    
                    if self.isMyPost == false{
                        Button(action: {
                            // self.show3.toggle()
                            
                            GetBlockUserService()
                        }, label: {
                            
                            HStack {
                                Text("Block User")
                                    .font(Font.system(size: 12.5))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                Image("block")
                            }.onAppear{
                                self.height = self.height + 50.0
                            }
                        })
                        
                    }
                    
                    Button(action: {
                        self.ReportCommentService { (status,msg) in
                            print(status)
                            self.status = status
                            self.message = msg
                        }
                        
                    }, label: {
                        HStack {
                            Text("Report Comment")
                                .font(Font.system(size: 12.5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Image("report")
                        }
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        
                        HStack {
                            Text("Pin Comment")
                                .font(Font.system(size: 12.5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Image("commentpin")
                        }.onAppear{
                            self.height = self.height + 50.0
                        }
                        
                    })
                    
                }
                .background(Color.clear)
                .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
                .padding(.horizontal)
                .padding(.top,20)
            }
            .onChange(of: self.isShown, perform: { value in
                if !self.isShown{
                    self.isShown = false
                    self.showSheet = false
                }
            })
            .onAppear{
                self.height = 70.0
                if selectedComment?.userId ?? "" == UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""{
                    self.isMyPost = true
                }else {
                    self.isMyPost = false
                }
            }
            ActivityLoader(isToggle: $CommentVM.loading)
        }
        //.alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
    }
    
    
    func ReportCommentService(completion: @escaping(Int,String) -> ()) {
        self.CommentVM.ReportPostCommentService((selectedComment?.comments?.postId)!, commentId: (selectedComment?.comments?.commentId)!) { (result,msg) in
            self.showAlert = false
            
            if result == strResult.success.rawValue{
                self.status = 1
            }else if result == strResult.error.rawValue{
                self.status = 0
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
            self.showMsg = msg ?? ""
            self.showAlert = true
        }
        
        completion(self.status, self.message)
    }
    
    func GetBlockUserService() {
        SocailFeedVM.GetBlockUserService(toUserId : selectedComment?.userId ?? "", action: "Block") { result, response, error in
            
            if result == strResult.success.rawValue{
                self.status = 1
            }else if result == strResult.error.rawValue{
                self.status = 0
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

struct CommentBGModifier: ViewModifier {
    var checked: Bool = false
    func body(content: Content) -> some View {
        Group {
            if checked {
                ZStack(alignment: .trailing) {
                    content
                        .background(self.checked ? Color("darkgray") : Constants.AppColor.appWhite )
                }
            } else {
                content
            }
        }
    }
}

