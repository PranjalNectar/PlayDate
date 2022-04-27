//
//  QuestionColorView.swift
//  PlayDate
//
//  Created by Pranjal on 02/06/21.
//

import SwiftUI

struct QuestionColorView: View {
    @Environment(\.presentationMode) var presentation
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var arrColor : [String] = ["D13A6F","1D1375","C50AF2","65FF00",
                                      "000000","E6FF00","3AC7D1","D1763A",
                                      "3A3AD1","989798","117106","D13A3A"]
    
    @State var SelectedColor = "D13A6F"
    @State var txtQuestion = ""
    @State var isActive = false
    
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
                        //Image("threeDots")
                        
                    }.padding()
                    HStack{
                        VStack(alignment : .leading, spacing : 10){
                            Text("Anonymous Question")
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 20.0))
                            Text("Choose a background colour")
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 14.0))
                        }
                        Spacer()
                    }.padding([.leading, .bottom, .trailing])
                }
              Spacer()
                VStack{
                    
                    VStack{
                        //Spacer()
                            Text(self.txtQuestion)
                                .fontWeight(.bold)
                                .font(.custom("Arial", size: 18.0))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                        Spacer()
                    }
                    .padding(.top,5)
                    .padding(.leading,10)
                    .padding(.trailing,10)
                    .padding(.bottom,5)
                    .frame(width: 350,height: 300, alignment: .center)
                    .background(Color(hex: self.SelectedColor))
                    .cornerRadius(20)
                    Spacer()
                   
                        LazyVGrid(columns: columns, spacing : 20) {
                            ForEach(self.arrColor.indices){ i in
                                Button(action: {
                                    self.SelectedColor = self.arrColor[i]
                                }, label: {
                                    Text("")
                                        .frame(width: 50, height: 50)
                                    
                                })
                                .background(Color(hex: self.arrColor[i]))
                                .cornerRadius(8.0)
                            }
                        }
                   
                    .padding()
                    
                }
                
                
                VStack{
                    NavigationLink(destination: SelectQuestionEmojiView(SelectedColor: self.SelectedColor, txtQuestion: self.txtQuestion), isActive: $isActive) {
                        Button(action: {
                            self.isActive = true
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
            .frame(width: geometry.size.width)
            .frame(minHeight: geometry.size.height)
        }
    }
           
        }
        .navigationBarHidden(true)
    }
}

struct QuestionColorView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionColorView()
    }
}



