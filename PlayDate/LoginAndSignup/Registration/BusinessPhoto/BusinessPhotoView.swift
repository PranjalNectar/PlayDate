//
//  BusinessPhotoView.swift
//  PlayDate
//
//  Created by Pranjal on 20/07/21.
//

import SwiftUI
import ActivityIndicatorView
import SDWebImageSwiftUI
import Mantis

struct BusinessPhotoView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var comingFromEdit: Bool
    @State var showImagePicker: Bool = false
    @State var imgdata: Data?
    @State private var showLoadingIndicator = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @ObservedObject var UploadProfileImgVM: UploadImageViewModel = UploadImageViewModel()
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio:1)
    @State private var showingCropper = false
    @State var CropselectedImage: UIImage = UIImage()
    @State private var message = ""
    @State private var showAlert: Bool = false
    @State var isCancel = false
    @State var isSelectPerson: Bool = true
    @State var selectedImage: UIImage?
    @State var profilePicPath: String?
    @State private var Authenticate: Bool = false
    @State var isImageUpload: Bool?
    
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
                        Text("Business Photo")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text("Please upload a photo of your business")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16)
                
                if comingFromEdit == false{
                    ZStack{
                        ZStack{
                            Image("business_place")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: 300, height: 300)
                        .background(Color(hex: "D1D5DA"))
                        .cornerRadius(10)
                        .clipped()
                        
                        if selectedImage != nil{
                            Image(uiImage: self.CropselectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                                .background(Color(hex: "D1D5DA"))
                                .cornerRadius(10)
                                .clipped()
                        }
                    }
                }else {
                    WebImage(url: URL(string: profilePicPath ?? ""))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity).accentColor(Constants.AppColor.appPink)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .cornerRadius(10)
                        .clipped()
                }
                
                if self.isImageUpload == true {
                    VStack(spacing: 20.0){
                        RelationText(text: "CHANGE IMAGE")
                            .background(Constants.AppColor.appRegisterbg)
                            .onTapGesture {
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
                    }.padding()
                    .fullScreenCover(isPresented: $showImagePicker, content: {
                        SUImagePickerView(image: $selectedImage, isPresented: $showImagePicker)
                    })
                }
                
                Spacer()
                    VStack(alignment: .center){
                        NavigationLink(destination: BottomMenuView(), isActive: $Authenticate) {
                            Button(action: {
                               // self.Authenticate = true
                                self.uploadBusinessimage(imgData: self.CropselectedImage.jpegData(compressionQuality: 0.5)!)
                            }, label: {
                                NextArrow()
                            })
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
                                print("call after crop")
                            }
        })

        .onAppear{
            if self.selectedImage == nil{
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
            profilePicPath = "\(registerDefaultData?["businessPhoto"] ?? "")"
        }
        .onChange(of: selectedImage, perform: { value in
            if self.selectedImage != nil{
                self.CropselectedImage = self.selectedImage!
                self.showingCropper = true
            }
        })
    }
    
    func uploadBusinessimage(imgData : Data){
        UploadProfileImgVM.UploadBusinessImageService(imgData, check: "") { result, response,error  in
            if result == strResult.success.rawValue{
                self.isImageUpload = true
                let data = response?.value(forKey: "data") as! [String: Any]
                let profilePic =  data["businessImage"]
                var registerDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
                registerDefaultData?["businessPhoto"] = "\(EndPoints.BASE_URL_IMAGE.rawValue)\(profilePic ?? "")"
                self.profilePicPath = registerDefaultData?["businessPhoto"] as? String
                UserDefaults.standard.set(registerDefaultData, forKey: Constants.UserDefaults.loginData)
                UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                if comingFromEdit{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.presentation.wrappedValue.dismiss()
                    }
                }else {
                    self.Authenticate = true
                    UserDefaults.standard.set("dashboard", forKey:Constants.UserDefaults.controller)
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

struct BusinessPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessPhotoView( comingFromEdit: .constant(false))
    }
}
