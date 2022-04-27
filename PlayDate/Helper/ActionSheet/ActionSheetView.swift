//
//  ActionSheetView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 29/04/21.
//

import SwiftUI

struct ActionSheetView: View {
    
    @Binding var status : Int
    @Binding var id : String
    @Binding var isShown : Bool
    @Binding var isDeleteNotiOpen : Bool
    @State var textFieldVal = ""
    @State var filters:[String] = []
    
    @State var Notistatus : Int = 0
    @State var unBlockStatus : Int = 0

    var body: some View {
        ZStack{
            
            HalfModalView(isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen, modalHeight: .constant(100), color: Color("darkgray")){

                ZStack{
                    if isDeleteNotiOpen{
                        DeleteNotiView(status: $Notistatus, isShown: $isShown, id: $id)
                            .onChange(of: Notistatus) { value in
                                if self.Notistatus == 1{
                                    status = 1
                                    self.Notistatus = 0
                                }
                            }
                    }else {
                        UnBlockUserView(status: $unBlockStatus, isShown: $isShown, id: $id)
                            .onChange(of: unBlockStatus, perform : { value in
                                
                                if self.unBlockStatus == 0{
                                     status = 0
                                }else{
                                     status = 1
                                }
                                
                            })
                    }
                }
            }
        }
    }
}


import SwiftUI

struct DeleteNotiView: View {
    
    @Binding var status : Int
    @Binding var isShown : Bool
    @Binding var id: String
    @State var show = false
    @ObservedObject private var notifiactionVM = NotificationViewModel()
    var body: some View {
        VStack(spacing:15){
            Image("LineNotch")
            Button(action: {
                self.UpdateNotificationService()
            }, label: {
                HStack {
                    Text("Delete")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("Icon metro-bin")
                }
            })
        }
    .background(Color.clear)
    .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
    .padding(.horizontal)
    }
    
    func UpdateNotificationService(){
        notifiactionVM.callUpadteNotificationApi(id,status: "1",action:"delete") { result, response,error in
            if result == strResult.success.rawValue{
                status = 1
            }else if result == strResult.error.rawValue{
                status = 0
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
            isShown.toggle()
        }
    }
}


struct UnBlockUserView: View {
    
    @Binding var status : Int
    @Binding var isShown : Bool
    @Binding var id: String
    @State var show = false
    @ObservedObject private var blockUserVM = BlockUserViewModel()
    var body: some View {
        VStack(spacing:15){
            Image("LineNotch")
            Button(action: {
                self.UnBlockUserService()
            }, label: {
                HStack {
                    Text("Unblock User")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    // Image("icons8-unlock")
                    Image("icons8-unlock")
                        .frame(width:20,height:20)
                }
            })
        }
        .background(Color.clear)
        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
    }
    
    func UnBlockUserService(){
        blockUserVM.GetUnblockBlockService(toUserId: id, action: "Block") { result, response,error  in
            if result == strResult.success.rawValue{
                status = 1
            }else if result == strResult.error.rawValue{
                status = 0
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
            
            isShown.toggle()
        }
    }
}


struct AllView: View {
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    @State var isOn = false
    @State var status = 0
    
    var body: some View {
        VStack(spacing:15){
            Button(action: {
                self.show3.toggle()
                
            }, label: {
                
                HStack {
                    Text("Turn Post Notfication ON")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("bookmark")
                }
                
            })
            
            Button(action: {
                self.show3.toggle()
                
            }, label: {
                
                HStack {
                    Text("Block User")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("block")
                }
                
            })
            
            Button(action: {
                self.show2.toggle()
                
            }, label: {
                
                HStack {
                    Text("Report Post")
                        .font(Font.system(size: 12.5))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image("report")
                }
                
            })
            
            
            
            Toggle(isOn: self.$show1, label: {
                Text("")
                    .font(Font.system(size: 12.5))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            })
            
            .toggleStyle(
                ColoredToggleStyle(label: "Turn Posts ON For This User",
                                   onColor: .white,
                                   offColor: .white,
                                   onThumbColor: Constants.AppColor.appPink, isOn: $isOn, postId: .constant(""), apiStatus: $status, comeFromComment: .constant(false)))
        }
    .background(Color.clear)
    .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
    
    .padding(.horizontal)
    .padding(.top,20)
    }
}


