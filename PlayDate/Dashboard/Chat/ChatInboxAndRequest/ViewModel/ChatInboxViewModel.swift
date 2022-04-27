//
//  ChatInboxViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 28/06/21.
//

import Foundation


class ChatInboxViewModel: ObservableObject {
    
    @Published var loading = false
    
    func GetInboxUserListService(_ limit : Int, page : Int, completion: @escaping(_ result : String?, _ responce : ChatInboxModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_chat_users.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(ChatInboxModel.self, from: apiData )
                            // print("JSON", result.data.fullName)
                            print(result)
                            if response.status != 0{
                                completion(strResult.success.rawValue,response, nil)
                            }else{
                                completion(strResult.error.rawValue,response, nil)
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
    
    
    
    func DeleteChatRoomService(_ chatID : String, completion: @escaping(_ result : String?, _ responce : ChatInboxModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "chatId" : chatID
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.delete_chat_room.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(ChatInboxModel.self, from: apiData )
                            // print("JSON", result.data.fullName)
                            print(result)
                            if response.status != 0{
                                completion(strResult.success.rawValue,response, nil)
                            }else{
                                completion(strResult.error.rawValue,response, nil)
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
