//
//  GameStoreView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 08/07/21.
//

import SwiftUI

struct GameStoreView: View {
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ZStack{
            
            VStack(alignment: .center, spacing: 0){
                VStack{
                    HStack{
                    
                        Button(action: { presentation.wrappedValue.dismiss() }) {
                            Image("stage_white")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding()
                        }
                       
                        Spacer()
                        Image("Icon ionic-md-timer_white")
                        Text("29:59")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Spacer()
                        Image("smallCross")
                            .onTapGesture{
                              //  self.DeleteDateRequestPartnerService()
                            }.padding(.trailing,16)
                    }
                    Image("logo")
                        //.padding(.top, 100.0)
                        .frame(height : 100)
                    HStack(alignment : .top){
                       Text("")
                        Spacer()
                        Image("Store")
                    }.padding(.trailing,20)
                    
                    ScrollView(showsIndicators: false){
                    VStack(spacing:16){
                        Group {
                        HStack(spacing:10){
                            Group {
                            ZStack{
                                Group {
                                HStack{
                                    Text("800 points")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 16.0))
                                        .padding([.leading,.trailing],20)
                                   
                                }.background(Color.gray)
                                .frame(height:24)
                                .cornerRadius(12)
                                .clipped()
                               
                                HStack{
                                    Image("game-star")
                                      .frame(height: 40)
                                        .padding(.trailing,-20)
                                    Spacer()
                                }
                            }
                            }
                            ZStack{
                                Group {
                                HStack{
                                    Text("  40 Coins  ")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 16.0))
                                        .padding([.leading,.trailing],20)
                                   
                                }.background(Color.gray)
                                .frame(height:24)
                                .cornerRadius(12)
                                .clipped()
                               
                                HStack{
                                    Image("game-heart")
                                      .frame(height: 40)
                                        .padding(.trailing,-20)
                                    Spacer()
                                }
                            }
                                }
                        }
                        }
                            
                        HStack(spacing:10){
                            ZStack{
                                Group {
                                HStack{
                                    Text("1 Multi's")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 16.0))
                                        .padding([.leading,.trailing],20)
                                   
                                }.background(Color.gray)
                                .frame(height:24)
                                .cornerRadius(12)
                                .clipped()
                               
                                HStack{
                                    Image("game-spin")
                                      .frame(height: 40)
                                        .padding(.trailing,-20)
                                    Spacer()
                                }
                                }
                            }
                            HStack{
                            ZStack{
                                Group {
                                HStack{
                                    Text("   0 DM's   ")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 16.0))
                                        .padding([.leading,.trailing],20)
                                   
                                }.background(Color.gray)
                                .frame(height:24)
                                .cornerRadius(12)
                                .clipped()
                               
                                HStack{
                                    Image("game-msg")
                                      .frame(height: 40)
                                        .padding(.trailing,-20)
                                    Spacer()
                                }
                                }
                            }
                            }
                        }
                        
                            
                            Group {
                        ZStack{
                            Spacer()
                            Group {
                            HStack{
                                Text("   40 Coins   ")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 16.0))
                                    .padding([.leading,.trailing],20)
                               
                            }.background(Color.gray)
                            .frame(height:24)
                            .cornerRadius(12)
                            .clipped()
                           
                            HStack{
                                Image("game-heart")
                                  .frame(height: 40)
                                    .padding(.trailing,-20)
                                Spacer()
                            }
                            Spacer()
                        }
                        }
                        
                        
                        ZStack{
                        
                            VStack{
                                Text("One Time Purchase")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.custom("Helvetica Neue", size: 16.0))
                                    .padding(.top,10)
                                
                                HStack(spacing:20){
                                    Group {
                                    VStack{
                                        Image("game-spin")
                                        Text("3")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 16.0))
                                    }
                                    VStack{
                                        Group {
                                        HStack{
                                            Text("+")
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .font(.custom("Helvetica Neue", size: 16.0))
                                            Image("game-spin")
                                            Text("+")
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .font(.custom("Helvetica Neue", size: 16.0))
                                        }
                                        
                                        Text("3")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 16.0))
                                        }
                                    }
                                    VStack{
                                        Image("game-spin")
                                        Text("3")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .font(.custom("Helvetica Neue", size: 16.0))
                                    }
                                }
                            }
                                HStack{
                                    Text("$10.43")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.custom("Helvetica Neue", size: 16.0))

                                        .frame(width:UIScreen.main.bounds.width-40)
                                }
                            
                                .background(Constants.AppColor.appPink)
                            }
                      
                            
                        }
                        
                        .frame(width:UIScreen.main.bounds.width-40)
                        .background(Color.gray)
                        .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
                        .clipped()
                        }
                            Group {
                        TypeOfCoinView(typeOfCoin: .constant("Game Coins"))
                        
                        HStack(spacing:5){
                            Group {
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }
                            
                        }.padding([.leading,.trailing],20)
                        
                        HStack(spacing:5){
                            Group {
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("multipleCoins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }
                            
                        }.padding([.leading,.trailing],20)
                        
                        TypeOfCoinView(typeOfCoin: .constant("Date Coins"))
                        
                        HStack(spacing:5){
                            Group {
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }

                        }.padding([.leading,.trailing],20)

                        HStack(spacing:5){
                            Group {
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("date-coins"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }

                        }.padding([.leading,.trailing],20)
                        
                        
                        TypeOfCoinView(typeOfCoin: .constant("Multiplier Boosters"))
                        
                        HStack(spacing:5){
                            Group {
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }

                        }.padding([.leading,.trailing],20)

                        HStack(spacing:5){
                            
                            Group {
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            CoinsView(imageName: .constant("game-spin"), noOfCoins: .constant("1"), price: .constant("$10.44"))
                            }

                        }.padding([.leading,.trailing],20)
                                
                                TypeOfCoinView(typeOfCoin: .constant("DM Boosters"))
//
//                                HStack(spacing:5){
//
//                                    Group {
//                                    CoinsView(imageName: .constant("game-msg"), noOfCoins: .constant("1"), price: .constant("$10.44"))
//                                    CoinsView(imageName: .constant("game-msg"), noOfCoins: .constant("1"), price: .constant("$10.44"))
//                                    CoinsView(imageName: .constant("game-msg"), noOfCoins: .constant("1"), price: .constant("$10.44"))
//                                    }

                              //  }.padding([.leading,.trailing],20)
                            }
                     
                       
//
                    }
                    }.padding([.leading,.trailing],20)
                }
               // .padding()
                .padding(.top,20)
            }
        }
        } .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}


struct CoinsView: View {
    @Binding var imageName : String
    @Binding var noOfCoins: String
    @Binding var price: String
    var body: some View {
        VStack(spacing:0){
            HStack{
                ZStack{
                    VStack{
                        Image(imageName)
                            .padding(.top,5)
                        Text(noOfCoins)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        HStack{
                            Text(price)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.custom("Helvetica Neue", size: 16.0))

                            .frame(width:((UIScreen.main.bounds.width)/3)-20)
                        }
                    
                        .background(Constants.AppColor.appPink)
                    }
                }
              
                .background(Color.gray)
                .cornerRadius(radius: 20, corners: [.topLeft, .topRight])
                .clipped()
            }
        }
    }
}

struct TypeOfCoinView: View {
    @Binding var typeOfCoin : String
   
    var body: some View {
        HStack{
            Text(typeOfCoin)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 16.0))
                .frame(width:UIScreen.main.bounds.width-40,height:30)
                .background(Color.gray)
                .cornerRadius(20)
                .clipped()
           
        }
    }
}
