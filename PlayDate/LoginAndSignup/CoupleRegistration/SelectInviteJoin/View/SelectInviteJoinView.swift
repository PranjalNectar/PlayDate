//
//  SelectInviteJoinView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/06/21.
//

import SwiftUI

struct SelectInviteJoinView: View {
    
    @Binding var comingFromEdit: Bool
    @State private var didTapI:Bool = false
    @State private var didTapJ:Bool = false
    @Environment(\.presentationMode) var presentation
    @State private var Authenticate: Bool = false
    @State private var error: Bool = false
    @State var inviteJoin = ""
    @State var arrValid = [String]()
    @State var c: AlertAction?
    @State var shown = false
    @State var message = ""
    @ObservedObject private var restaurantListVM = RestaurantViewModel()
    @State private var controller: Controller = .InvitePartner
    @Binding var localRelationship : String
    @Binding var comeFromBack:Bool
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    
                    let backButton = UserDefaults.standard.bool(forKey: Constants.UserDefaults.backButton)
                    if backButton {
                        BackButton()
                    }else {
                        BackButton().hidden()
                    }
                    
                    Spacer()
                }
                HStack(alignment :.top){
                    VStack(alignment : .leading ,spacing: 10.0){
                        Text("Connect with your partner")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 18.0))
                        
                        Text("Please select an action for your partner")
                            .foregroundColor(.white)
                            .font(.custom("Helvetica Neue", size: 14.0))
                    }
                    Spacer()
                }.padding(.leading, 16.0)
                Spacer()
                
                VStack(spacing: 25.0){
                    Button(action: {
                        if !self.didTapI{
                            self.didTapI = true
                            self.didTapJ = false
                        }
                        inviteJoin = "Invite"
                    }) {
                        RelationText(text: "INVITE")
                            .background(didTapI ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                    
                    OrText()
                    
                    Button(action: {
                        if !self.didTapJ{
                            self.didTapJ = true
                            self.didTapI = false
                        }
                        inviteJoin = "Join"
                    }) {
                        RelationText(text:"JOIN")
                            .background(didTapJ ? Constants.AppColor.appPink : Constants.AppColor.appRegisterbg)
                    }.cornerRadius(5.0)
                }
                
                Spacer()
                VStack(alignment: .center){
                   
                    NavigationLink(destination:chooseDestination(), isActive: $Authenticate) {
                        Button(action: {
                            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                            if inviteJoin == ""  {
                                self.Authenticate = false
                                self.shown = true
                                arrValid = [String]()
                                arrValid.append(MessageString().inviteJoin)
                            }else {
                                
                                 self.Authenticate = true
                                self.shown = false
                                arrValid = [String]()
                                selectController()
                            }
                            
                        }, label: {
                            NextArrow()
                        })
                        
                        .alert(isPresented: self.$error) {
                            Alert(title: Text(message))
                        }
                    }
                    
                }
                Spacer()
                
            }.blur(radius: shown ? 10 : 0)
            .background(BGImage())
            .navigationBarHidden(true)
            
            if shown
            {
                
                AlertView(shown: $shown, closureA: $c, message: "We required few more details!!.", arr: arrValid)
                
            }
        }
        .statusBar(style: .lightContent)
        .onAppear{
            self.comeFromBack = true
        }
        
    }
    enum Controller {
        case InvitePartner, JoinInviteCode
    }
    
    @ViewBuilder
    func chooseDestination() -> some View {
        switch controller {
        case .InvitePartner: InvitePartnerView(comingFromEdit: $comingFromEdit, localRelationship: $localRelationship)
        default: JoinInviteCodeView(comingFromEdit: $comingFromEdit, localRelationship: $localRelationship)
        }
    }
    
    func selectController(){
        if inviteJoin == "Invite" {
            controller = .InvitePartner
        }else{
            controller = .JoinInviteCode
        }
    }
}

