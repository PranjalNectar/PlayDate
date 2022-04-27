//
//  DateRestaurantViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 11/06/21.
//

import Foundation



class DateRestaurantViewModel: ObservableObject {
    
    @Published var loading = false

    func GetDateRestaurantListService(_ lat : String, long : String, completion: @escaping(_ result : String?, _ responce : DateRestaurantModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                //"userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
                                "lat": lat,
                                "long" : long
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_restaurant_details.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    
                    DispatchQueue.main.async { 
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(DateRestaurantModel.self, from: apiData )
                           
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
