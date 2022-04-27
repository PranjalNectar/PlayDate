//
//  UploadImage.swift
//  PlayDate
//
//  Created by Pranjal on 23/04/21.
//


import SwiftUI
import ActivityIndicatorView
import SDWebImageSwiftUI
import Mantis

struct UploadImage: View {
    @Environment(\.presentationMode) var presentation
    @Binding var comingFromEdit: Bool
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage? = UIImage()
    @State private var showLoadingIndicator = false
    @State private var Authenticate: Bool = false
    @State private var isBusinessAuthenticate: Bool = false
    @State var profilePicPath: String?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @ObservedObject var UploadProfileImgVM: UploadImageViewModel = UploadImageViewModel()
    @State var isImageUpload: Bool?
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio:1)
    @State private var showingCropper = false
    @State var CropselectedImage: UIImage = UIImage()
    @State private var message = ""
    @State private var showAlert: Bool = false
    @State var isCancel = false
    @State var isSelectPerson: Bool = true
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                HStack{
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                    }
                    Spacer()
                }
                HStack{
                    VStack(alignment : .leading ,spacing: 10.0){
                        Text(self.isSelectPerson ? "Profile Picture" : "Profile Logo")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text(self.isSelectPerson ? "Please upload a profile picture" : "Please upload a logo for your business")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16)
                
                if comingFromEdit == false{
                    ZStack{
                            Image("profileplaceholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75.0).stroke(Color.white, lineWidth: 1)
                                )
                                .scaledToFit()
                                .padding()
                        
                        if selectedImage != nil{
                            Image(uiImage: self.CropselectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 75.0).stroke(Color.white, lineWidth: 1)
                                )
                                .scaledToFit()
                                .padding()
                                .clipped()
                        }
                    }
                }else {
                    WebImage(url: URL(string: profilePicPath ?? ""))
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity).accentColor(Constants.AppColor.appPink)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 75.0).stroke(Color.white, lineWidth: 1)
                        )
                        .scaledToFit()
                        .padding()
                }
                
                if self.isImageUpload == true {
                    VStack(spacing: 20.0){
                        RelationText(text: "CHANGE IMAGE")
                            .background(Constants.AppColor.appRegisterbg)
                            .onTapGesture {
                                //                            self.shouldPresentImagePicker = true
                                //                            self.shouldPresentCamera = false
                                self.isImageUpload = false
                            }.cornerRadius(5.0)
                            .padding()
                    }
                }else {
                    //Spacer()
                    VStack(spacing: 20.0){
                        RelationText(text: "UPLOAD")
                            .background(Constants.AppColor.appRegisterbg)
                            .onTapGesture {
                                self.showImagePicker.toggle()
                                self.sourceType = .photoLibrary
                            }
                            .cornerRadius(5.0)
                        
                        OrText()
                        RelationText(text:"TAKE PHOTO")
                            .background( Constants.AppColor.appRegisterbg)
                            .onTapGesture {
                                self.showImagePicker.toggle()
                                self.sourceType = .camera
                            }
                            .cornerRadius(5.0)
                        
                    }.padding()
                    .fullScreenCover(isPresented: $showImagePicker, content: {
                        SUImagePickerView(sourceType: self.sourceType, image: $selectedImage, isPresented: $showImagePicker)
                       // ImagePicker(image: self.$selectedImage, imageData: $imgdata, fileName: $fileName, fileUrls: $fileUrls, isImageUpload: $isImageUpload, profilePicPath: $profilePicPath, sourceType: self.sourceType)
                    })
                }
                
                Spacer()
                
                
                if self.isImageUpload == true{
                    VStack(alignment: .center){
                        if self.isSelectPerson{
                            NavigationLink(destination: Interest( comingFromEdit: .constant(false)), isActive: $Authenticate) {
                                Button(action: {
                                     self.uploadimage(imgData: self.CropselectedImage.jpegData(compressionQuality: 0.5)!)
                                }, label: {
                                    NextArrow()
                                })
                            }
                        }else{
                            NavigationLink(destination: BusinessPhotoView( comingFromEdit: .constant(false)), isActive: $isBusinessAuthenticate) {
                                Button(action: {
                                    self.uploadimage(imgData: self.CropselectedImage.jpegData(compressionQuality: 0.5)!)
                                }, label: {
                                    NextArrow()
                                })
                            }
                        }
                        
                    }
                }
            }
            ActivityLoader(isToggle: $UploadProfileImgVM.loading)
        }
        .statusBar(style: .lightContent)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .background(BGImage())
        .navigationBarHidden(true)
        .popover(isPresented: $showingCropper, content: {
            ImageCropper(image: $CropselectedImage,
                                     cropShapeType: $cropShapeType,
                                     presetFixedRatioType: $presetFixedRatioType, isCancel: $isCancel)
                            .ignoresSafeArea()
                            .onDisappear{
                                if !isCancel{
                                    self.isImageUpload = true
                                }else{
                                    self.isImageUpload = false
                                    self.selectedImage = nil
                                }
                            }
        })

        .onAppear{
            if self.selectedImage == UIImage(){
                self.isImageUpload = false
            }else {
                self.isImageUpload = true
            }
            
            if SharedPreferance.getAppUserType() == UserType.Person.rawValue{
                self.isSelectPerson = true
            }else{
                self.isSelectPerson = false
            }
            
            let registerDefaultData = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
            profilePicPath = "\(registerDefaultData?["profilePicPath"] ?? "")"
        }
        .onChange(of: selectedImage, perform: { value in
            if self.selectedImage != nil{
                self.CropselectedImage = self.selectedImage!
                self.showingCropper = true
            }
        })

    }
    
    func uploadimage(imgData : Data){
        
        UploadProfileImgVM.UploadProfielImageService(imgData, check: "") { result, response,error  in
            
            //self.message = response?.message ?? ""
            if result == strResult.success.rawValue{
                self.isImageUpload = true
                let data = response?.value(forKey: "data") as! [String: Any]
                let profilePic =  data["profilePic"]
                let path = data["profilePicPath"] as? String
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["profilePic"] = profilePic
                registerDefaultData?["profilePicPath"] = "\(EndPoints.BASE_URL_IMAGE.rawValue)\(path ?? "")"
                self.profilePicPath = registerDefaultData?["profilePicPath"] as? String
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                
                //UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    if self.isSelectPerson{
                        self.Authenticate = true
                        UserDefaults.standard.set("ineterstList", forKey:Constants.UserDefaults.controller)
                    }else{
                        self.isBusinessAuthenticate = true
                        UserDefaults.standard.set("businessPhoto", forKey:Constants.UserDefaults.controller)
                    }
                }
                
            }else if result == strResult.error.rawValue{
               
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
}
