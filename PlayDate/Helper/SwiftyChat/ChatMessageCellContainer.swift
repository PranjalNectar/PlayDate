//
//  MessageCell.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

internal struct ChatMessageCellContainer<Message: ChatMessage>: View {
    
    public let message: Message
    public let size: CGSize
    
    public let onQuickReplyItemSelected: (QuickReplyItem) -> Void
    public let contactFooterSection: (ContactItem, Message) -> [ContactCellButton]
    public let onTextTappedCallback: () -> AttributedTextTappedCallback
    public let onCarouselItemAction: (CarouselItemButton, Message) -> Void
    public let onQuestionItemSelected: (Option, String) -> Void
    @ViewBuilder private func messageCell() -> some View {
        
        switch message.messageKind {
            
        case .text(let text):
            TextCell(
                text: text,
                message: message,
                size: size,
                callback: onTextTappedCallback
            )
            
        case .location(let location):
            LocationCell(
                location: location,
                message: message,
                size: size
            )
            
        case .image(let imageLoadingType):
            ImageCell(
                message: message,
                imageLoadingType: imageLoadingType,
                size: size
            )
            
        case .contact(let contact):
            ContactCell(
                contact: contact,
                message: message,
                size: size,
                footerSection: contactFooterSection
            )
            
        case .quickReply(let quickReplies):
            QuickReplyCell(
                quickReplies: quickReplies,
                quickReplySelected: onQuickReplyItemSelected
            )
            
        case .carousel(let carouselItems):
            CarouselCell(
                carouselItems: carouselItems,
                size: size,
                message: message,
                onCarouselItemAction: onCarouselItemAction
            )
            
        case .video(let videoItem):
            VideoPlaceholderCell(
                media: videoItem,
                message: message,
                size: size
            )
            
        case .voice(let voiceItem):
            VoiceCell(
                media: voiceItem,
                message: message,
                size: size
            )
        
        case .question(let questionItem):
            QuestionCell(message: message,
                         size: size,
                         answerSelected: onQuestionItemSelected,
                         question: questionItem
            )
        }
        
    }
    
    public var body: some View {
        messageCell()
    }
    
}
