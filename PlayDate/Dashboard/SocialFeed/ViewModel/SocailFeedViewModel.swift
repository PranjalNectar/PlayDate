//
//  SocailFeedViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 20/05/21.
//

import Foundation
import ActivityIndicatorView

enum strResult : String{
    case success = "success"
    case error = "error"
    case Network = "Network"
    case NetworkConnection = "NetworkConnection"
    
    var instance : String {
      return self.rawValue
    }
}

class SocialFeedViewModel: ObservableObject {
    
    func loadPackages() {
        print("load pull to refresh")
    }
    
    
    @Published var loading = false
    
    /////////// Get Social Feeds ////////////////////////
    func GetSocialFeedService(_ limit : Int, page : Int, completion: @escaping(_ result : String?, _ responce : SocialFeedModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            //self.loading = true
            let params = [
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_post_feed.url, parameters: params as NSDictionary) { ( result , data) in
               // self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(SocialFeedModel.self, from: apiData )
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
    
    func PostLikeUnlikeService(_ postId : String, status : String, completion: @escaping(_ result : String?, _ error : String?) -> ()) {
        //self.loading = true
        
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "status" : status
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_post_like_unlike.url, parameters: params as NSDictionary) { ( result , data) in
                //self.loading = false
                if(result == strResult.success.rawValue) {
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    completion(strResult.success.rawValue, nil)
                }else if (result == strResult.error.rawValue) {
                    completion(strResult.error.rawValue, nil)
                }else if (result == strResult.Network.rawValue) {
                    completion(strResult.Network.rawValue, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue, nil)
        }
    }
    
    
    func PostSaveService(_ postId : String, status : String, completion: @escaping(_ result : String?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "status" : status
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.post_file_save_gallery.url, parameters: params as NSDictionary) { ( result , data) in
                if(result == strResult.success.rawValue) {
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    completion(strResult.success.rawValue, nil)
                }else if (result == strResult.error.rawValue) {
                    completion(strResult.error.rawValue, nil)
                }else if (result == strResult.Network.rawValue) {
                    completion(strResult.Network.rawValue, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue, nil)
        }
    }
    
    func GetFriendsService(_ limit : String, page : String, completion: @escaping(_ result : String?, _ responce : FriendListModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_friends_list.url, parameters: params as NSDictionary) { ( result , data) in
                
                self.loading = false
                if result != "Network"{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(FriendListModel.self, from: apiData )
                            
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
    
    func GetPostNotificationOnOffService(postId : String, status : String, completion: @escaping(_ result : String?, _ responce : PostNotificationOnOfftModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "status" : status
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.post_notification_on_off.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(PostNotificationOnOfftModel.self, from: apiData )
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
    
    func GetBlockUserService(toUserId : String, action : String, completion: @escaping(_ result : String?, _ responce : BlockUserPosttModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "toUserId": toUserId,
                "action" : action
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_user_report_block.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(BlockUserPosttModel.self, from: apiData )
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
    
    func GetDeletePostService(postId : String, completion: @escaping(_ result : String?, _ responce : DeletePostPosttModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.delete_post.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(DeletePostPosttModel.self, from: apiData )
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
