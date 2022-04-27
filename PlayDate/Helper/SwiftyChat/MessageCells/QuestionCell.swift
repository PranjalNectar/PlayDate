//
//  QuestionCell.swift
//  PlayDate
//
//  Created by Pranjal on 06/07/21.
//

import Foundation
import SwiftUI

internal struct QuestionCell<Message: ChatMessage>: View {
   
    public let message: Message
    public let size: CGSize
    public var answerSelected: (Option, String) -> Void
    public let question: QuestionItem
    @State private var selectedIndex: Int?
    @EnvironmentObject var style: ChatMessageCellStyle
    @State private var isDisabled = false
    private var cellStyle: TextCellStyle {
        message.isSender ? style.outgoingTextStyle : style.incomingTextStyle
    }
    
    private func itemBackground(for index: Int) -> some View {
        let backgroundColor: Color = (index == selectedIndex ? Color("appDarkGary") : Color("pink"))
        return backgroundColor.cornerRadius(20)
    }
    
    public var body: some View {
        VStack{
            Text(message.date.chatFormate())
                .font(Font.custom("Arial", size: 9))
                .foregroundColor(.black)
            ZStack(alignment : .bottom){
                VStack{
                    Text(question.text)
                        .fontWeight(.regular)
                        .font(Font.custom("Arial", size: 13))
                        //.modifier(EmojiModifier(text: text, defaultFont: cellStyle.textStyle.font))
                        .lineLimit(nil)
                        .foregroundColor(cellStyle.textStyle.textColor)
                        .padding(cellStyle.textPadding)
                        .padding(.bottom, 16)
                        .background(Color.init(hex: "0066EC"))
                        .clipShape(RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
                                .stroke(
                                    cellStyle.cellBorderColor,
                                    lineWidth: cellStyle.cellBorderWidth
                                )
                                .shadow(
                                    color: cellStyle.cellShadowColor,
                                    radius: cellStyle.cellShadowRadius
                                )
                        )
                        .padding(3)
                        .overlay(
                            RoundedRectangle(cornerRadius: cellStyle.cellCornerRadius)
                                .stroke(
                                    Color.init(hex: "0066EC"),
                                    lineWidth:2
                                )
                        )
                    
                    HStack(alignment : .center){
                        ForEach(0..<question.options.count) { idx in
                            Button(action: {}) {
                                Text(question.options[idx].option ?? "")
                                    .fontWeight(.regular)
                                    .font(Font.custom("Arial", size: 13))
                                    .padding(8)
                                    //.frame(height: cellStyle.itemHeight)
                                    .background(itemBackground(for: idx))
                                    .foregroundColor(Color(.white))
                                
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded { _ in
                                    selectedIndex = idx
                                    isDisabled = true
                                    answerSelected(question.options[idx], question.questionID)
                                }
                            )
                            
                        }
                    }
                    .padding(.horizontal, 5)
                    .offset(y : -25)
                }
                
            }
            .disabled(isDisabled)
        }
    }
    
}


public protocol QuestionItem {
    var text: String { get }
    var questionID: String { get }
    var options: [Option] { get }
}
