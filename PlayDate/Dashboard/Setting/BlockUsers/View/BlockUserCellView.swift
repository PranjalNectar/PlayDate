//
//  BlockUserCellView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BlockUserCellView: View {
 
    let block : BlockUserDataModel
   
    @State private var message = ""
    @State private var error: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var showAlert: Bool = false

    @Binding var status : Int
    @Environment(\.presentationMode) var presentation
   

    init(block:BlockUserDataModel,status:Binding<Int>) {
        self._status = status
        self.block = block
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableView.appearance().separatorStyle = .none
    }


    var body: some View {
        Button (action: {  }){
            VStack(alignment:.leading,spacing:0){
                HStack(){
                    if (block.profilePicPath ?? "" ) == ""{
                            Image("profileplaceholder")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                                .clipped()
                        }else {
                            WebImage(url: URL(string: (block.profilePicPath ?? "") ))
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                                //.clipped()
                        }

                        Text(block.username ?? "" )
                            .foregroundColor(Constants.AppColor.appBlackWhite)
                            .fontWeight(.bold)
                            .font(Font.system(size: 13.5))
                    Spacer()
                    Button {
                        //self.UnBlockUserService()
                    } label: {
                        Image("icons8-lockBlack")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 30, height: 30)
                            .clipped()
                    }
                   
                    .alert(isPresented: $showAlert, content: {
                        switch activeAlert {
                        case .error:
                            return  Alert(title: Text("Error"),
                                          message: Text(message),
                                          dismissButton: .default(Text("OK")) { })
                        case .success:
                            return  Alert(title: Text("Success"),
                                          message: Text(message),
                                          dismissButton: .default(Text("OK")) { })
                            
                        }
                    })
                    
                }
              
            }
        }
        .onAppear{

        }
    }

}

