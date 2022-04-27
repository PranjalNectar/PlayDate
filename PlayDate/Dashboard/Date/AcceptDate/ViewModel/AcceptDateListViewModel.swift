//
//  AcceptDateListViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 24/06/21.
//


import Foundation

class AcceptDateListViewModel: ObservableObject {
    
    @Published var loading = false

    func GetAcceptPartnerListService(_ limit : String, page : String, completion: @escaping(_ result : String?, _ responce : AcceptDateResultListModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.create_date_get_my_partner_request.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(AcceptDateResultListModel.self, from: apiData )
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
    func callDateUpdateApi(_ id:String,status: String, completion: @escaping(_ result : String?, _ responce : FriendMatchRelationshipUpdateResultModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            
            var params = [String : Any]()
           
                 params = [
                    "requestId": id,
                    "status" : status,
                    "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                    ] as [String : Any]
           
      
               let url = EndPoints.create_date_status_update_request_partner.url
            
            
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
}

