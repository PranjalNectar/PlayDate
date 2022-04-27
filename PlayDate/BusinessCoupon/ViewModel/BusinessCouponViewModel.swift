//
//  BusinessCouponViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 22/07/21.
//

import Foundation


class BusinessCouponViewModel: ObservableObject {
    
    @Published var loading = false
    
    /////////// Get Coupon ////////////////////////
    func GetCouponService(_ limit : Int, page : Int, status : String, completion: @escaping(_ result : String?, _ responce : BusinessCouponModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            //self.loading = true
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "limit"  : limit,
                "pageNo" : page,
                "status" : status
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_business_coupons.url, parameters: params as NSDictionary) { ( result , data) in
               // self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(BusinessCouponModel.self, from: apiData )
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
    
 
    
    func CreateCouponService(_ urlParams : String, imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : AddMediaModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.add_business_coupon.url + urlParams)
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.add_business_coupon.url + urlParams, parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "couponImage", check: "image") { (result, data) in
                
                self.loading = false
               
                if result != strResult.Network.rawValue{
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(AddMediaModel.self, from: apiData )
                        //self.media = result.data
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
    
    
    func UpdateCouponService(_ urlParams : String, imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : AddMediaModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.add_business_coupon.url + urlParams)
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.update_business_coupon.url + urlParams, parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "couponImage", check: "image") { (result, data) in
                
                self.loading = false
               
                if result != strResult.Network.rawValue{
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(AddMediaModel.self, from: apiData )
                        //self.media = result.data
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
    
    
    
    
    func DeleteCouponService(_ CouponId : String, completion: @escaping(_ result : String?, _ responce : BusinessCouponModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            //self.loading = true
            let params = [
                "couponId" : CouponId
            ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.delete_business_coupon.url, parameters: params as NSDictionary) { ( result , data) in
               // self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(BusinessCouponModel.self, from: apiData )
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
