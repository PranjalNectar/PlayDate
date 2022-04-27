//
//  CoupanStoreViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 15/06/21.
//

import Foundation

class CoupanStoreViewModel: ObservableObject {

    @Published var loading = false
    
    func GetAllCoupansService(_ limit : Int, page : Int,  completion: @escaping(_ result : String?, _ responce : CoupanStoreResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "limit": limit,
                "pageNo" : page
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_coupons.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(CoupanStoreResultModel.self, from: apiData )
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
    
}
