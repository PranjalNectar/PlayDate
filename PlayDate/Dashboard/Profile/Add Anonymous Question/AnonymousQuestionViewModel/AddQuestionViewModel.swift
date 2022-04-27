//
//  AddQuestionViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 02/06/21.
//

import Foundation


class AddQuestionViewModel: ObservableObject {
    @Published var loading = false
    
    func AddPostQuestionService(_  postType: String, txtQuestion: String,colorCode: String, emojiCode : String, location : String, completion: @escaping(_ result : String?, _ responce : AddPostFeedModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "postType" : postType,
                "tag" : txtQuestion,
                "colorCode":colorCode,
                "emojiCode": emojiCode,
                "location" : location
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_post_feed.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(AddPostFeedModel.self, from: apiData )
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
}
