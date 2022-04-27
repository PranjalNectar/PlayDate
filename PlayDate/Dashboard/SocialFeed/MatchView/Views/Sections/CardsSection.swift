
import SwiftUI

struct CardsSection: View {
    @ObservedObject private var matchVM = MatchViewModel()
    @State var matchData = [MatchData]()
    @Binding var comeFromMaxView : Bool
    @Binding var maxViewMatchData : MatchData!
    @State var comeFrom = false
    @State var status = 0
    @Binding var message :String
    @Binding var showAlert :Bool
    @State var page = 1
    @State var limit = 100
    
    var body: some View {
        ZStack{
            if comeFrom {
                SwipeView(card1: self.maxViewMatchData, status: $status, comeFrom: $comeFrom, message: $message, showAlert: $showAlert, profileVideoPath: self.maxViewMatchData.profileVideoPath ?? "", interestedList: self.maxViewMatchData.interestedList ?? [InterestedList]() )
                
                    .onChange(of: showAlert) { (value) in
                        print(showAlert)
                        print(message)
                    }
                   
            }else{
                ForEach(self.matchData.reversed()) { match in
                    SwipeView(card1: match, status: $status, comeFrom: $comeFrom, message: $message, showAlert: $showAlert, profileVideoPath: match.profileVideoPath ?? "", interestedList: match.interestedList ?? [InterestedList]() ).cornerRadius(30).clipped()
                      //  .background(Color.white)
//                        .onAppear{
//                            if self.matchData.last?.id == match.id{
//                                self.page += 1
//                                self.callMatchListApi(filter: "")
//                            }
//                        }
                      
                        .onChange(of: showAlert) { (value) in
                            print(showAlert)
                            print(message)
                        }
                }
            }
            ActivityLoader(isToggle: $matchVM.loading)
        }
        .navigationBarHidden(true)
        .cornerRadius(30)
        .clipped()
        //.zIndex(1.0)
        .alert(isPresented: $showAlert, title: Constants.AppName, message: self.message)
        .onAppear{
            comeFrom = comeFromMaxView
            if comeFrom {
                //print(self.maxViewMatchData)
            }else {
                callMatchListApi(filter:"")
            }
            
         
        }
        
    }
    
    func callMatchListApi(filter:String) {
        matchVM.callMatchListApi(self.limit, page: self.page,filter: filter) { result,responce,error  in
            if result == strResult.success.rawValue{
                self.matchData = responce?.data ?? []
//                let arr = responce?.data ?? []
//                print(arr.count)
//                for i in 0..<arr.count {
//                    self.matchData.append(arr[i])
//                }
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

