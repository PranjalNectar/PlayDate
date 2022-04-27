//
//  CouponGeneratorView.swift
//  PlayDate
//
//  Created by Pranjal on 21/07/21.
//

import SwiftUI
import Mantis
import SDWebImageSwiftUI
struct CouponGeneratorView: View {
    
    @State var txtCouponTitle = ""
    @State var txtPercentOff = ""
    @State var txtAvailability = ""
    @State var txtAmoutOff = ""
    @State var txtNewPrice = ""
    @State var txtFreeItem = ""
    @State var txtPointValue = ""
    @State var txtAwardedBy = ""
    @State var lblLevelCount = "1"
    @State var LevelCount = 1
    @State var isLevelpopupShow: Bool = false
    @State var showAwarded = false
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    @State var showsDatePicker = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio:2.3)
    @State private var showingCropper = false
    @State var CropselectedImage: UIImage = UIImage()
    @State var editselectedImage: UIImage = UIImage()
    @State var isCancel = false
    @State var isImageUpload = false
    @State private var date = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //formatter.dateStyle = .long
        return formatter
    }()
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject var BusinessCouponVM = BusinessCouponViewModel()
    @State var CouponData : BusinessCoupopnData?
    @Binding var comingFromEdit: Bool
    @State var imgdata : Data = Data()
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                ScrollView(showsIndicators: false){
                    VStack{
                        VStack(){
                            HStack{
                                BackButton()
                                Spacer()
                            }
                            VStack{
                                Text("Coupon Generator")
                                    .font(.custom("Arial Rounded MT Bold", size: 24.0))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Image("c_logo")
                                //.padding(.bottom, 20)
                            }
                        }
                        .frame(height:320)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.init(hex: "7B0063"),Color.init(hex: "D13A6F") ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(radius: 45, corners: [.bottomLeft, .bottomRight])
                        
                        VStack(alignment : .leading) {
                            Text("COUPON DETAILS")
                                .fontWeight(.medium)
                                .foregroundColor(Constants.AppColor.appBlackWhite)
                                .font(.custom("Arial", size: 16.0))
                                .padding(.vertical)
                            
                            VStack{
                                if comingFromEdit{
                                    WebImage(url: URL(string: CouponData?.couponImage ?? ""))
                                        .resizable()
                                        .placeholder {
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .indicator(.activity)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height : 120)
                                        .clipped()
                                }else{
                                    if self.isImageUpload{
                                        Image(uiImage: self.CropselectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height : 120)
                                            .clipped()
                                        
                                    }else{
                                        Image("cb_camera")
                                        Text("Add Image")
                                    }
                                }
                            }
                            .frame(height : 120)
                            .frame(maxWidth:.infinity)
                            .background(Color(hex: "DBDBDB"))
                            .onTapGesture {
                                self.showImagePicker = true
                            }
                            .fullScreenCover(isPresented: $showImagePicker, content: {
                                SUImagePickerView(image: $selectedImage, isPresented: $showImagePicker)
                            })
                            
                            GeneratorTextFieldView(txtplaceHolder: "Coupon Title", txtTitle: $txtCouponTitle, imgIcon: "c_title")
                            
                            GeneratorTextFieldView(txtplaceHolder: "Percentage Off", txtTitle: $txtPercentOff, imgIcon: "c_percent")
                                .keyboardType(.decimalPad)
                            
                            VStack(spacing:5){
                                HStack{
                                    Image("c_cal")
                                    DatePicker(selection: $date, in: Date()..., displayedComponents: .date){
                                       // self.txtAvailability = "\(date, formatter: dateFormatter)"
                                       Text("\(date, formatter: dateFormatter)" )
                                    }
                                    .accentColor(Constants.AppColor.appPink)
                                    .onDisappear{
                                        self.txtAvailability = self.date.toString(dateFormat: "YYYY-mm-dd")
                                    }
                                        //.datePickerStyle(GraphicalDatePickerStyle())
                                        //.frame(maxHeight: 400)
                                }
                                Text("")
                                    .frame(height:1)
                                    .frame(maxWidth:.infinity)
                                    .background(Color.gray)
                            }
                            .padding(.vertical, 8)
                          
                            GeneratorTextFieldView(txtplaceHolder: "Amount Off", txtTitle: $txtAmoutOff, imgIcon: "c_dollor")
                                .keyboardType(.decimalPad)
                            
                            GeneratorTextFieldView(txtplaceHolder: "New Price", txtTitle: $txtNewPrice, imgIcon: "c_price")
                                .keyboardType(.decimalPad)
                            
                            GeneratorTextFieldView(txtplaceHolder: "Free Item", txtTitle: $txtFreeItem, imgIcon: "c_gift")
                            
                            GeneratorTextFieldView(txtplaceHolder: "Points Value", txtTitle: $txtPointValue, imgIcon: "c_point")
                                .keyboardType(.decimalPad)
                            
                            Button(action: {
                                self.showAwarded.toggle()
                            }, label: {
                                VStack(spacing:5){
                                    
                                    HStack{
                                        Image("c_console")
                                        
                                        ZStack(alignment: .leading) {
                                            if txtAwardedBy.isEmpty { Text("Awarded By")
                                                .foregroundColor(.gray)
                                                .font(.custom("Arial", size: 16.0))
                                            }
                                            
                                            Text(self.txtAwardedBy)
                                                .foregroundColor(.black)
                                                .font(.custom("Arial", size: 16.0))
                                        }
                                        Spacer()
                                        
                                        Image(self.showAwarded ? "c_up" : "c_down")
                                            .padding(.horizontal)
                                    }
                                    Text("")
                                        .frame(height:1)
                                        .frame(maxWidth:.infinity)
                                        .background(Color.gray)
                                }
                                .padding(.vertical, 8)
                            })
                            
                        }
                        .padding(.horizontal, 20)
                        
                        if self.showAwarded{
                            VStack(alignment : .leading){
                                HStack{
                                    Text("Level")
                                        .font(.custom("Arial", size: 16.0))
                                        .foregroundColor(Color.black)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .onTapGesture {
                                            self.txtAwardedBy = "Level"
                                            self.isLevelpopupShow = true
                                        }
                                    Spacer()
                                }
                                
                                Text("Game Winner")
                                    .font(.custom("Arial", size: 16.0))
                                    .foregroundColor(Color.black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .onTapGesture {
                                        self.txtAwardedBy = "Game Winner"
                                    }
                                
                                Text("Game Loser")
                                    .font(.custom("Arial", size: 16.0))
                                    .foregroundColor(Color.black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .onTapGesture {
                                        self.txtAwardedBy = "Game Loser"
                                    }
                            }
                            .frame(height : 100)
                            .frame(maxWidth:.infinity)
                            .background(Color(hex: "DBDBDB"))
                            .padding(.horizontal, 20)
                        }
                        
                        Button(action: {
                            self.checkValidationAndCallService()
                        }, label: {
                            Text("Create Coupon")
                                .padding()
                                .foregroundColor(.white)
                                .background(Constants.AppColor.appPink)
                                .frame(height: 50)
                                .clipShape(Capsule())
                            
                        })
                        .padding()
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
                 
            if isLevelpopupShow{
                LevelPopupView
            }
            ActivityLoader(isToggle: $BusinessCouponVM.loading)
        }
        .KeyboardAwarePadding()
        .dismissKeyboardOnTappingOutside()
        .statusBar(style: .lightContent)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
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
        .onChange(of: selectedImage, perform: { value in
            if self.selectedImage != nil{
                self.CropselectedImage = self.selectedImage!
                self.showingCropper = true
            }
        })
        .onAppear{
            if comingFromEdit{
                self.txtCouponTitle = CouponData?.couponTitle ?? ""
                self.txtPercentOff = "\(CouponData?.couponPercentageValue ?? 0)"
                self.txtAvailability = CouponData?.couponValidTillDate ?? ""
                self.txtAmoutOff = CouponData?.couponAmountOf ?? ""
                self.txtNewPrice = CouponData?.newPrice ?? ""
                self.txtFreeItem = CouponData?.freeItem ?? ""
                self.txtPointValue = "\(CouponData?.couponPurchasePoint ?? 0)"
                self.txtAwardedBy = CouponData?.awardedBy ?? ""
                
                CommunicationManager().downloadImage(fromURL: URL(string: CouponData?.couponImage ?? "")!) { (res) in
                    self.imgdata = res as! Data
                }
            }
        }
    }
    
    func checkValidationAndCallService(){
        if comingFromEdit{
       
        }else{
            if !self.isImageUpload {
                self.message = MessageString().BSCImage
                self.showAlert = true
                return
            }
        }
        if txtCouponTitle.isEmpty{
            self.message = MessageString().BSCTitle
            self.showAlert = true
            return
        }
        if txtPercentOff.isEmpty{
            self.message = MessageString().BSCPercentage
            self.showAlert = true
            return
        }
        if txtAmoutOff.isEmpty{
            self.message = MessageString().BSCAmountOff
            self.showAlert = true
            return
        }
        if txtNewPrice.isEmpty{
            self.message = MessageString().BSCNewPrice
            self.showAlert = true
            return
        }
        if txtFreeItem.isEmpty{
            self.message = MessageString().BSCFreeItem
            self.showAlert = true
            return
        }
        if txtPointValue.isEmpty{
            self.message = MessageString().BSCPointsValue
            self.showAlert = true
            return
        }
        if txtAwardedBy.isEmpty{
            self.message = MessageString().BSCAwardedBy
            self.showAlert = true
            return
        }
        
        self.txtAvailability = self.date.toString(dateFormat: "YYYY-MM-dd")
        
        var urlparam = ""
        if comingFromEdit{
            urlparam = "?couponTitle=\(self.txtCouponTitle)&couponValidTillDate=\(self.txtAvailability)&couponAmountOf=\(self.txtAmoutOff)&couponPercentageValue=\(self.txtPercentOff)&freeItem=\(self.txtFreeItem)&newPrice=\(self.txtNewPrice)&awardedBy=\(self.txtAwardedBy)&couponPurchasePoint=\(self.txtPointValue)&awardlevelValue=\(self.lblLevelCount)&userId=\(UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "")&couponId=\(CouponData?.couponId ?? "")"
            
            if isImageUpload{
                let imgdata = self.CropselectedImage.jpegData(compressionQuality: 0.5)!
                let urlStringstr = urlparam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.UpdateCouponService(urlparams:urlStringstr ?? "" , img: imgdata)
            }else{
                //let imgdata = self.editselectedImage.jpegData(compressionQuality: 0.5)
                let urlStringstr = urlparam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                self.UpdateCouponService(urlparams:urlStringstr ?? "" , img: self.imgdata)
            }
        }else{
            urlparam = "?couponTitle=\(self.txtCouponTitle)&couponValidTillDate=\(self.txtAvailability)&couponAmountOf=\(self.txtAmoutOff)&couponPercentageValue=\(self.txtPercentOff)&freeItem=\(self.txtFreeItem)&newPrice=\(self.txtNewPrice)&awardedBy=\(self.txtAwardedBy)&couponPurchasePoint=\(self.txtPointValue)&awardlevelValue=\(self.lblLevelCount)&userId=\(UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "")"
            guard let imgdata = self.CropselectedImage.jpegData(compressionQuality: 0.5) else { return  }
            let urlStringstr = urlparam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.CreateCouponService(urlparams:urlStringstr ?? "" , img: imgdata)
        }
        
    }

    func CreateCouponService(urlparams : String, img : Data){
        BusinessCouponVM.CreateCouponService(urlparams, imgData: img, check: "") { result, response,error  in
            
            if result == strResult.success.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
    
    func UpdateCouponService(urlparams : String, img : Data){
        BusinessCouponVM.UpdateCouponService(urlparams, imgData: img, check: "") { result, response,error  in
            
            if result == strResult.success.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
            }else if result == strResult.error.rawValue{
                self.message = response?.message ?? ""
                self.showAlert = true
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


struct GeneratorTextFieldView: View {
    @State var txtplaceHolder = ""
    @Binding var txtTitle : String
    @State var imgIcon = ""
    
    var body: some View {
        VStack(spacing:5){
            HStack{
                Image(imgIcon)
                
                ZStack(alignment: .leading) {
                    if txtTitle.isEmpty { Text(txtplaceHolder)
                        .foregroundColor(.gray)
                        .font(.custom("Arial", size: 16.0))
                    }
                    TextField("", text: $txtTitle)
                        .foregroundColor(Color.black)
                        .accentColor(.black)
                        .font(.custom("Arial", size: 16.0))
                }
            }
           Text("")
                .frame(height:1)
                .frame(maxWidth:.infinity)
                .background(Color.gray)
        }
        .padding(.vertical, 8)
    }
}
