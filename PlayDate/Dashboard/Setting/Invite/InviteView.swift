//
//  InviteView.swift
//  PlayDate
//
//  Created by Pranjal on 30/04/21.
//

import SwiftUI

struct InviteView: View {
    
    @ObservedObject var ProfileVM: ProfileViewModel = ProfileViewModel()
    @State var profileData : ProfileDetailData?
    @State var inviteLink = ""
    @State var shareSheetItems: [Any] = []
    @State private var showShareSheet: Bool = false
    @State var comFrom : Bool
    
    var body: some View {
        VStack(spacing : 10){
            ScrollView{
                VStack(){
                    HStack{
                        BackButton()
                        Spacer()
                    }
                    VStack{
                        if comFrom {
                            Text("Refer your Frinds and Earn Points")
                                .font(.custom("Arial Rounded MT Bold", size: 30.0))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }else {
                            Text("Invite your Friends \nand Earn Points")
                                .font(.custom("Arial Rounded MT Bold", size: 30.0))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                      
                        
                        Image("invitelogo")
                        
                        Text("Every time one of your friends signs up,\n you will both receive 25 Points !")
                            .font(.custom("Arial", size: 14.0))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        InviteNumber()
                        
                        Text("Send Invite via")
                            .padding()
                            .foregroundColor(.white)
                        
                        // Spacer()
                        
                    }
                }
                .frame(height:600)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.init(hex: "7B0063"),Color.init(hex: "D13A6F") ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(radius: 45, corners: [.bottomLeft, .bottomRight])
                
                
                HStack(spacing : 15){
                    InviteSocialIcon(strIcon: "invitetwitter")
                        .background(Color.blue)
                        .cornerRadius(15.0)
                        .onTapGesture {
                            self.showShareSheet = true
                        }
                    
                    InviteSocialIcon(strIcon: "invitefb")
                        .background(Color.blue)
                        .cornerRadius(15.0)
                        .onTapGesture {
                            self.showShareSheet = true
                        }
                    
                    InviteSocialIcon(strIcon: "inviteinsta")
                        .background(Color.gray)
                        .cornerRadius(15.0)
                        .onTapGesture {
                            self.showShareSheet = true
                        }
                    
                    InviteSocialIcon(strIcon: "invitemessage")
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .onTapGesture {
                            self.showShareSheet = true
                        }
                }
                .offset(y :-30)
                
                //Spacer()
                HStack(spacing : 15){
                    ZStack{
                        Image("invitecircle")
                        Image("inviteuser")
                    }
                    
                    ZStack{
                        Image("invitecircle")
                        Image("inviteuser")
                    }
                    
                    ZStack{
                        Image("invitecircle")
                        Image("inviteuser")
                    }
                }
                .padding()
            }
        }
        .statusBar(style: .lightContent)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showShareSheet, content: {
            
            ActivityViewController(activityItems: self.$shareSheetItems)
        })
        .onAppear{
            self.ProfileDetailService()
        }
    }
    
    func ProfileDetailService(){
        ProfileVM.GetProfileDetailService(userID: "", comeFromProfileTab: true) { result, response,error in
            
            if result == strResult.success.rawValue{
                self.profileData = response?.data?[0]
                self.inviteLink = response?.data?[0].inviteLink ?? ""
                self.shareSheetItems = [self.inviteLink]
            }else if result == strResult.error.rawValue{
//                self.message = response?.message ?? ""
//                self.showAlert = true
            }else if result == strResult.Network.rawValue{
//                self.message = MessageString().Network
//                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
//                self.message = MessageString().NetworkConnection
//                self.showAlert = true
            }
        }
    }
}

struct InviteSocialIcon: View {
    @State var strIcon = ""
    var body: some View {
        Image(strIcon)
            .padding()
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(15.0)
    }
}

struct InviteNumber: View {
    var body: some View {
        VStack(alignment : .center){
            HStack(spacing : 5)
            {
                Text("1")
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Constants.AppColor.appPink)
                    .font(.custom("Arial Rounded MT Bold", size: 20.0))
                    .clipShape(Circle())
                Text("-")
                    .foregroundColor(.white)
                Text("-")
                    .foregroundColor(.white)
                Text("-")
                    .foregroundColor(.white)
                Text("2")
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Constants.AppColor.appPink)
                    .font(.custom("Arial Rounded MT Bold", size: 20.0))
                    .clipShape(Circle())
                Text("-")
                    .foregroundColor(.white)
                Text("-")
                    .foregroundColor(.white)
                Text("-")
                    .foregroundColor(.white)
                Text("3")
                    .padding()
                    .background(Color.white)
                    .foregroundColor(Constants.AppColor.appPink)
                    .font(.custom("Arial Rounded MT Bold", size: 20.0))
                    .clipShape(Circle())
                
            }
            //.frame(width : 250)
            HStack(spacing : 30){
                Text("You invite a \nfriend")
                    .font(.custom("Arial", size: 12.0))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("They join\nPlayDate")
                    .font(.custom("Arial", size: 12.0))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
               
                Text("You both get\nFree Points")
                    .font(.custom("Arial", size: 12.0))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            
        }
    }
}



struct ActivityViewController: UIViewControllerRepresentable {

    @Binding var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil //[UIActivity.ActivityType.postToFacebook,
                                                            // UIActivity.ActivityType.message,
                                                            // UIActivity.ActivityType.postToTwitter
    //]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: nil)

        controller.excludedActivityTypes = excludedActivityTypes

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
