//
//  AddQuestionView.swift
//  PlayDate
//
//  Created by Pranjal on 02/06/21.
//

import SwiftUI


struct AddQuestionView: View {
    @State var txtQuestion = ""
    @State private var showAlert: Bool = false
    @State private var message = ""
    @Environment(\.presentationMode) var presentation
    @State var isActive = false
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                ScrollView{
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
                            Image("threeDots")
                        }.padding()
                        HStack{
                            VStack(alignment : .leading, spacing : 10){
                                Text("Anonymous Question")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 20.0))
                                Text("Add an anonymous question and receive responses")
                                    .fontWeight(.bold)
                                    .font(.custom("Arial", size: 14.0))
                            }
                            Spacer()
                        }.padding([.leading, .bottom, .trailing])
                        
                        Spacer()
                        VStack{
                            HStack{
                                ZStack(alignment: .leading) {
                                    if self.txtQuestion.isEmpty { Text("Add a question...").foregroundColor(.gray) }
                                    TextField("", text: $txtQuestion)
                                        .font(.custom("Arial", size: 18.0))
                                        .foregroundColor(.white)
                                        .accentColor(.white)
                                    
                                }
                                Spacer()
                                
                                NavigationLink(destination: QuestionColorView(txtQuestion : self.txtQuestion), isActive: $isActive) {
                                    Button(action: {
                                        self.isActive = true
                                        
                                        if !self.txtQuestion.isEmpty{
                                            
                                        }
                                    }, label: {
                                        Text("Post")
                                            .padding()
                                            .foregroundColor(.white)
                                    })
                                    // .disabled(self.txtQuestion.isEmpty ? true : false)
                                }
                                
                            }
                        }
                        .padding()
                        .background(Constants.AppColor.appDarkGary)
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear{
         
        }
    }
}

struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
    }
}



