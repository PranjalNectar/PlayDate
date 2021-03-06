//
//  MessageKind.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 18.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public enum ImageLoadingKind {
    case local(UIImage)
    case remote(URL)
}

public enum ChatMessageKind: CustomStringConvertible {
    
    /// A text message,
    /// supports emoji 👍🏻 (auto scales if text is all about emojis)
    case text(String)
    
    /// An image message, from local(UIImage) or remote(URL).
    case image(ImageLoadingKind)
    
    /// A location message, pins given location & presents on MapKit.
    case location(LocationItem)
    
    /// A contact message, generally for sharing purpose.
    case contact(ContactItem)
    
    /// Multiple options, disable itself after selection.
    case quickReply([QuickReplyItem])
    
    /// `CarouselItem` contains title, subtitle, image & button in a scrollable view
    case carousel([CarouselItem])
    
    /// A video message, opens the given URL.
    case video(VideoItem)
    
    case voice(VoiceItem)
    
    case question(QuestionItem)
    
    public var description: String {
        switch self {
        case .image(let imageLoadingType):
            switch imageLoadingType {
            case .local(let localImage):
                return "MessageKind.image(local: \(localImage))"
            case .remote(let remoteImageUrl):
                return "MessageKind.image(remote: \(remoteImageUrl))"
            }
        case .text(let text):
            return "MessageKind.text(\(text))"
        case .location(let location):
            return "MessageKind.location(lat: \(location.latitude), lon: \(location.longitude))"
        case .contact(let contact):
            return "MessageKind.contact(\(contact.displayName))"
        case .quickReply(let quickReplies):
            let options = quickReplies.map { $0.title }.joined(separator: ", ")
            return "MessageKind.quickReplies(options: \(options))"
        case .carousel(let carouselItems):
            return "MessageKind.carousel(itemCount: \(carouselItems.count))"
        case .video(let videoItem):
            return "MessageKind.video(url: \(videoItem.placeholderImage))"
        case .voice(let voiceItem):
            return "MessageKind.video(url: \(voiceItem.url))"
        case .question(let questionItem):
            return "MessageKind.video(url: \(questionItem.text))"
        }
    }
    
}
