//
//  SelectQuestionEmojiView.swift
//  PlayDate
//
//  Created by Pranjal on 02/06/21.
//

import SwiftUI
import ActivityIndicatorView

struct SelectQuestionEmojiView: View {
    @Environment(\.presentationMode) var presentation
    @State var isActive = false
    @State var SelectedColor = "D13A6F"
    @State var SelectedEmoji : Int?
    @State var txtQuestion = ""
    @State private var showAlert: Bool = false
    @State private var message = ""
    @ObservedObject var AddQuestionVM: AddQuestionViewModel = AddQuestionViewModel()
    @ObservedObject var lm = LocationManager()
    
    @State var intEmoji = [
                0x1F600, 0x1F603, 0x1F604, 0x1F601, 0x1F606, 0x1F605, 0x1F923, 0x1F602, 0x1F61A, 0x1F619,
                0x1F642, 0x1F643, 0x1F609, 0x1F60A, 0x1F607, 0x1F60B, 0x1F60D, 0x1F929, 0x1F618, 0x1F617,
                0x1F61C, 0x1F92A, 0x1F61D, 0x1F911, 0x1F917, 0x1F92B, 0x1F914, 0x1F910, 0x1F928, 0x1F610,
        ]
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        VStack{
                            HStack{
                                Button(action: { presentation.wrappedValue.dismiss() }) {
                                    Image("bback")
                                        .renderingMode(SharedPreferance.getAppDarkTheme() ? .template : .original)
                                        .foregroundColor(Constants.AppColor.appBlackWhite)
                                }
                                Spacer()
                                Image("PlayDateSmall")
                                Spacer()
                            }.padding()
                            HStack{
                                VStack(alignment : .leading, spacing : 10){
                                    Text("Anonymous Question")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 20.0))
                                    Text("Choose an emoji that best describes your question")
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 14.0))
                                }
                                Spacer()
                            }.padding([.leading, .bottom, .trailing])
                        }
                        Spacer()
                        VStack{
                            Spacer()
                            VStack{
                                VStack{
                                    Text(self.txtQuestion)
                                        .fontWeight(.bold)
                                        .font(.custom("Arial", size: 18.0))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                
                                VStack{
                                    Text(String(UnicodeScalar(self.SelectedEmoji ?? 0x0) ?? "-"))
                                        .font(.custom("Arial", size: 100.0))
                                    
                                }
                                .padding()
                            }
                            .padding(.top,5)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .padding(.bottom,5)
                            .frame(width: 350,height: 300, alignment: .center)
                            .background(Color(hex: self.SelectedColor))
                            .cornerRadius(20)
                            Spacer()
                            VStack{
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack{
                                        ForEach(self.intEmoji.indices){ i in
                                            Text(String(UnicodeScalar(self.intEmoji[i]) ?? "-"))
                                                
                                                .padding()
                                                .font(.custom("Arial", size: 60.0))
                                                .onTapGesture {
                                                    self.SelectedEmoji = self.intEmoji[i]
                                                }
                                        }
                                    }
                                    .frame( height: 100)
                                }
                                ////// emoji
                            }
                            .padding()
                            Spacer()
                        }
                        .padding()
                        
                        
                        VStack{
                            NavigationLink(destination: BottomMenuView(), isActive: $isActive) {
                                Button(action: {
                                    if self.SelectedEmoji != nil{
                                        self.PostQuestionService()
                                    }else{
                                        self.message = "Please select emoji!"
                                        self.showAlert = true
                                    }
                                }, label: {
                                    Image("arrow")
                                        .padding()
                                        .frame(width : 60,height: 60)
                                        .background(Constants.AppColor.appPink)
                                        .cornerRadius(30)
                                        .padding()
                                })
                            }
                        }

                    }
                    .padding()
                    Spacer()
                }
                .padding()
                
                
//                VStack{
//                    NavigationLink(destination: BottomMenuView(), isActive: $isActive) {
//                        Button(action: {
//                            if self.SelectedEmoji != nil{
//                                self.PostQuestionService()
//                            }
//
//                        }, label: {
//                            Image("arrow")
//                                .padding()
//                                .frame(width : 60,height: 60)
//                                .background(Constants.AppColor.appPink)
//                                .cornerRadius(30)
//                                .padding()
//                        })
//
//                    }
//
//                    .frame(width: geometry.size.width)
//                    .frame(minHeight: geometry.size.height)
//                }
                
                .frame(width: geometry.size.width)
               .frame(minHeight: geometry.size.height)
            }
            ActivityIndicatorView(isVisible: $AddQuestionVM.loading, type: .flickeringDots)
                .foregroundColor(Constants.AppColor.appPink)
                .frame(width: 50.0, height: 50.0)
            
        }
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .navigationBarHidden(true)
    }
    
    func PostQuestionService(){
        let location = lm.placemark?.country ?? "India"
        self.AddQuestionVM.AddPostQuestionService("Question", txtQuestion: self.txtQuestion, colorCode: self.SelectedColor, emojiCode: String(self.SelectedEmoji ?? 0),location : location, completion: { result, response,error in
            
            if result == strResult.success.rawValue{
                self.isActive = true
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
        })
    }
}
