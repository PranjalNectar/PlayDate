//
//  BlockUserListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//


import SwiftUI

struct BlockUserListView : View {
    
    @State var id = ""
    @State var isShown = false
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject private var blockUserVM = BlockUserViewModel()
    @Environment(\.presentationMode) var presentation
    @State var arrBlockData = [BlockUserDataModel]()
    @State var isCall = false
    @State var isDeleteNotiOpen = false
    @State var status = 0
    
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                Button(action: { presentation.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .imageScale(.large)
                        .padding()
                }
                Text("Blocked Users")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Constants.AppColor.appBlackWhite)
            }.padding(.top,40)
            ZStack{
                List{
                    ForEach(self.arrBlockData) { item in
                        BlockUserCellView(block: item, status: .constant(0))
                            .onAppear{
                                UITableView.appearance().separatorStyle.self = .none
                            }
                            .onTapGesture {
                                self.isShown.toggle()
                                self.isDeleteNotiOpen = false
                                id = item.toUserId ?? ""
                            }

                    }

                }
                ActionSheetView(status: $status, id:$id, isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen)
                    .onAppear{
                        if status == 1 {
                            print("yes")
                            self.GetBlockListService()
                        }
                    }

                    .onChange(of: status, perform: { value in
                        if self.status == 1{
                            self.GetBlockListService()
                        }
                    })

                }
               
            }
           
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .ignoresSafeArea()
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
            .onAppear{
                //self.callSuggestionsHorizontalApi(filter: "")
                UITableView.appearance().showsVerticalScrollIndicator = false
                UITableView.appearance().separatorStyle = .none
                
                if self.isCall == false{
                    print("call service")
                    self.GetBlockListService()
                    self.isCall = true
                }

            }
            .onDisappear{
                self.isCall = false
            }
            
    
        }
   // }
    func GetBlockListService() {
        blockUserVM.GetBlockListService(postId: "100", status: "On") {  result, response,error  in
            if result == strResult.success.rawValue{
                self.arrBlockData = response?.data ?? []
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.arrBlockData = []
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

