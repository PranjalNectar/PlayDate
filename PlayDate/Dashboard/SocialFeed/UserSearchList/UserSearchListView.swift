//
//  UserSearchListView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 27/05/21.
//


import SwiftUI

struct UserSearchListView: View {
    //MARK:- Properties
    @State var txtSearch  = ""
    @State var suggestionsData = [SocialSuggestionDataModel]()
    @ObservedObject private var socialSuggestionListVM = SocialSuggestionsHorizontalViewModel()
    var friendRequest = [FriendRequest]()
    @Environment(\.presentationMode) var presentation
    @State private var showAlert: Bool = false
    @State private var message = ""
    @State var page = 1
    @State var limit = 10
    
    //MARK:- Body
    var body: some View {
        
        VStack(alignment:.leading,spacing: 20) {
            Button(action: { presentation.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Constants.AppColor.appBlackWhite)
                    .imageScale(.large)
                    .padding()
                    .padding(.top,30)
                    .padding(.leading)
            }
            HStack{
                Image("serach")
                    .padding([.leading,.top,.bottom])
                
                ZStack(alignment: .leading) {
                    if txtSearch.isEmpty { Text("Search here...").foregroundColor(Color.white) }
                    
                    TextField("", text: $txtSearch)
                        .onChange(of: txtSearch) {_ in
                           // callSuggestionsHorizontalApi(filter: txtSearch)
                            self.page = 0
                            self.suggestionsData.removeAll()
                            self.GetSuggestionsListService()
                        }
                        .foregroundColor(Color.white)
                }
            }
            .frame( height: 50)
            .background(Constants.AppColor.applightPink)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Constants.AppColor.appPink, lineWidth:1)
            )
            .cornerRadius(25)
            .padding([.bottom,.leading,.trailing])
           
            
            Text("Suggestions For You")
                .fontWeight(.semibold)
                .font(Font.system(size: 17.5))
                .padding(.leading,10)
                .padding(.trailing,10)
            // SuggestedList(filter: $txtSearch)
            ZStack {
                List{
                    ForEach(self.suggestionsData) { item in
                        SuggestionCellView(suggestionImage: item.profilePicPath ?? "", suggestionName: item.fullName ?? "", friendRequest: item.friendRequest ?? [FriendRequest](),id : item.id ?? "")
                            .onAppear{
                                if self.suggestionsData.last?.id == item.id{
                                    self.page += 1
                                    self.GetSuggestionsListService()
                                }
                            }
                    }
                }
            }
        }
        .onAppear{
           // callSuggestionsHorizontalApi(filter: txtSearch)
            self.GetSuggestionsListService()
        }
        .navigationBarHidden(true)
    }
    
    //MARK:- Call Api
    func GetSuggestionsListService() {
        socialSuggestionListVM.GetSuggestionsListService(self.limit, page: self.page, filter: txtSearch) { result, responce,error  in
            if result == strResult.success.rawValue{
               // self.suggestionsData = responce?.data ?? []
                let arr = responce?.data ?? []
                print(arr.count)
                for i in 0..<arr.count {
                    self.suggestionsData.append(arr[i])
                }
            }else if result == strResult.error.rawValue{
                self.message = responce?.message ?? ""
                self.showAlert = true
            }else if result == strResult.Network.rawValue{
                self.message = MessageString().Network
                self.showAlert = true
            }else if result == strResult.NetworkConnection.rawValue{
                self.message = MessageString().NetworkConnection
                self.showAlert = true
            }
        }
    }
}
