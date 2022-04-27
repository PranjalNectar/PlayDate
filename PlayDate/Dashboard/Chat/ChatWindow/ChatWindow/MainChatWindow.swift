//
//  MainChatWindow.swift
//  PlayDate
//
//  Created by Pranjal on 22/06/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SocketIO

struct MainChatWindow: View {
    
    @Environment(\.presentationMode) var presentation
    let OnlineColor = "3AFF00"
    let OfflineColor = "929292"
    
    @State private var message = ""
    @State private var isEditing = false
    @State private var isPlus = false
    @State private var isCamera = false
    @State private var isGallery = false
    @State private var isVoice = false
    @State private var isOpenMedia = false
    @State var OtherUserData : InboxUserListData?
    @State var messages: [MockMessages.ChatMessageItem] = []
    @State var showImagePicker: Bool = false
    @State private var mediaType = ""
    @State var sourceType: UIImagePickerController.SourceType?
    @ObservedObject var lm = LocationManager()
    @ObservedObject private var ChatWindowVM = ChatWindowViewModel()
    @State private var scrollToBottom: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage = ""
    @State private var userIdTyping: String = ""
    @State private var messageType: String = ""
    @State private var mediaID: String = ""
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var checkMedia: String = ""
    @State private var isTyping: Bool = false
    @State private var showingAlert = false
    @State private var isVoiceSend: Bool = false
    @State private var isChatAnswerPopup: Bool = false
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    let socket = SocketIOManager.shared
    let username = "\(UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)?["username"] ?? "")"
    let profilePicPath = "\(UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)?["profilePicPath"] ?? "")"
    @State var arrQuestion : [Question] = []
    @State var arrPromotions : [String] = []
    @State var sendAnswer : QuestionAnswerModel?
    @State var page = 1
    @State var limit = 20
    @State var messageId: String = ""
    @State var DataType = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Image("bback")
                            .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                    }
                    .padding()
                    HStack{
                        WebImage(url: URL(string: OtherUserData?.fromUser?[0].profilePicPath ?? ""))
                            .resizable()
                            .placeholder {
                                Rectangle().foregroundColor(.gray)
                            }
                            .cornerRadius(25)
                            .frame(width : 50, height: 50)
                        
                        // Spacer(minLength: 8)
                        VStack(alignment:.leading){
                            Text(OtherUserData?.fromUser?[0].username ?? "")
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 16.0))
                                .lineLimit(1)
                                .padding(.horizontal)
                                .fixedSize()
                            
                            HStack{
                                if self.isTyping{
                                    Text("Typing....")
                                        .font(.custom("Arial", size: 14.0))
                                        .fixedSize()
                                }else{
                                    if (OtherUserData?.fromUser?[0].onlineStatus ?? "" == "Online"){
                                        Text("Active Now")
                                            .font(.custom("Arial", size: 14.0))
                                        
                                        Text(" ")
                                            .frame(width : 10, height : 10)
                                            .background(Color(hex: self.OnlineColor))
                                            .cornerRadius(5)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .fixedSize()
                        }
                    }
                    Spacer()
                        .padding()
                }.padding(.horizontal)
                
                Spacer()
                
                chatView
                    .onChange(of: self.sourceType, perform: { value in
                        if self.sourceType != nil{
                            self.isOpenMedia = true
                        }
                    })
                
                if self.isPlus{
                    ChatShareOptionView
                }
            }
            
            if isChatAnswerPopup{
                ChatAnswerPopup(getAnswer : self.sendAnswer,isClose: $isChatAnswerPopup)
                    .animation(.easeIn(duration: 0.2))
                    .transition(.move(edge: .bottom))
            }
            ActivityLoader(isToggle: $ChatWindowVM.loading)
        }
        
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.alertMessage)
        
        .onAppear{
            self.socketListner()
            self.GetChatMessageList()
            self.socket.ChatMessageRead(chatID: OtherUserData?.chatId ?? "")
        }
        .onChange(of: self.page, perform: { (value) in
            print(self.page)
            self.GetChatMessageList()
        })
       
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text(Constants.AppName),
                message: Text("Are you sure you want to share you current location?"),
                primaryButton: .default(Text("Share")){
                    print("share...")
                    self.messageType = messageTypeOption.location.rawValue
                    self.latitude = lm.lastLocation?.coordinate.latitude ?? 0.0
                    self.longitude = lm.lastLocation?.coordinate.longitude ?? 0.0
                    self.sendtxtMessage()
                },
                secondaryButton: .cancel()
            )
        }
      
        .popover(isPresented: $isVoice, content: {
            if self.isVoice {
                AudioRecorderView(audioRecorder: audioRecorder,isSend: $isVoiceSend)
            }
        })
       
        .onChange(of: self.isVoiceSend, perform: { value in
            if self.isVoiceSend{
                var data = Data()
                self.checkMedia = "chat_audio"
                self.messageType = messageTypeOption.media.rawValue
                self.mediaType = MediaType.audio.rawValue
                print(self.audioRecorder.recordings[0].fileURL)
                let url = URL(fileURLWithPath: self.audioRecorder.recordings[0].fileURL.path)
                do{
                    data = try Data(contentsOf:url, options: [])
                    self.AddChatMediaService(mediaData: data)
                }catch{
                    print(error)
                }
                self.isVoiceSend = false
            }
        })
        
        .sheet(isPresented: $isOpenMedia) {
            if self.isOpenMedia {
                var data = Data()
                CommonImagePickerView(sourceType: sourceType!, mediaType: $mediaType) { image in
                    //self.image = image
                    print(mediaType)
                    if mediaType == MediaType.image.rawValue{
                        self.checkMedia = "chat_image"
                        self.messageType = messageTypeOption.media.rawValue
                        data = image?.jpegData(compressionQuality: 0.5) ?? Data()
                        self.AddChatMediaService(mediaData: data)
                    }
                    if mediaType == MediaType.video.rawValue{
                        self.checkMedia = "chat_video"
                        self.messageType = messageTypeOption.media.rawValue
                        let videoFilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "chatvideo.mp4"//return your filename from the getFileName function
                        let url = URL(fileURLWithPath: videoFilename)
                        do{
                            data = try Data(contentsOf:url, options: [])
                            self.AddChatMediaService(mediaData: data)
                        }catch{
                            print(error)
                        }
                    }
                }
                .onDisappear{
                    self.isOpenMedia = false
                    self.sourceType = nil
                }
            }
        }
    }
    
    private var chatView: some View {
        
        ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(messages: $messages,scrollToBottom: $scrollToBottom, pageCount: $page) {
            
            BasicInputView(
                message: $message,
                isEditing: $isEditing,
                isPlus: $isPlus,
                isCamera: $isCamera,
                isGallery: $isGallery,
                isVoice: $isVoice,
                placeholder: "Type your text",
                sourceType: $sourceType,
                onCommit: {
                    messageKind in
                    self.messageType = messageTypeOption.text.rawValue
                    self.sendtxtMessage()
                }
            )
            .padding(8)
            .padding(.bottom, isEditing ? 0 : 8)
            .background(Color.primary.colorInvert())
            .onChange(of: isEditing) { (res) in
                if self.isEditing{
                    print("edit start")
                }else{
                    print("edit end")
                }
                self.typingtxtMessage()
            }
            .embedInAnyView()
        }
        
        .onMessageCellTapped({ (message) in
            print(message.messageKind)
            switch message.messageKind {
            case .location(let loca):
                print(loca.latitude)
                print(loca.longitude)
                let url = "http://maps.apple.com/maps?saddr=\(loca.latitude),\(loca.longitude)"
                UIApplication.shared.open(URL(string: url)!)
                return print("test")
            default: break
            }
            print("testing ------ Location -----------")
        })
        
        .onQuestionItemSelected({ item,questionID  in
            print(questionID)
            print(item)
            self.sendAnswer(questionId: questionID, optionId: item.optionId ?? "")
        })
        
        
        .messageCellContextMenu { message -> AnyView in
             var DeleteButton: some View {
                Button(action: {
                    print("Delete Context Menu tapped!!")
                    // Delete text
                    print(message.messageID)
                    self.messageId = message.messageID
                    self.DeleteChatMessageService()
                }) {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
            
            switch message.messageKind {
            
            case .text:
                if message.isSender{
                    return DeleteButton.embedInAnyView()
                }else{
                    return EmptyView().embedInAnyView()
                }
                
            case .image(_) :
                if message.isSender{
                    return DeleteButton.embedInAnyView()
                }else{
                    return EmptyView().embedInAnyView()
                }
                
            case .video(_):
                if message.isSender{
                    return DeleteButton.embedInAnyView()
                }else{
                    return EmptyView().embedInAnyView()
                }
                
            case .voice(_):
                if message.isSender{
                    return DeleteButton.embedInAnyView()
                }else{
                    return EmptyView().embedInAnyView()
                }
                
            case .location(_):
                if message.isSender{
                    return DeleteButton.embedInAnyView()
                }else{
                    return EmptyView().embedInAnyView()
                }
            default:
                // If you don't want to implement contextMenu action
                // for a specific case, simply return EmptyView like below;
                return EmptyView().embedInAnyView()
            }
        }
       
        .environmentObject(ChatMessageCellStyle())
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .listStyle(PlainListStyle())
    }
    
    private var ChatShareOptionView: some View {
        VStack{
            HStack{
                VStack{
                    ZStack{
                        Image("c_sharebg")
                        Image("c_location")
                    }
                    Text("Location")
                        .font(.custom("Arial", size: 14.0))
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    //// Open Location /////
                    self.showingAlert = true
                    self.isPlus = false
                }
                .padding(8)
                VStack{
                    ZStack{
                        Image("c_sharebg")
                        Image("c_date")
                    }
                    Text("Date")
                        .font(.custom("Arial", size: 14.0))
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    //// Open Date /////
                    self.isPlus = false
                }
                .padding(8)
                Spacer()
            }
        }
        .frame(maxWidth : .infinity)
        .frame(height : 120)
        .background(Constants.AppColor.appDarkGary)
        
    }
    
    func GetChatMessageList(){
        self.ChatWindowVM.GetChatMessageService(OtherUserData?.chatId ?? "",limit:self.limit, page: self.page){ result, response,error  in
            
            if result == strResult.success.rawValue{
                //print(response?.data?.count)
                //print(response?.questions?.count)
                //?.reversed()
                self.arrQuestion = response?.questions ?? []
                self.arrPromotions = response?.promotions ?? []
                let arr = response?.data ?? []
                var arrMain : [messageData] =  []
                print(arr.count)
                for i in 0..<arr.count {
                    arrMain.append(arr[i])
                }
                self.CreateMessages(arrMessages: arrMain)
            }else if result == strResult.error.rawValue{
                self.alertMessage = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.alertMessage = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.alertMessage = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    func AddChatMediaService(mediaData : Data){
        self.ChatWindowVM.AddChatMediaService("chat", mediatype: self.mediaType, imgData: mediaData, check: self.checkMedia) { result, response,error  in
            
            if result == strResult.success.rawValue{
                // print(response?.data)
                self.mediaID = response?.data?.mediaId ?? ""
                self.sendtxtMessage()
            }else if result == strResult.error.rawValue{
                self.alertMessage = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.alertMessage = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.alertMessage = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    
    func DeleteChatMessageService(){
        self.ChatWindowVM.DeleteChatMessageService(OtherUserData?.chatId ?? "",messageId: self.messageId){ result, response,error  in
            
            if result == strResult.success.rawValue{
                self.messages.removeAll(where: {$0.messageID == self.messageId})
            }else if result == strResult.error.rawValue{
                self.alertMessage = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.alertMessage = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.alertMessage = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    
    
    
    func CreateMessages(arrMessages : [messageData]){
        // var isQuestion = false
        for i in 0..<arrMessages.count{
            let item = arrMessages[i]
            
            var isSender = true
            if item.userId == UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""{
                isSender = true
            }else{
                isSender = false
            }
            
            ///////////////// ------------  Text Message ---------- ///////////////////////
            if item.messageType == messageTypeOption.text.rawValue{
                self.messages.append(
                    .init(user: MockMessages.ChatUserItem.init(
                            userName: "",
                            avatarURL: URL(string: item.userInfo?[0].profilePicPath ?? ""),
                            avatar: nil),
                          messageKind: .text(item.message ?? ""),
                          isSender: isSender,
                          date: common.getDateFromString(strDate: item.entryDate ?? ""),
                          messageID: item.messageId ?? ""
                          )
                )
            }
            ///////////////// ------------  media Message ---------- ///////////////////////
            else  if item.messageType == messageTypeOption.media.rawValue{
                // ------------  image Message ---------- //
                if item.mediaInfo?[0].mediaType == "Image"{
                    self.messages.append(
                        .init(user: MockMessages.ChatUserItem.init(
                                userName: "",
                                avatarURL: URL(string: item.userInfo?[0].profilePicPath ?? ""),
                                avatar: nil),
                              messageKind: .image(.remote(URL(string: item.mediaInfo?[0].mediaFullPath ?? "")!)),
                              isSender:  isSender,
                              date: common.getDateFromString(strDate: item.entryDate ?? ""),
                              messageID: item.messageId ?? "")
                    )
                }
                // ------------  video Message ---------- //
                else if item.mediaInfo?[0].mediaType == "Video"{
                    
                    let videoItem = VideoRow(
                        url: URL(string: item.mediaInfo?[0].mediaFullPath ?? "")!,
                        placeholderImage: .remote(URL(string: item.mediaInfo?[0].mediaThumbName ?? "")!),
                        pictureInPicturePlayingMessage: ""
                    )
                    self.messages.append(
                        .init(user: MockMessages.ChatUserItem.init(
                                userName: "",
                                avatarURL: URL(string: item.userInfo?[0].profilePicPath ?? ""),
                                avatar: nil),
                              messageKind: .video(videoItem),
                              isSender:  isSender,
                              date: common.getDateFromString(strDate: item.entryDate ?? ""),
                              messageID: item.messageId ?? "")
                    )
                }
                // ------------  audio Message ---------- //
                else if item.mediaInfo?[0].mediaType == "Audio"{
                    let itemvoice = VoiceRow.init(url: URL(string: item.mediaInfo?[0].mediaFullPath ?? "")!)
                    self.messages.append(
                        .init(user: MockMessages.ChatUserItem.init(
                                userName: "",
                                avatarURL: URL(string: item.userInfo?[0].profilePicPath ?? ""),
                                avatar: nil),
                              messageKind: .voice(itemvoice),
                              isSender: isSender,
                              date: common.getDateFromString(strDate: item.entryDate ?? ""),
                              messageID: item.messageId ?? "")
                    )
                }
            }
            
            ///////////////// ------------  Location Message ---------- ///////////////////////
            else  if item.messageType == messageTypeOption.location.rawValue{
                if item.lat != nil && item.longField != nil{
                    let location = LocationRow(
                        latitude: Double(item.lat!) ?? 0.0,
                        longitude: Double(item.longField!) ?? 0.0
                    )
                    self.messages.append(.init(
                                            user: MockMessages.ChatUserItem.init(
                                                userName: "",
                                                avatarURL: URL(string: item.userInfo?[0].profilePicPath ?? ""),
                                                avatar: nil),
                                            messageKind: .location(location),
                                            isSender: isSender,
                                            date: common.getDateFromString(strDate: item.entryDate ?? ""),
                                            messageID: item.messageId ?? "")
                    )
                }
            }
            
            /////////////////// Question Answer Polling Promotions ///////////
            
            for i in 0..<self.arrQuestion.count{
                if self.arrQuestion[i].status == "Active"{
                    if !(self.arrQuestion[i].isShow ?? false) {
                        print(common.getDateFromString(strDate: item.entryDate ?? "") - 1 )
                        print(common.getDateFromString(strDate:self.arrQuestion[i].entryDate ?? "") - 1)
                        if (common.getDateFromString(strDate: item.entryDate ?? "") - 1) > (common.getDateFromString(strDate:self.arrQuestion[i].entryDate ?? "") - 1){
                            //isQuestion = true
                            self.arrQuestion[i].isShow = true
                            
                            
                            let ques = self.arrQuestion[i]
                            let questionitem = questionRow.init(questionID: ques.questionId ?? "",
                                                                text: ques.question ?? "",
                                                                options: ques.options ?? [])
                            
                            //---------  promotion -----------//
                            for j in 0..<self.arrPromotions.count{
                                self.messages.append(
                                    .init(user: MockMessages.ChatUserItem.init(
                                            userName: "admin",
                                            avatarURL:nil,
                                            avatar: UIImage(named: "c_diamond")),
                                          messageKind: .text(self.arrPromotions[j]),
                                          isSender: false,
                                          date: common.getDateFromString(strDate: self.arrQuestion[i].entryDate ?? "")
                                    )
                                )
                            }
                            //////----------------------------///
                            
                            self.messages.append(
                                .init(user: MockMessages.ChatUserItem.init(
                                        userName: "",
                                        avatarURL:nil,
                                        avatar: UIImage(named: "c_diamond")),
                                      messageKind: .question(questionitem),
                                      isSender: false,
                                      date: common.getDateFromString(strDate: self.arrQuestion[i].entryDate ?? "")
                                )
                            )
                        }
                    }
                }
            }
        }
        
        if self.page == 1{
            self.scrollToBottom = true
        }
    }
    
    func sendtxtMessage(){
        let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                   "chatId": OtherUserData?.chatId ?? "",
                   "message" : message,
                   "username" : username,
                   "profilePic" : profilePicPath,
                   "mediaId" : self.mediaID,
                   "lat" : self.latitude,
                   "long" : self.longitude,
                   "messageType" : self.messageType
        ] as [String : Any]
        print(dic)
        self.socket.SendMessageData(event: EventName.chat_message_room.rawValue, dic: dic) {
            print("--------- send ------")
            self.DataType = ""
        }
    }
    
    func sendAnswer(questionId : String, optionId : String){
        let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                   "chatId": OtherUserData?.chatId ?? "",
                   "username" : username,
                   "profilePic" : profilePicPath,
                   "questionId" : questionId,
                   "optionId" : optionId
        ] as [String : Any]
        print(dic)
        self.socket.SendMessageData(event: EventName.chat_question_answer.rawValue, dic: dic) {
            print("--------- send ------")
            self.DataType = "Answer"
        }
    }
    
    func typingtxtMessage(){
        let dic = ["userId": UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                   "chatId": OtherUserData?.chatId ?? "",
                   "typing" : self.isEditing,
                   "username" : username,
                   "profilePic" : profilePicPath
        ] as [String : Any]
        print(dic)
        self.socket.SendMessageData(event: EventName.typing.rawValue, dic: dic) {
            print("--------- send ------")
            self.DataType = ""
        }
    }
}


private struct LocationRow: LocationItem {
    var latitude: Double
    var longitude: Double
}

private struct VideoRow: VideoItem {
    var url: URL
    var placeholderImage: ImageLoadingKind
    var pictureInPicturePlayingMessage: String
}

private struct questionRow: QuestionItem {
    var questionID: String
    var text: String
    var options: [Option]
}


private struct VoiceRow: VoiceItem {
    var url: URL
}

enum messageTypeOption : String {
    case text
    case media
    case emoji
    case question
    case location
}

extension  MainChatWindow{
    
    func socketListner(){
        socket.HandledEventdate { (event, data) in
            
            if event == EventName.chat_message_room.rawValue{
                print("---------- received ------------")
                print(data)
                do {
                    let msg = data[0] as! [String:Any]
                    let apiData = try JSONSerialization.data(withJSONObject: msg , options: .prettyPrinted)
                    let response = try JSONDecoder().decode(textMessageModel.self, from: apiData )
                    // print("JSON", result.data.fullName)
                    print(response)
                    
                    if response.chatId == OtherUserData?.chatId{
                        var isSender = true
                        if response.userId == UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""{
                            isSender = true
                        }else{
                            isSender = false
                        }
                        ///////////////// ------------  text Message ---------- ///////////////////////
                        if response.messageType == messageTypeOption.text.rawValue{
                            self.messages.insert( .init(
                                user: MockMessages.ChatUserItem.init(
                                    userName: "",
                                    avatarURL: URL(string: response.profilePic ?? ""),
                                    avatar: nil),
                                messageKind: .text(response.message ?? ""),
                                isSender: isSender,
                                date: Date(),
                                messageID: response.messageId ?? ""
                            ), at: 0)
                        }
                        ///////////////// ------------  media Message ---------- ///////////////////////
                        else if response.messageType == messageTypeOption.media.rawValue{
                            
                            // ------------  image Message ---------- //
                            if response.mediaType == "Image"{
                                self.messages.insert( .init(user: MockMessages.ChatUserItem.init(
                                                                userName: "",
                                                                avatarURL: URL(string: response.profilePic ?? ""),
                                                                avatar: nil),
                                                              messageKind: .image(.remote(URL(string: response.mediaFullPath ?? "")!)),
                                                              isSender:  isSender,
                                                              date: Date(), messageID: response.messageId ?? ""), at: 0)
                            }
                            
                            // ------------  video Message ---------- //
                            else if response.mediaType == "Video"{
                                let videoItem = VideoRow(
                                    url: URL(string: response.mediaFullPath ?? "")!,
                                    placeholderImage: .remote(URL(string: response.mediaFullPathThumb ?? "")!),
                                    pictureInPicturePlayingMessage: ""
                                )
                                self.messages.insert(.init(user: MockMessages.ChatUserItem.init(
                                                            userName: "",
                                                            avatarURL: URL(string: response.profilePic ?? ""),
                                                            avatar: nil),
                                                          messageKind: .video(videoItem),
                                                          isSender:  isSender,
                                                          date: Date(), messageID: response.messageId ?? ""), at: 0)
                            }
                            // ------------  audio Message ---------- //
                            else if response.mediaType == "Audio"{
                                let item = VoiceRow.init(url: URL(string: response.mediaFullPath ?? "")!)
                                
                                self.messages.insert(.init(user: MockMessages.ChatUserItem.init(
                                                            userName: "",
                                                            avatarURL: URL(string: response.profilePic ?? ""),
                                                            avatar: nil),
                                                          messageKind: .voice(item),isSender: isSender,date: Date(), messageID: response.messageId ?? ""
                                                    ), at: 0)
                            }
                            
                        }
                        ///////////////// ------------  location Message ---------- ///////////////////////
                        else if response.messageType == messageTypeOption.location.rawValue{
                            let location = LocationRow(
                                latitude: response.lat ?? 0.0,
                                longitude: response.long ?? 0.0
                            )
                            self.messages.insert(.init(user: MockMessages.ChatUserItem.init(
                                                        userName: "",
                                                        avatarURL: URL(string: response.profilePic ?? ""),
                                                        avatar: nil),
                                                    messageKind: .location(location),
                                                    isSender: true,
                                                    date: Date(), messageID: response.messageId ?? ""), at: 0)
                        }
                        self.scrollToBottom = true
                    }
                } catch (let error){
                    print("ERROR:", error)
                }
            }
            
            else if event == EventName.typing.rawValue{
                do {
                    let msg = data[0] as! [String:Any]
                    let apiData = try JSONSerialization.data(withJSONObject: msg , options: .prettyPrinted)
                    let response = try JSONDecoder().decode(textMessageModel.self, from: apiData)
                    self.userIdTyping = response.userId ?? ""
                    //print(response.typing)
                    if response.chatId == OtherUserData?.chatId{
                        if response.userId == OtherUserData?.fromUser?[0].userId{
                            if (response.typing != nil){
                                if response.typing == true{
                                    self.isTyping = true
                                }else{
                                    self.isTyping = false
                                }
                            }
                        }else{
                            self.isTyping = false
                        }
                        print(response)
                    }
                } catch (let error){
                    print("ERROR:", error)
                }
            }
            else if event == EventName.chat_question_answer.rawValue{
                do {
                    let msg = data[0] as! [String:Any]
                    let apiData = try JSONSerialization.data(withJSONObject: msg , options: .prettyPrinted)
                    let response = try JSONDecoder().decode(QuestionAnswerModel.self, from: apiData)
                    self.userIdTyping = response.userId ?? ""
                    //print(response.typing)
                    if response.chatId == OtherUserData?.chatId{
                        print(response)
                        self.sendAnswer = response
                        //print( self.sendAnswer)
                        self.isChatAnswerPopup = true
                    }
                } catch (let error){
                    print("ERROR:", error)
                }
            }
            
            else if event == EventName.Data.rawValue{
                do {
                    let msg = data[0] as! [String:Any]
                    let apiData = try JSONSerialization.data(withJSONObject: msg , options: .prettyPrinted)
                    let response = try JSONDecoder().decode(AnswerModel.self, from: apiData)
                    
                    if self.DataType == "Answer"{
                        if response.status == 0{
                            self.alertMessage = response.message ?? ""
                            self.showAlert = true
                        }
                    }
                    
                } catch (let error){
                    print("ERROR:", error)
                }
            }
        }
    }
}
