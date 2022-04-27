//
//  GetPremiumScreenViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 26/07/21.
//


import Foundation

class GetPremiumScreenViewModel: ObservableObject {
   

    @Published var loading = false
    
    /////////// Get Packages Api ////////////////////////
    func GetPackagesService(_ limit : Int, page : Int , completion: @escaping(_ result : String?, _ responce : GetPremiumResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "limit": limit,
                "pageNo" : page,
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_packages.url, parameters: params as NSDictionary) { ( result , data) in
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(GetPremiumResultModel.self, from: apiData )
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
