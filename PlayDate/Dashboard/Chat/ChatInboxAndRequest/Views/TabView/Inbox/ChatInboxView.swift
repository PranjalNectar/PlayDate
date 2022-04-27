//
//  ChatInboxView.swift
//  PlayDate
//
//  Created by Pranjal on 21/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatInboxView: View {
    
    let OnlineColor = "3AFF00"
    let SomeColor = "BAB646"
    let OfflineColor = "929292"
    @Binding var isPopupShow : Bool
    @State var InboxUserData : InboxUserListData?
    @Binding var selectedData : InboxUserListData?
     
    var body: some View {
        HStack{
            ZStack(alignment:.top){
                WebImage(url: URL(string: InboxUserData?.fromUser?[0].profilePicPath ?? ""))
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .cornerRadius(25)
                HStack{
                    Spacer()
                    Text(" ")
                        .frame(width : 10, height : 10)
                        .background(Color(hex: (InboxUserData?.fromUser?[0].onlineStatus ?? "" == "Offline") ? self.OfflineColor : self.OnlineColor))
                        .cornerRadius(5)
                }
            }
            .frame(width : 50, height: 50)
            Spacer(minLength: 10)
            HStack{
                VStack(alignment:.leading){
                    Text(InboxUserData?.fromUser?[0].username ?? "")
                        .fontWeight(.bold)
                        .font(.custom("Arial", size: 16.0))
                    if InboxUserData?.chatMessage?.count != 0{
                        if InboxUserData?.chatMessage?[0].messageType == messageTypeOption.text.rawValue{
                            Text(InboxUserData?.chatMessage?[0].message ?? "")
                                .font(.custom("Arial", size: 14.0))
                                .lineLimit(2)
                        }
                        else if InboxUserData?.chatMessage?[0].messageType == messageTypeOption.media.rawValue{
                            if InboxUserData?.chatMessage?[0].mediaInfo?[0].mediaType == "Image"{
                                Text("Photo")
                                    .font(.custom("Arial", size: 14.0))
                            }else if InboxUserData?.chatMessage?[0].mediaInfo?[0].mediaType == "Video"{
                                Text("video")
                                    .font(.custom("Arial", size: 14.0))
                            }else if InboxUserData?.chatMessage?[0].mediaInfo?[0].mediaType == "Audio"{
                                Text("Audio")
                                    .font(.custom("Arial", size: 14.0))
                            }
                        }
                        else if InboxUserData?.chatMessage?[0].messageType == messageTypeOption.location.rawValue{
                            Text("Current Location")
                                .font(.custom("Arial", size: 14.0))
                        }
                    }
                }
                Spacer()
            }
            Spacer(minLength: 10)
            VStack(spacing : 8){
                if InboxUserData?.chatMessage?.count != 0{
                    Text(common.getDateFromString(strDate: InboxUserData?.chatMessage?[0].entryDate ?? "").timeAgoSinceDate())
                        .font(.custom("Arial", size: 12.0))
                }
                if InboxUserData?.unreadChat != 0{
                    Text("\(InboxUserData?.unreadChat ?? 0)")
                        .padding(5)
                        .font(.custom("Arial", size: 10.0))
                        .foregroundColor(Color.white)
                        //.frame(width : 20, height : 20)
                        .background(Constants.AppColor.appPink)
                        .clipShape(Circle())
                    //.cornerRadius(10)
                }else{
                    Image("vdot")
                        .onTapGesture {
                            self.isPopupShow = true
                            self.selectedData = InboxUserData
                        }
                }
            }
            .frame(width : 50, height: 50)
        }
        .padding(.horizontal)
    }
    
}
