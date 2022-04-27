//
//  PaymentView.swift
//  PlayDate
//
//  Created by Pranjal on 29/04/21.
//

import SwiftUI

struct PaymentView: View {
    
   @State var isAddPayment = false
    @Binding var isPresentedAddPayment: Bool
    
    var body: some View {
        
        VStack{
          //  List{
            //if !isPresentedAddPayment{
                VStack(spacing : 40){
                    VStack(alignment : .leading){
                        HStack{
                            Spacer()
                            Image("dot")
                                .padding()
                                .frame(height: nil)
                                .background(Constants.AppColor.appPink)
                        }
                        Image("paypal")
                            .padding([.bottom, .trailing])
                        
                        Spacer()
                        Text("myself@me.com")
                            .foregroundColor(Constants.AppColor.appPink)
                        Spacer()
                        Text("Added on 15/02/2017")
                            .foregroundColor(Constants.AppColor.appPink)
                    }
                    .padding([.leading, .bottom])
                    .frame(width: UIScreen.main.bounds.width - 40,height: 200, alignment: .center)
                    .border(Constants.AppColor.appPink, width: 2)
                    
                    VStack(alignment : .leading){
                        HStack{
                            Spacer()
                            Image("dot")
                                .padding()
                                .frame(height: nil)
                                .background(Constants.AppColor.appPink)
                        }
                        Image("visa")
                            .padding()
                        Spacer()
                        Text("****  ****  **** 0817")
                            .foregroundColor(Constants.AppColor.appPink)
                        Spacer()
                        Text("Expiry Date 10/19")
                            .foregroundColor(Constants.AppColor.appPink)
                    }
                    .padding([.leading, .bottom])
                    .frame(width: UIScreen.main.bounds.width - 40,height: 200, alignment: .center)
                    .border(Constants.AppColor.appPink, width: 2)
                }
           // }
            Spacer(minLength: 50)
            
            
            Button(action: {
               
            }, label: {
                Text("Add New Payment Method")
                    .padding()
                    .foregroundColor(.white)
                    .background(Constants.AppColor.appPink)
                    .frame(height: 50)
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.isPresentedAddPayment = true
                    }
            })
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(isPresentedAddPayment: .constant(false))
    }
}
