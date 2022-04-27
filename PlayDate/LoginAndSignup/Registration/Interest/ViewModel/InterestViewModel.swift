//
//  InterestViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/05/21.
//

import Foundation

class InterestListViewModel: ObservableObject {
    @Published var loading = false

    func callInterestApi(limit:String,pageNo:String,filter:String,completion: @escaping(_ result : String?, _ responce : MyInterestResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["filter": filter,
                          "limit" : limit,
                          "pageNo" : pageNo
            ] as [String : Any]

            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.getInterested.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(MyInterestResultModel.self, from: apiData )
                        
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
