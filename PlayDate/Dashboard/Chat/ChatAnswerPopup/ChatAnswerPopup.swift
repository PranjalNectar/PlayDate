//
//  ChatAnswerPopup.swift
//  PlayDate
//
//  Created by Pranjal on 06/07/21.
//

import SwiftUI

struct ChatAnswerPopup: View {
    @Environment(\.presentationMode) var presentation
    @State var getAnswer : QuestionAnswerModel?
    @State var headerlogo = "c_winner"
    @State var headertext = "Winner!"
    @State var subtext = "You answered first!"
    @State var points = "+ 0"
    @Binding var isClose : Bool
    
    var body: some View {
        ZStack{
            if getAnswer?.isRightAnswer == "Yes"{
                LottieView(name: .constant("blast"))
            }
            
            VStack(alignment:.center, spacing:40){
                HStack{
                    Spacer()
                    Image(systemName: "multiply.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding(.all, 5)
                        .onTapGesture {
                            self.isClose = false
                            //presentation.wrappedValue.dismiss()
                        }
                }
                
                ZStack{
                    Image(self.headerlogo)
                }
                Text(headertext)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.custom("Arial Rounded MT Bold", size: 40.0))
                    .multilineTextAlignment(.center)
                
                Text(self.subtext)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .font(.custom("Roboto", size: 20.0))
                
                VStack{
                    Text("Level 1")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Arial", size: 22.0))
                    
                    ZStack{
                        Image("pointsBG")
                        HStack{
                            Text(self.points)
                                .fontWeight(.bold)
                                .foregroundColor(Constants.AppColor.appPink)
                                .font(.custom("Arial", size: 18.0))
                                .padding()
                                .frame(height: 40)
                                .background(Color.white)
                                .cornerRadius(20)
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding([.leading,.trailing],30)
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.black).opacity(0.9))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            //print(getAnswer)
            if getAnswer?.isRightAnswer == "Yes"{
                if getAnswer?.answerOrder == 1{
                    self.headerlogo = "c_winner"
                    self.headertext = "Winner!"
                    self.subtext = "You answered first!"
                    self.points = "+ " + "\(getAnswer?.points ?? 0)"
                }else if getAnswer?.answerOrder == 2{
                    self.headerlogo = "c_notbad"
                    self.headertext = "Not Bad!"
                    self.subtext = "You answered second!"
                    self.points = "+ " + "\(getAnswer?.points ?? 0)"
                }
            }else if getAnswer?.isRightAnswer == "No"{
                self.headerlogo = "c_nicetry"
                self.headertext = "Nice Try!"
                self.subtext = "Your answer was wrong!"
                self.points = "0"
            }
        }
    }
}
