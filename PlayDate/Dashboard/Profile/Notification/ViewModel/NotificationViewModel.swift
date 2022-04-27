//
//  NotificationViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/05/21.
//
import Foundation

class NotificationViewModel: ObservableObject {
    
    @Published var loading = false

    func callNotificationListApi(_ limit : Int, page : Int, completion: @escaping(_ result : String?, _ responce : NotiResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "limit": limit,
                "pageNo" : page
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_notifications.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(NotiResultModel.self, from: apiData )
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
    

    func callFriendMatchRelationshipUpdateApi(_ id:String,status: String,patternID:String, completion: @escaping(_ result : String?, _ responce : FriendMatchRelationshipUpdateResultModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            
            var params = [String : Any]()
            if patternID == "Friend" || patternID == "Match"{
             params = [
                "requestID": id,
                "status" : status
                ] as [String : Any]
                
            }else if patternID == "Relationship"{
                 params = [
                    "requestId": id,
                    "status" : status,
                    "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                    ] as [String : Any]
            }
           
            var url = ""
            if patternID == "Friend" {
                url = EndPoints.friend_request_status_update.url
            }else if patternID == "Match"{
                url = EndPoints.match_request_status_update.url
            }else if patternID == "Relationship" {
                url = EndPoints.updateStatusRelationship.url
            }
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(FriendMatchRelationshipUpdateResultModel.self, from: apiData )
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
    
    func callUpadteNotificationApi(_ id:String,status: String,action:String, completion: @escaping(_ result : String?, _ responce : NotificationUpdatetModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "notificationId": id,
                "status" : status,
                "action" : action,
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.update_notification.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(NotificationUpdatetModel.self, from: apiData )
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
    
    
    func UpdateChatNotificationApi(_ id:String,status: String,completion: @escaping(_ result : String?, _ responce : NotificationUpdatetModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "requestID": id,
                "status" : status,
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.chat_request_status_update.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(NotificationUpdatetModel.self, from: apiData )
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
    
    
    func GetNotificationCount(_ completion: @escaping(_ result : String?, _ responce : NotificationCountModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            //self.loading = true
            let params = [:] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_notifications_count.url, parameters: params as NSDictionary) { ( result , data) in
                //self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(NotificationCountModel.self, from: apiData )
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


