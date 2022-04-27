//
//  BasicInputView.swift
//  
//
//  Created by Enes Karaosman on 19.10.2020.
//

import SwiftUI

public struct BasicInputView: View {
    
    @Binding private var message: String
    @Binding private var isEditing: Bool
    @Binding private var isPlus: Bool
    @Binding private var isCamera: Bool
    @Binding private var isGallery: Bool
    @Binding private var isVoice: Bool
    private let placeholder: String

    @Binding var sourceType: UIImagePickerController.SourceType?
    
    @State private var contentSizeThatFits: CGSize = .zero

    private var internalAttributedMessage: Binding<NSAttributedString> {
        Binding<NSAttributedString>(
            get: {
                NSAttributedString(
                    string: self.message,
                    attributes: [
                        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                        NSAttributedString.Key.foregroundColor: UIColor.label,
                    ]
                )
            },
            set: { self.message = $0.string }
        )
    }

    private var onCommit: ((ChatMessageKind) -> Void)?
    
    public init(
        message: Binding<String>,
        isEditing: Binding<Bool>,
        isPlus: Binding<Bool>,
        isCamera: Binding<Bool>,
        isGallery: Binding<Bool>,
        isVoice: Binding<Bool>,
        placeholder: String = "",
        sourceType : Binding<UIImagePickerController.SourceType?>,
        onCommit: @escaping (ChatMessageKind) -> Void
    ) {
        self._message = message
        self.placeholder = placeholder
        self._isEditing = isEditing
        self._isPlus = isPlus
        self._isCamera = isCamera
        self._isGallery = isGallery
        self._isVoice = isVoice
        self._sourceType = sourceType
        self._contentSizeThatFits = State(initialValue: .zero)
        self.onCommit = onCommit
    }

    private var messageEditorHeight: CGFloat {
        min(
            self.contentSizeThatFits.height,
            0.25 * UIScreen.main.bounds.height
        )
    }

    private var messageEditorView: some View {
        MultilineTextField(
            attributedText: self.internalAttributedMessage,
            placeholder: placeholder,
            isEditing: self.$isEditing
        )
        
        .onPreferenceChange(ContentSizeThatFitsKey.self) {
            self.contentSizeThatFits = $0
        }
        .frame(height: self.messageEditorHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Constants.AppColor.appPink, lineWidth: 3)
        )
    }

    private var sendButton: some View {
        Button(action: {
            message = message.trimmingCharacters(in: .whitespacesAndNewlines)
            self.onCommit?(.text(message))
            self.message.removeAll()
        }, label: {
            Circle().fill(Constants.AppColor.appPink)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .offset(x: -1, y: 1)
                        .padding(8)
                )
        })
        .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    private var PlusButton: some View {
        Button(action: {
            self.isPlus.toggle()
        }, label: {
            Image("c_plus")
        })
    }
    
    private var CameraButton: some View {
        Button(action: {
            self.sourceType = .camera
            self.isCamera = true
        }, label: {
            Image("c_camera")
        })
    }
    
    private var GalleryButton: some View {
        Button(action: {
            self.sourceType = .photoLibrary
            self.isGallery = true
        }, label: {
            Image("c_gallery")
        })
    }
    
    private var VoiceButton: some View {
        Button(action: {
            self.isVoice = true
        }, label: {
            Image("c_voice")
        })
    }

    
    public var body: some View {
        VStack {
            Divider()
            HStack {
                self.PlusButton
                    .padding(5)
                self.CameraButton
                    .padding(5)
                self.GalleryButton
                    .padding(5)
                self.VoiceButton
                    .padding(5)
                self.messageEditorView
                self.sendButton
            }
        }
    }
    
}
