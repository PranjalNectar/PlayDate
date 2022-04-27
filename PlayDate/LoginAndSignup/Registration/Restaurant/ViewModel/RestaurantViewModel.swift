//
//  RestaurantViewModel.swift
//  PlayDate
//
//  Created by Pallavi Jain on 10/05/21.
//


import Foundation

class RestaurantViewModel: ObservableObject {
    
    @Published var loading = false
    
    func callRestaurantApi(limit:String,pageNo:String,filter:String,completion: @escaping(_ result : String?, _ responce : MyRestaurantResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = ["filter": filter,
                          "limit" : limit,
                          "pageNo" : pageNo
            ] as [String : Any]

            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_business_restaurants.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(MyRestaurantResultModel.self, from: apiData )
                        
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
    
    
//    func callUserProfileApi(parameters:String,type: String,completion: @escaping (UserProfileModel) -> ()) {
//        Webservice().getUserProfileMethod(url: EndPoints.updateProfile.url, parameters: parameters, type: type) {  (data) in
//            do {
//                
//                let result = try JSONDecoder().decode(UserProfileModel.self, from: data)
//                
//                completion(result)
//            } catch {
//                
//                
//                completion(UserProfileModel.init(status: 0, message: "Invalid Data"))
//                
//                print("ERROR:", error)
//            }
//        }
//    }
//    
    func callUserProfileApi(parameters:String,type:String,completion: @escaping(_ result : String?, _ responce : UserProfileModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            
            var params : [String : Any] = [:]
            let userId = UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
            
            if type == "relationship"{
                params = ["userId":userId,
                          "relationship" : parameters
                ]
            }else if type == "interested"{
                params = ["userId":userId,
                          "interested" : parameters
                ]
            }else if type == "restaurants"{
                params = ["userId":userId,
                          "restaurants" : parameters
                ]
            }else if type == "gender"{
                params = ["userId":userId,
                          "gender" : parameters
                ]
            }else if type == "interestedIn"{
                params = ["userId":userId,
                          "interestedIn" : parameters
                ]
            }else if type == "birthDate"{
                params = ["userId":userId,
                          "birthDate" : parameters
                ]
               
            }else if type == "personalBio"{
                params = ["userId":userId,
                          "personalBio" : parameters
                ]
            }else if type == "usertype"{
                params = ["userId":userId,
                          "usertype" : SharedPreferance.getAppUserType()
                ]
            }
           
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.updateProfile.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(UserProfileModel.self, from: apiData )
                        
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

//    func callRestaurantApi(filter:String,completion: @escaping ([MyRestaurantDataModel]) -> ()) {
//        Webservice().getRestaurant(url: EndPoints.getRestaurent.url,filter:filter) { restaurant in
//            print(restaurant.data)
//
//            completion(restaurant.data)
//        }
//    }
