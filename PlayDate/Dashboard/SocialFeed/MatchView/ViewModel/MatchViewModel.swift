//
//  MatchViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/05/21.
//

import Foundation

class MatchViewModel: ObservableObject {
   
    @Published var loading = false
    
    func callMatchListApi(_ limit : Int, page : Int,filter : String, completion: @escaping(_ result : String?, _ responce : MatchResultModel?, _ error : String?) -> ()) {
        self.loading = true
        if Reachability.isConnectedToNetwork(){
            let params = [
                "limit": limit,
                "pageNo" : page,
                "filter" : filter
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_user_match_list.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(MatchResultModel.self, from: apiData )
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
    
    func callMatchLikeDisLiketApi(_ id:String,action:String, completion: @escaping(_ result : String?, _ responce : LikeDislikeMatchModel?, _ error : String?) -> ()) {
        //self.loading = true
        if Reachability.isConnectedToNetwork(){
            let params = [
                "toUserID": id,
                "action" : action
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_user_match_request.url, parameters: params as NSDictionary) { ( result , data) in
               // self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(LikeDislikeMatchModel.self, from: apiData )
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
