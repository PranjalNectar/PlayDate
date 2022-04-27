//
//  BlockUserViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 02/06/21.
//

import Foundation
import Foundation
import ActivityIndicatorView

class BlockUserViewModel: ObservableObject {
    
    @Published var loading = false
    
    func GetBlockListService(postId : String, status : String, completion: @escaping(_ result : String?, _ responce : BlockUserListModelClass?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "status" : status
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_user_blocked.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(BlockUserListModelClass.self, from: apiData )
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
    

    func GetUnblockBlockService(toUserId : String, action : String, completion: @escaping(_ result : String?, _ responce : UnBlockUserModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "toUserId": toUserId,
                "action" : action
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.remove_user_report_block.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async { 
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(UnBlockUserModel.self, from: apiData )

                            // print("JSON", result.data.fullName)
                            if response.status != 0{
                                completion(strResult.success.rawValue,response, nil)
                            }else{
                                completion(strResult.error.rawValue,response, nil)
                            }
                        } catch (let error){
                            completion(strResult.error.rawValue, nil, error.localizedDescription)
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
