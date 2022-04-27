//
//  UserFriendListViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 20/06/21.
//
import Foundation
import ActivityIndicatorView
class UserFriendListViewModel: ObservableObject {
    
    @Published var loading = false
    
    func PostCreateRelationshipsService(toUserId : String, completion: @escaping(_ result : String?, _ responce : UserFriendListResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "toUserId" : toUserId
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.createRelationship.url, parameters: params as NSDictionary) { ( result , data) in
                if result != "Network"{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(UserFriendListResultModel.self, from: apiData )
                            
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
    
    func PostLeaveRelationshipsService(requestId : String, completion: @escaping(_ result : String?, _ responce : UserFriendListResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "requestId" : requestId
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.leaveRelationship.url, parameters: params as NSDictionary) { ( result , data) in
                if result != "Network"{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(UserFriendListResultModel.self, from: apiData )
                            
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
