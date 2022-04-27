//
//  ImageCellStyle.swift
//  
//
//  Created by Enes Karaosman on 29.07.2020.
//

import SwiftUI

public struct ImageCellStyle: CommonViewStyle {
    
    public var cellWidth: (CGSize) -> CGFloat
    
    // MARK: - CellContainerStyles
    public let cellBackgroundColor: Color
    public let cellCornerRadius: CGFloat
    public let cellBorderColor: Color
    public let cellBorderWidth: CGFloat
    public let cellShadowRadius: CGFloat
    public let cellShadowColor: Color
    
    public init(
        cellWidth: @escaping (CGSize) -> CGFloat = { $0.width * (UIDevice.isLandscape ? 0.4 : 0.75) },
        cellBackgroundColor: Color = Color("pink"), //Color.secondary.opacity(0.1),
        cellCornerRadius: CGFloat = 8,
        cellBorderColor: Color = Color("pink"), //.clear,
        cellBorderWidth: CGFloat = 3,
        cellShadowRadius: CGFloat = 0,
        cellShadowColor: Color = .clear //.secondary
    ) {
        self.cellWidth = cellWidth
        self.cellBackgroundColor = cellBackgroundColor
        self.cellCornerRadius = cellCornerRadius
        self.cellBorderColor = cellBorderColor
        self.cellBorderWidth = cellBorderWidth
        self.cellShadowRadius = cellShadowRadius
        self.cellShadowColor = cellShadowColor
    }
    
}
