//
//  SocialSuggestionsHorizontalViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import Foundation

class SocialSuggestionsHorizontalViewModel: ObservableObject {
   

    @Published var loading = false
    
    /////////// Get Suggestions List Api ////////////////////////
    func GetSuggestionsListService(_ limit : Int, page : Int ,filter : String, completion: @escaping(_ result : String?, _ responce : SocialSuggestionResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "limit": limit,
                "pageNo" : page,
                "filters" : filter
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.getUsersSuggestions.url, parameters: params as NSDictionary) { ( result , data) in
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(SocialSuggestionResultModel.self, from: apiData )
                            print(result)
                            if responce.status != 0{
                                completion(strResult.success.rawValue,responce, nil)
                            }else{
                                completion(strResult.error.rawValue,responce, nil)
                            }
                        } catch (let error){
                            completion(strResult.error.rawValue, nil, error.localizedDescription)
                            print("ERROR:", error)
                        }
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
    

    /////////// Post Add Friend Request Api ////////////////////////
    func PostAddRemoveFriendRequestService(id : String,type:String, completion: @escaping(_ result : String?, _ responce : AddRemoveFriendResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            var params = [String : Any]()
            var url = ""
            if type == "RemoveFriend"{
                 params = [
                    "friendId": id,
                    "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                ] as [String : Any]
                
                url = EndPoints.remove_friend.url
                
            }else {
                 params = [
                    "toUserID": id
                ] as [String : Any]
              
                url = EndPoints.addFriendRequest.url
            }
            print(params)
          
            CommunicationManager().getResponseForPost(strUrl: url, parameters: params as NSDictionary) { ( result , data) in
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(AddRemoveFriendResultModel.self, from: apiData )
                            print(result)
                            if responce.status != 0{
                                completion(strResult.success.rawValue,responce, nil)
                            }else{
                                completion(strResult.error.rawValue,responce, nil)
                            }
                        } catch (let error){
                            completion(strResult.error.rawValue, nil, error.localizedDescription)
                            print("ERROR:", error)
                        }
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
    
    
    /////////// Add chat request Api ////////////////////////
    func AddChatRequestService(_ toUserId : String, completion: @escaping(_ result : String?, _ responce : SocialSuggestionResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "toUserId": toUserId,
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_chat_request.url, parameters: params as NSDictionary) { ( result , data) in
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(SocialSuggestionResultModel.self, from: apiData )
                            print(result)
                            if responce.status != 0{
                                completion(strResult.success.rawValue,responce, nil)
                            }else{
                                completion(strResult.error.rawValue,responce, nil)
                            }
                        } catch (let error){
                            completion(strResult.error.rawValue, nil, error.localizedDescription)
                            print("ERROR:", error)
                        }
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
}
