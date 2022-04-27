//
//  RecordVideoViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 31/05/21.
//

import Foundation

class RecordProfileVideoViewModel: ObservableObject {
    
    @Published var loading = false

    func RecordProfileVideoService(_ imgData : Data, completion:@escaping(_ result : String?, _ responce : RecordProfileVideoModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.update_profile_video.url, parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "userProfileVideo", check: "profilevideo") { (result, data) in
                self.loading = false
                
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(RecordProfileVideoModel.self, from: apiData )
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
