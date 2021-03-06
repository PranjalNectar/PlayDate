//
//  AttributedTextStyle.swift
//  
//
//  Created by Enes Karaosman on 13.08.2020.
//

import UIKit

public struct AttributedTextStyle {
 
    public let textColor: UIColor
    public let font: UIFont
    public let fontWeight: UIFont.Weight
    
    public init(
        textColor: UIColor = .white,
        font: UIFont = .monospacedSystemFont(ofSize: 13, weight: .semibold),
        fontWeight: UIFont.Weight = .semibold
    ) {
        self.textColor = textColor
        self.font = font
        self.fontWeight = fontWeight
    }
}
