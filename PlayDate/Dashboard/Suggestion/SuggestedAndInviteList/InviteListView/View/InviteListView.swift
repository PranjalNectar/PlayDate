//
//  InviteListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/05/21.
//

import SwiftUI
import MessageUI

struct InviteListView: View {
    @State private var showShareSheet: Bool = false
    @State var shareSheetItems: [Any] = []
    private let mailComposeDelegate = MailComposerDelegate()
    private let messageComposeDelegate = MessageComposerDelegate()
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
      @State var isShowingMailView = false
    
    var body: some View {
        VStack(alignment:.leading , spacing: 20) {
            Button {
                self.showShareSheet = true
            } label: {
                HStack(spacing:10){
                    Image("invite_facebook")
                    Text("Invite Friends by Facebook")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(Font.system(size: 12.5))
                    Spacer()
                }
            }
            
            Button {
                self.presentMessageCompose()
            } label: {
                HStack(spacing:10){
                    Image("Icon feather-message-square")
                    Text("Invite Friends by SMS")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(Font.system(size: 12.5))
                    Spacer()
                }
            }
            
            Button {
                self.presentMailCompose()
                // self.isShowingMailView = true
            } label: {
                HStack(spacing:10){
                    Image("Icon feather-upload")
                    Text("Invite Friends by Email")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(Font.system(size: 12.5))
                    Spacer()
                }
            }
            
            Button {
                self.showShareSheet = true
            } label: {
                HStack(spacing:10){
                    Image("Icon feather-user")
                    Text("Invite Friends by...")
                        .foregroundColor(Color.black)
                        .fontWeight(.bold)
                        .font(Font.system(size: 12.5))
                    Spacer()
                }
            }
            
            Spacer()
        }.padding(.leading,16)
        .padding(.trailing,16)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
           let inviteLink = getRegisterDefaultData!["inviteLink"] ?? ""
            print("inviteLink=====\(inviteLink)")
            
            self.shareSheetItems = [inviteLink]
        }
        .sheet(isPresented: $showShareSheet, content: {
            
            ActivityViewController(activityItems: self.$shareSheetItems)
        })
    }
}

// MARK: The email extension

extension InviteListView {

    private class MailComposerDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {

            controller.dismiss(animated: true)
        }
    }
    /// Present an mail compose view controller modally in UIKit environment
    private func presentMailCompose() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
        let inviteLink = getRegisterDefaultData!["inviteLink"] ?? ""
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = mailComposeDelegate
        composeVC.setSubject("Invite")
        composeVC.setMessageBody(inviteLink as! String, isHTML: false)

        vc?.present(composeVC, animated: true)
    }
}

// MARK: The message extension

extension InviteListView {

    private class MessageComposerDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }
    }
    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let getRegisterDefaultData  = UserDefaults.standard.dictionary(forKey: Constants.UserDefaults.loginData)
        let inviteLink = getRegisterDefaultData!["inviteLink"] ?? ""
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate
        composeVC.body = inviteLink as? String

        vc?.present(composeVC, animated: true)
    }
}
