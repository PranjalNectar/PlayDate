//
//  AnonymousAnswerView.swift
//  PlayDate
//
//  Created by Pranjal on 04/06/21.
//

import SwiftUI
import ActivityIndicatorView

struct AnonymousAnswerView: View {
    @ObservedObject var CommentVM: CommentViewModel = CommentViewModel()
    @Environment(\.presentationMode) var presentation
    var commentStatus = true
    @State var txtPost = ""
    var postId = ""
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var arrComment : [GetCommentPost] = []
    @State var isDelete = false
    @State var selectedItem: GetCommentPost?
    @State var isDeletePopupShow = false
    
    var body: some View {
        ZStack{
            VStack(alignment:.leading){
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
//                            if self.selectedItem != nil{
//                                self.ShowCommentSheet = true
//                            }
                        }
                }.padding()
                HStack{
                    Text("Anonymous Question")
                        .fontWeight(.bold)
                        .font(.custom("Arial", size: 20.0))
                    Spacer()
                }.padding([.leading, .bottom, .trailing])
                
                if self.arrComment.count != 0{
                    ScrollView(showsIndicators: false){
                        VStack(alignment:.leading){
                            ForEach(self.arrComment){ item in
                                CommentList(CommentVM: self.CommentVM, isSheetShown: $isDelete, CommentData: item)
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
                            }
                        }
                    }
                }else{
                    VStack( alignment : .leading, spacing : 8){
                        Text("No Answers")
                            .fontWeight(.bold)
                            .font(.custom("Arial", size: 14.0))
                        Text("Be the first to answer...")
                            .font(.custom("Arial", size: 12.0))
                            .foregroundColor(.gray)
                    }.padding()
                }
                
                Spacer()
                VStack{
                    HStack{
                        ZStack(alignment: .leading) {
                            if self.txtPost.isEmpty { Text("Add a response...").foregroundColor(.gray) }
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
            if self.isDeletePopupShow{
                DeleteAnswerSheet(isShown: $isDeletePopupShow)
            }
            
            ActivityIndicatorView(isVisible: $CommentVM.loading, type: .flickeringDots)
                .foregroundColor(Constants.AppColor.appPink)
                .frame(width: 50.0, height: 50.0)
        }
        .navigationBarHidden(true)
        .onAppear{
            self.arrComment.removeAll()
            self.GetCommentService()
        }
        .onChange(of: self.isDelete, perform: { value in
            if self.isDelete{
                if self.isDelete {
                    self.isDeletePopupShow = false
                    self.DeleteCommentService()
                }
            }
        })
    }
    
    
    func PostCommentService(){
        self.CommentVM.AddPostCommentService(self.postId, comment: self.txtPost)  {  result, response,error  in
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
            }else if result == strResult.error.rawValue{
                arrComment = []
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                arrComment = []
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                arrComment = []
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    func DeleteCommentService(){
        self.CommentVM.DeletePostCommentService(self.postId, commentId: (selectedItem?.comments?.commentId)!) { (result) in
            
            if result == strResult.success.rawValue{
                self.arrComment.removeAll()
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


struct DeleteAnswerSheet : View{
    
    @Binding var isShown : Bool
    @State var isDeleteNotiOpen = false
    
    var body: some View {
        ZStack{
            HalfModalView(isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen, modalHeight: .constant(100), color: Color("darkgray")){
                
                HStack(){
                    Text("Answer has been deleted")
                        .foregroundColor(Constants.AppColor.appWhite)
                    Spacer()
                }
                .padding()
            }
        }
    }
}
