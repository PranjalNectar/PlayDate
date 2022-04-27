//
//  SwiftUIView.swift
//  
//
//  Created by Enes Karaosman on 10.12.2020.
//

import SwiftUI
import UIKit
/**
 Usage;
 
 struct ImagePickerExampleView: View {

     @State var showImagePicker: Bool = false
     @State var image: UIImage?

     var body: some View {
         VStack {
             if let image = image {
                 Image(uiImage: image)
                     .resizable()
                     .aspectRatio(contentMode: .fit)
             }
             Button("Pick image") {
                 self.showImagePicker.toggle()
             }
         }
         .sheet(isPresented: $showImagePicker) {
             ImagePickerView(sourceType: .photoLibrary) { image in
                 self.image = image
             }
         }
     }
 }
 */

enum MediaType : String{
    case image
    case video
    case audio
}

//#if canImport(UIKit)
public struct CommonImagePickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage?) -> Void
    @Binding var mediaType: String
    //private let mediaType: String
    @Environment(\.presentationMode) private var presentationMode

    public init(sourceType: UIImagePickerController.SourceType, mediaType : Binding<String>, onImagePicked: @escaping (UIImage?) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
        self._mediaType = mediaType
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: self.sourceType) ?? []
        picker.mediaTypes = ["public.image","public.movie"]
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            mediaType: $mediaType,
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage?) -> Void
       // private let mediaType: String
        @Binding var mediaType: String

        init(onDismiss: @escaping () -> Void,mediaType:Binding<String>, onImagePicked: @escaping (UIImage?) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
            self._mediaType = mediaType
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let mediaType = info[.mediaType] as? String {
                
                if mediaType == "public.image"{
                    if let image = info[.originalImage] as? UIImage {
                        self.mediaType = MediaType.image.rawValue
                        self.onImagePicked(image)
                    }
                }
                
                if mediaType == "public.movie" {
                    if let selectedVideo = info[.mediaURL] as? URL {
                        self.mediaType = MediaType.video.rawValue
                        print(selectedVideo)
                        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let path = documentsDirectoryURL.appendingPathComponent("chatvideo.mp4")
                        let strpath = path.path
                        if FileManager.default.fileExists(atPath: strpath ) {
                            do {
                                try FileManager.default.removeItem(at: path)
                            }
                            catch let error {
                                print(error)
                            }
                        }
                        
                        if let url = info[.mediaURL] as? URL {
                            do {
                                try FileManager.default.moveItem(at: url, to: path)
                                print("movie saved")
                                self.onImagePicked(nil)
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                }
                
            }
             
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

    }

}
//#endif
