//
//  ChatView.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI
//import SwiftUIEKtensions

public struct ChatView<Message: ChatMessage, User: ChatUser>: View {
    
    @Binding private var messages: [Message]
    private var inputView: () -> AnyView
    private var onMessageCellTapped: (Message) -> Void = { msg in print(msg.messageKind) }
    private var messageCellContextMenu: (Message) -> AnyView = { _ in EmptyView().embedInAnyView() }
    private var onQuickReplyItemSelected: (QuickReplyItem) -> Void = { _ in }
    private var contactCellFooterSection: (ContactItem, Message) -> [ContactCellButton] = { _, _ in [] }
    private var onAttributedTextTappedCallback: () -> AttributedTextTappedCallback = { return AttributedTextTappedCallback() }
    private var onCarouselItemAction: (CarouselItemButton, Message) -> Void = { (_, _) in }
    private var onQuestionItemSelected: (Option, String) -> Void = { _,_  in }
    
    @available(iOS 14.0, *)
    @Binding private var scrollToBottom: Bool
    @State private var isKeyboardActive = false
    @State private var contentSizeThatFits: CGSize = .zero
    @Binding private var PageCount: Int
    
    let positionScroll = CGAffineTransform(rotationAngle: -.pi)
    let positionscale  = CGAffineTransform.init(scaleX: 1, y: -1)
    let degreesToFlip: Double = 180
    
    private var messageEditorHeight: CGFloat {
        min(
            contentSizeThatFits.height,
            0.25 * UIScreen.main.bounds.height
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                chatView(in: geometry)
                inputView()
                    .onPreferenceChange(ContentSizeThatFitsKey.self) {
                        contentSizeThatFits = $0
                    }
                    .frame(height: messageEditorHeight)
                    .padding(.bottom, 12)
                
                PIPVideoCell<Message>()
            }
            .iOS { $0.keyboardAwarePadding() }
        }
        .environmentObject(DeviceOrientationInfo())
        .environmentObject(VideoManager<Message>())
        .edgesIgnoringSafeArea(.bottom)
        .iOS { $0.dismissKeyboardOnTappingOutside() }
    }
    
    @ViewBuilder private func chatView(in geometry: GeometryProxy) -> some View {
        if #available(iOS 14.0, *) {
            iOS14Body(in: geometry.size)
                .padding(.bottom, messageEditorHeight + 30)
        } else {
            iOS14Fallback(in: geometry.size)
                .padding(.bottom, messageEditorHeight + 16)
        }
    }
    
    @available(iOS 14.0, *)
    private func iOS14Body(in size: CGSize) -> some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(messages) { message in
                        chatMessageCellContainer(in: size, with: message)
                            .onAppear{
                                if !scrollToBottom{
                                    if messages.last?.id == message.id{
                                        print("-------------Top item  get----------")
                                        self.PageCount += 1
                                    }
                                }
                            }
                            .rotationEffect(.degrees(self.degreesToFlip))
                    }
                }
                .onChange(of: scrollToBottom) { value in
                    if value {
                        withAnimation {
                            proxy.scrollTo(messages.first?.id)
                        }
                        scrollToBottom = false
                    }
                }
                .iOS {
                    // Auto Scroll with Keyboard Notification
                    $0.onReceive(
                        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                            .debounce(for: .milliseconds(400), scheduler: RunLoop.main),
                        perform: { _ in
                            if !isKeyboardActive {
                                isKeyboardActive = true
                                //scrollToBottom = true
                            }
                        }
                    )
                    .onReceive(
                        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                        perform: { _ in isKeyboardActive = false }
                    )
                }
            }
            
        }
        .rotationEffect(.degrees(self.degreesToFlip))
        .background(Color.clear)
    }
    
    private func iOS14Fallback(in size: CGSize) -> some View {
        List(messages) { message in
            chatMessageCellContainer(in: size, with: message)
        }
        .onAppear {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
            // To remove all separators including the actual ones:
            UITableView.appearance().separatorStyle = .none
            
            // To clear background colors to allow library user set himself
            UITableView.appearance().backgroundColor = .clear
            UITableViewCell.appearance().backgroundColor = .clear
        }
    }
    
    // MARK: - List Item
    private func chatMessageCellContainer(in size: CGSize, with message: Message) -> some View {
        ChatMessageCellContainer(
            message: message,
            size: size,
            onQuickReplyItemSelected: onQuickReplyItemSelected,
            contactFooterSection: contactCellFooterSection,
            onTextTappedCallback: onAttributedTextTappedCallback,
            onCarouselItemAction: onCarouselItemAction,
            onQuestionItemSelected: onQuestionItemSelected
        )
        .onTapGesture { onMessageCellTapped(message) }
        .contextMenu(menuItems: { messageCellContextMenu(message) })
        .modifier(AvatarModifier<Message, User>(message: message))
        .modifier(MessageHorizontalSpaceModifier(messageKind: message.messageKind, isSender: message.isSender))
        .modifier(CellEdgeInsetsModifier(isSender: message.isSender))
        .id(message.id)
    }
    
}

// MARK: - Initializers
public extension ChatView {
    
    /// Initialize
    /// - Parameters:
    ///   - messages: Messages to display
    ///   - inputView: inputView view to provide message
    init(
        messages: Binding<[Message]>,
        inputView: @escaping () -> AnyView
    ) {
        _messages = messages
        self.inputView = inputView
        _scrollToBottom = .constant(false)
        _PageCount = .constant(1)
    }
    
    /// iOS 14 initializer, for supporting scrollToBottom
    /// - Parameters:
    ///   - messages: Messages to display
    ///   - scrollToBottom: set to `true` to scrollToBottom
    ///   - inputView: inputView view to provide message
    @available(iOS 14.0, *)
    init(
        messages: Binding<[Message]>,
        scrollToBottom: Binding<Bool>,
        pageCount: Binding<Int>,
        inputView: @escaping () -> AnyView
    ) {
        _messages = messages
        self.inputView = inputView
        _scrollToBottom = scrollToBottom
        _PageCount = pageCount
    }
    
}

public extension ChatView {
    
    /// Triggered when a ChatMessage is tapped.
    func onMessageCellTapped(_ action: @escaping (Message) -> Void) -> Self {
        then({ $0.onMessageCellTapped = action })
    }
    
    /// Present ContextMenu when a message cell is long pressed.
    func messageCellContextMenu(_ action: @escaping (Message) -> AnyView) -> Self {
        then({ $0.messageCellContextMenu = action })
    }
    
    /// Triggered when a quickReplyItem is selected (ChatMessageKind.quickReply)
    func onQuickReplyItemSelected(_ action: @escaping (QuickReplyItem) -> Void) -> Self {
        then({ $0.onQuickReplyItemSelected = action })
    }
    
    /// Present contactItem's footer buttons. (ChatMessageKind.contactItem)
    func contactItemButtons(_ section: @escaping (ContactItem, Message) -> [ContactCellButton]) -> Self {
        then({ $0.contactCellFooterSection = section })
    }
    
    /// To listen text tapped events like phone, url, date, address
    func onAttributedTextTappedCallback(action: @escaping () -> AttributedTextTappedCallback) -> Self {
        then({ $0.onAttributedTextTappedCallback = action })
    }
    
    /// Triggered when the carousel button tapped.
    func onCarouselItemAction(action: @escaping (CarouselItemButton, Message) -> Void) -> Self {
        then({ $0.onCarouselItemAction = action })
    }
    
    func onQuestionItemSelected(_ action: @escaping (Option, String) -> Void) -> Self {
        then({ $0.onQuestionItemSelected = action })
    }
   
}
