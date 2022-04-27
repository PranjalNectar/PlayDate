//
//  NotificationView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/05/21.
//

import SwiftUI
struct NotificationView : View {
    
    //MARK:- Properties
    @State var id = ""
    @State var status = 0
    @State var noti = 0
    @State var isDeleteNotiOpen = false
    @State var isShown = false
    @State var data1 = [NotiDataModel]()
    @ObservedObject private var notificationVM = NotificationViewModel()
    @Environment(\.presentationMode) var presentation
    @State private var message = ""
    @State private var showAlert: Bool = false
    @State var isAddOptionShow = true
    
    @State var page = 1
    @State var limit = 100
    @State var date = ""
    
    @State var arrToday = [NotiDataModel]()
    @State var arrYesterday = [NotiDataModel]()
    @State var arrDaysAgo = [NotiDataModel]()
    
    @State var sections: [notitest] = []
                            
    //MARK:- Body
    var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                Button(action: { presentation.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Constants.AppColor.appBlackWhite)
                        .imageScale(.large)
                        .padding()
                }
                Text("Notification")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Constants.AppColor.appBlackWhite)
            }
            
            ZStack{
                List {
                    ForEach(self.sections) { section in
                        Section(header: HStack {
                            Text(section.title)
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 16))
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .padding()
                            Spacer()
                        }
                        .background(Constants.AppColor.appWhite)
                        .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
                        ) {
                            ForEach(section.noti) { item in
                                NotificationCellView(data: item, status: $status)
//                                    .onAppear{
//                                        if self.sections.last?.noti.last?.id == item.id{
//                                            self.page += 1
//                                            self.callNotificationApi(filter: "")
//                                        }
//                                    }
                                
                                    .onLongPressGesture {
                                        self.isShown.toggle()
                                        self.isDeleteNotiOpen = true
                                        id = item.notificationId ?? ""
                                    }
                                    .frame(maxWidth : .infinity, alignment : .leading)
                                    .background(id == item.notificationId ? Constants.AppColor.applightPink : Color.clear)
                            } // end of ForEach
                        } // end of Section
                    } // end
                }
                ActionSheetView(status: $status, id:$id, isShown: $isShown, isDeleteNotiOpen: $isDeleteNotiOpen)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onChange(of: status, perform: { value in
            if self.status == 1{
                self.data1.removeAll()
                self.callNotificationApi(filter: "")
                self.status = 0
            }
        })
        .onAppear{
            UITableView.appearance().showsVerticalScrollIndicator = false
            UITableView.appearance().separatorStyle = .none
            if status == 0 {
                self.isDeleteNotiOpen = true
                print("yes")
                self.data1.removeAll()
                self.callNotificationApi(filter: "")
            }
        }
    }
    
    
    //MARK:- Call Api
    func callNotificationApi(filter:String) {
        notificationVM.callNotificationListApi(self.limit, page: self.page) {  result, response,error in
            if result == strResult.success.rawValue{
                let arr = response?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.data1.append(arr[i])
                }
                if page > 1 && arr.count==0{
                    
                }else{
                    self.SectionCreate()
                }
                if self.data1.count == 0 {
                    self.message = "Record not found"
                    self.showAlert = true
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
    
    func SectionCreate(){
        let events = data1
        let grouped = Dictionary(grouping: events) { (occurrence: NotiDataModel) -> String in
            common.getDateFromString(strDate: occurrence.entryDate ?? "" ).timeAgoInNotification()
        }
        self.sections = grouped.map { day -> notitest in
            notitest(title: day.key, noti: day.value, date: common.getDateFromString(strDate: day.value[0].entryDate ?? "" ) )
        }.sorted { $0.date > $1.date }
    }
}

struct notitest : Identifiable{
    let id = UUID()
    let title: String
    let noti : [NotiDataModel]
    let date: Date
}
