//
//  MessageCellStyle.swift
//  SwiftyChatbot
//
//  Created by Enes Karaosman on 19.05.2020.
//  Copyright © 2020 All rights reserved.
//

import SwiftUI

public final class ChatMessageCellStyle: ObservableObject {
    
    /// Incoming Text Style
    let incomingTextStyle: TextCellStyle
    
    /// Outgoing Text Style
    let outgoingTextStyle: TextCellStyle
    
    /// Cell container inset for incoming messages
    let incomingCellEdgeInsets: EdgeInsets
    
    /// Cell container inset for outgoing messages
    let outgoingCellEdgeInsets: EdgeInsets
    
    /// Contact Cell Style
    let contactCellStyle: ContactCellStyle
    
    /// Image Cell Style
    let imageCellStyle: ImageCellStyle
    
    /// Quick Reply Cell Style
    let quickReplyCellStyle: QuickReplyCellStyle
    
    /// Carousel Cell Style
    let carouselCellStyle: CarouselCellStyle
    
    /// Location Cell Style
    let locationCellStyle: LocationCellStyle
    
    /// Video Placeholder Cell Style
    let videoPlaceholderCellStyle: VideoPlaceholderCellStyle
    
    /// Incoming Avatar Style
    let incomingAvatarStyle: AvatarStyle
    
    /// Outgoing Avatar Style
    let outgoingAvatarStyle: AvatarStyle
    
    public init(
        incomingTextStyle: TextCellStyle = TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: Font.custom("Arial", size: 13),
                fontWeight: .medium
            ),
            cellBackgroundColor : Color("pink")
        ),
        outgoingTextStyle: TextCellStyle = TextCellStyle(
            textStyle: CommonTextStyle(
                textColor: .white,
                font: Font.custom("Arial", size: 13),
                fontWeight: .medium
            ),
            cellBackgroundColor : Color("appDarkGary")
        ),
        incomingCellEdgeInsets: EdgeInsets = EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15),
        outgoingCellEdgeInsets: EdgeInsets = EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15),
        contactCellStyle: ContactCellStyle = ContactCellStyle(),
        imageCellStyle: ImageCellStyle = ImageCellStyle(),
        quickReplyCellStyle: QuickReplyCellStyle = QuickReplyCellStyle(),
        carouselCellStyle: CarouselCellStyle = CarouselCellStyle(),
        locationCellStyle: LocationCellStyle = LocationCellStyle(),
        videoPlaceholderCellStyle: VideoPlaceholderCellStyle = VideoPlaceholderCellStyle(),
        incomingAvatarStyle: AvatarStyle = AvatarStyle(),
        outgoingAvatarStyle: AvatarStyle = AvatarStyle(
            //imageStyle: CommonImageStyle(imageSize: .zero)
        )
    ) {
        self.incomingTextStyle = incomingTextStyle
        self.outgoingTextStyle = outgoingTextStyle
        self.incomingCellEdgeInsets = incomingCellEdgeInsets
        self.outgoingCellEdgeInsets = outgoingCellEdgeInsets
        self.contactCellStyle = contactCellStyle
        self.imageCellStyle = imageCellStyle
        self.quickReplyCellStyle = quickReplyCellStyle
        self.carouselCellStyle = carouselCellStyle
        self.locationCellStyle = locationCellStyle
        self.videoPlaceholderCellStyle = videoPlaceholderCellStyle
        self.incomingAvatarStyle = incomingAvatarStyle
        self.outgoingAvatarStyle = outgoingAvatarStyle
        
        objectWillChange.send()
    }
    
}
