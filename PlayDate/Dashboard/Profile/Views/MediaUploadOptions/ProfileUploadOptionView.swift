//
//  ProfileUploadOptionView.swift
//  PlayDate
//
//  Created by Pranjal on 28/05/21.
//

import SwiftUI
import SDWebImageSwiftUI
import ActivityIndicatorView
import Mantis

struct GalleryOptionView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var selectedVideo: String?
    @State private var isImagePickerDisplay = false
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @State var sectiontype = "feed"
    @State var mediatype = "feed"
    @State var isImageSelected = false
    @State var isVideoSelected = false
    @State var mediaid : String = ""
    
    @Binding var sendImage: UIImage?
    @State private var CropImage: UIImage = UIImage()
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    @State private var CropselectedImage: UIImage = UIImage()
    var plusview : PlusOptionView?
    
    var body: some View {
        HStack{
            GalleryOptionImageView(imgName: "ucamera", txtName: "Take Photo")
                .onTapGesture {
                    self.mediatype = "image"
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }
            Spacer()
            GalleryOptionImageView(imgName: "ugallery", txtName: "Upload Photo")
                .onTapGesture {
                    self.mediatype = "image"
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                    self.plusview?.isGalleryOptionShow = false
                }
            Spacer()
            
            GalleryOptionImageView(imgName: "urecord", txtName: "Record Video")
                .onTapGesture {
                    self.mediatype = "video"
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                    //self.isVideoSelected = true
                }
            
            Spacer()
            
            GalleryOptionImageView(imgName: "uvideo", txtName: "Upload Video")
                .onTapGesture {
                    self.mediatype = "video"
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                    self.plusview?.isGalleryOptionShow = false
                }
            
            NavigationLink(destination: UploadFeedView(image: self.CropselectedImage, mediaid: self.mediaid, mediatype:"image"), isActive: $isImageSelected) {
                
            }
            
            NavigationLink(destination: UploadFeedView(image: selectedImage ?? UIImage(), mediaid: mediaid, mediatype:mediatype), isActive: $isVideoSelected) {
                
            }
            
        }
        
        .padding([.all], 10)
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, selectedVideo: $selectedVideo, mediaType: self.mediatype, sourceType: self.sourceType)
        }
        
        .onChange(of: self.selectedImage, perform: { value in
            if self.selectedImage != nil{
                if self.mediatype == "image"{
                    self.sendImage = self.selectedImage!
                }else{
                    self.AddMediaService()
                }
            }
        })
        .onAppear{
            UserDefaults.standard.set(nil, forKey:"tagUserids")
            UserDefaults.standard.set(nil, forKey:"tagUsername")
        }
    }
    
    func AddMediaService(){
        var data = Data()
        if self.mediatype == "image"{
            data = self.selectedImage?.jpegData(compressionQuality: 0.5) ?? Data()
        }else{
            do{
                let videoFilename = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + "feedvideo.mp4"
                data = try Data(contentsOf:URL.init(fileURLWithPath: videoFilename), options: [])
            }catch{
                print(error)
            }
        }
        
        ProfileVM.AddMediaService(self.sectiontype, mediatype: self.mediatype, imgData: data, check: "") { result, response,error  in
            
            if result == strResult.success.rawValue{
                self.mediaid = response?.data?.mediaId ?? ""
                if self.mediatype == "image"{
                    self.isImageSelected = true
                }else{
                    self.isVideoSelected = true
                }
            }else if result == strResult.error.rawValue{
//                self.message = response?.message ?? ""
//                self.showAlert = true
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
            
        }
    }
}

struct GalleryOptionImageView: View {
    @State var imgName = ""
    @State var txtName = ""
    var body: some View {
        VStack{
            Image(imgName)
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
                
            Text(txtName)
                .foregroundColor(.white)
                .font(.custom("Arial", size: 13.0))
        }
    }
}


struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideo: String?
    @State var imgselected = false
    @Environment(\.presentationMode) var isPresented
    @State var mediaType : String
    var sourceType: UIImagePickerController.SourceType
    //var mediaType = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        if self.mediaType == "video"{
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
            imagePicker.mediaTypes = ["public.movie"]
            self.selectedImage = nil
        }
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.picker.mediaType == "image"{
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.isPresented.wrappedValue.dismiss()
            self.picker.selectedImage = selectedImage
            
        }else{
            guard let selectedVideo = info[.mediaURL] as? URL else  { return }
            print(selectedVideo)
            self.picker.selectedVideo = "\(selectedVideo)"
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let path = documentsDirectoryURL.appendingPathComponent("feedvideo.mp4")
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
                } catch {
                    print(error)
                }
            }
            self.picker.selectedImage = UIImage(imageLiteralResourceName: "profile")
            self.picker.isPresented.wrappedValue.dismiss()
        }
        
    }
}
