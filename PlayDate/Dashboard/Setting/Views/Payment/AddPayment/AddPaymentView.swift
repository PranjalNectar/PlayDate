//
//  AddPaymentView.swift
//  PlayDate
//
//  Created by Pranjal on 29/04/21.
//

import SwiftUI

struct AddPaymentView: View {
    @State var txtCardNumber: String = ""
    @State var txtCardName: String = ""
    @State var txtCardMM: String = ""
    @State var txtCardYYYY: String = ""
    @State var txtCardCvv: String = ""
    @Binding var isAddPayment: Bool
    
    var body: some View {
        VStack(alignment : .center, spacing : 30){
            HStack{
                Image("visa")
                Spacer()
                Image("right")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Constants.AppColor.appPink, lineWidth: 2)
                    )
                    
            }.padding()
            .frame(width: UIScreen.main.bounds.width - 40,height: 80, alignment: .center)
            .border(Constants.AppColor.appPink, width: 2)
            
            
            Text("Scan Card")
                .padding()
                .foregroundColor(.white)
                .background(Constants.AppColor.appPink)
                .clipShape(Capsule())
            
            Text("or")
            
            
            VStack(spacing : 20){
                CardView2(txtPlaceHolder: "CARD NUMBER", txtValue: txtCardNumber)
                
                CardView2(txtPlaceHolder: "CARDHOLDER'S NAME", txtValue: txtCardName)
                
                HStack(spacing : 20){
                    CardView2(txtPlaceHolder: "MM", txtValue: txtCardMM)
                    
                    CardView2(txtPlaceHolder: "YYYY", txtValue: txtCardYYYY)
                    
                    CardView2(txtPlaceHolder: "CVV", txtValue: txtCardCvv)
                }
                HStack( spacing : 10){
                    Image("right")
                        .frame(width: 20, height: 20, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Text("Save credit card information")
                    Spacer()
                }
                
                
            }.padding()
           // .frame(width: UIScreen.main.bounds.width - 40,height: 60, alignment: .center)
            Spacer()
            Button(action: {
               
            }, label: {
            Text("Add Payment Method")
                .padding()
                .foregroundColor(.white)
                .background(Constants.AppColor.appPink)
                .clipShape(Capsule())
                .onTapGesture {
                    self.isAddPayment = false
                }
            })
        }
    }
}

struct CardView2: View {
    
    var txtPlaceHolder = ""
    @State var txtValue: String = ""
     
    var body: some View {
        HStack{
            TextField(txtPlaceHolder, text: $txtValue)
                .padding()
        }
        //.padding()
        .frame(height : 50)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Constants.AppColor.appPink, lineWidth: 1)
        )
    }
}

struct AddPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentView(isAddPayment: .constant(false))
    }
}
