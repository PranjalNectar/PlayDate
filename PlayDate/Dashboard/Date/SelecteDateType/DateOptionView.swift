//
//  DateOptionView.swift
//  PlayDate
//
//  Created by Pranjal on 10/06/21.
//

import SwiftUI

struct DateOptionView: View {
    
    @State private var isInPerson: Bool = false
    @State private var isVirtual: Bool = false
    
    var body: some View {
        ZStack{
            VStack(spacing : 10){
                VStack{
                    HStack{
                        BackButton()
                        Spacer()
                    }
                    HStack(alignment : .top){
                        Image("logo")
                            //.padding(.top, 100.0)
                            .frame(height : 100)
                    }
                    
                    Text("Select Date")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Helvetica Neue", size: 25.0))
                        .padding()
                }
                .padding()
                .padding(.top, 10)
            
                GeometryReader { geometry in
                    ScrollView( showsIndicators: false){
                        VStack(spacing : 30){
                            //DateLocationView
                            NavigationLink(destination: SelectPartnerView(dateTypeVirtual: .constant(false)), isActive: $isInPerson)  {
                                ZStack{
                                    Image("inperson")
                                    Text("IN PERSON")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Arial Rounded MT Bold", size: 48.0))
                                }
                            }
                            
                            Text("OR")
                                .foregroundColor(.white)
                           // VirtualRestaurantListView
                            NavigationLink(destination: SelectPartnerView( dateTypeVirtual: .constant(true)), isActive: $isVirtual)  {
                                ZStack{
                                    Image("virtual")
                                    Text("VIRTUAL")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Arial Rounded MT Bold", size: 48.0))
                                }
                            }
                        }
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                        //Spacer()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        
    }
}

struct DateOptionView_Previews: PreviewProvider {
    static var previews: some View {
        DateOptionView()
    }
}
