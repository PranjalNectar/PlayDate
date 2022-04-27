//
//  UploadImageViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 01/06/21.
//

import Foundation

class UploadImageViewModel: ObservableObject {
    
    @Published var loading = false

    func UploadProfielImageService(_ imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : NSDictionary?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.updateProfileImage.url)
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.updateProfileImage.url, parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "userProfilePic", check: "image") { (result, data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    if(result == "success") {
                        let dataDict = data as! NSDictionary
                        print(dataDict)
                        completion(strResult.success.rawValue,dataDict, nil)
                    }
                    else if (result == "error") {
                        //completion(strResult.error.rawValue,response, nil)
                    }
                }else{
                    completion(strResult.Network.rawValue,nil, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue,nil, nil)
        }
    }
    
    
    func UploadBusinessImageService(_ imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : NSDictionary?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.add_business_image.url)
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.add_business_image.url, parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "userBusinessImage", check: "image") { (result, data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    if(result == "success") {
                        let dataDict = data as! NSDictionary
                        print(dataDict)
                        completion(strResult.success.rawValue,dataDict, nil)
                    }
                    else if (result == "error") {
                        //completion(strResult.error.rawValue,response, nil)
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
