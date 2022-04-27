//
//  LabelDividerView.swift
//  PlayDateApp
//
//  Created by Pranjal Dudhe on 21/04/21.
//

import SwiftUI

struct LabelDividerView: View {
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .white) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
                .font(.custom("Helvetica Neue", size: 14.0))
            line
        }
    }
    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

struct LabelDividerView_Previews: PreviewProvider {
    static var previews: some View {
        LabelDividerView(label: "or")
    }
}
