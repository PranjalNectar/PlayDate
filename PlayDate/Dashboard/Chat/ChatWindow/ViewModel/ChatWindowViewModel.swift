//
//  ChatWindowViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 29/06/21.
//

import Foundation


class ChatWindowViewModel: ObservableObject {
    
    @Published var loading = false
    
    func GetChatMessageService(_ chatId : String, limit : Int, page : Int, completion: @escaping(_ result : String?, _ responce : GetChatMessageModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "chatId" : chatId,
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_chat_message.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(GetChatMessageModel.self, from: apiData )
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
    
    
    func AddChatMediaService(_ sectiontype : String, mediatype : String, imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : AddMediaModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.add_chat_media.url + "?section=\(sectiontype)&mediaType=\(mediatype)")
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.add_chat_media.url + "?section=\(sectiontype)&mediaType=\(mediatype)", parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "mediaFeed", check: mediatype) { (result, data) in
                
                self.loading = false
               
                if result != strResult.Network.rawValue{
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(AddMediaModel.self, from: apiData )
                        //self.media = result.data
                        if response.status != 0{
                            completion(strResult.success.rawValue,response, nil)
                        }else{
                            completion(strResult.error.rawValue,response, nil)
                        }
                    } catch (let error){
                        completion(strResult.error.rawValue, nil, error.localizedDescription)
                        print("ERROR:", error)
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
    
    
    func DeleteChatMessageService(_ chatId : String,messageId : String , completion: @escaping(_ result : String?, _ responce : GetChatMessageModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "chatId" : chatId,
                "messageId" : messageId
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.delete_chat_message.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(GetChatMessageModel.self, from: apiData )
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
