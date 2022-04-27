//
//  CropImage.swift
//  PlayDate
//
//  Created by Pranjal on 08/06/21.
//

import Foundation
import Mantis
import SwiftUI


struct ImageCropper: UIViewControllerRepresentable {
    @Binding var image: UIImage
    @Binding var cropShapeType: Mantis.CropShapeType
    @Binding var presetFixedRatioType: Mantis.PresetFixedRatioType
    @Binding var isCancel: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(_ parent: ImageCropper) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            parent.image = cropped
            print("transformation is \(transformation)")
            parent.isCancel = false
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            parent.isCancel = true
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        }
        
        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.cropShapeType = cropShapeType
        config.presetFixedRatioType = presetFixedRatioType
        let cropViewController = Mantis.cropViewController(image: image,
                                                           config: config)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
        
    }
}
