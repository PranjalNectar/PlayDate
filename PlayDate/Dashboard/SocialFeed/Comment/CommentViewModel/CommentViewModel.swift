//
//  CommentViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 28/05/21.
//

import Foundation

class CommentViewModel: ObservableObject {
    @Published var loading = false
    @Published var isSelected = false
    
    func AddPostCommentService(_ postId : String, comment : String,completion: @escaping(_ result : String?, _ response : AddPostFeedModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "comment" : comment
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.add_post_comment.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let responce = try JSONDecoder().decode(AddPostFeedModel.self, from: apiData )
                        if responce.status != 0{
                            completion(strResult.success.rawValue,responce, nil)
                        }else{
                            completion(strResult.error.rawValue,responce, nil)
                        }
                    }catch (let error){
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
    
    func GetPostCommentsService(_ postId : String,completion: @escaping(_ result : String?, _ response : GetCommentModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "postId": postId
            ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_post_comments.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let responce = try JSONDecoder().decode(GetCommentModel.self, from: apiData )
                        if responce.status != 0{
                            completion(strResult.success.rawValue,responce, nil)
                        }else{
                            completion(strResult.error.rawValue,responce, nil)
                        }
                    }catch (let error){
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
    
    func DeletePostCommentService(_ postId : String, commentId : String,completion: @escaping(_ result :String) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "commentId" : commentId
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.delete_post_comment.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                
                if(result == strResult.success.rawValue) {
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    completion(strResult.success.rawValue)
                }else if (result == strResult.error.rawValue) {
                    completion(strResult.error.rawValue)
                }else if (result == strResult.Network.rawValue) {
                    completion(strResult.Network.rawValue)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue)
        }
    }
    
    
    func ReportPostCommentService(_ postId : String, commentId : String,completion: @escaping(String,String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "commentId" : commentId
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.reported_post_comment.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false

                if(result == strResult.success.rawValue) {
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    let message = dataDict["message"] as! String
                    completion(strResult.success.rawValue, message)
                }else if (result == strResult.error.rawValue) {
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    let message = dataDict["message"] as! String
                    completion(strResult.error.rawValue,message)
                }else if (result == strResult.Network.rawValue){
                    completion(strResult.Network.rawValue, nil)
                }
            }
        }else{
            completion(strResult.NetworkConnection.rawValue, nil)
        }
    }
    
    func PostCommentOnOffService(postId : String, commentStatus : String,completion: @escaping(String) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "commentStatus" : commentStatus
                ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.post_comment_on_off.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
//                    do {
//                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
//                        let result = try JSONDecoder().decode(AddPostFeedModel.self, from: apiData )
//                        //self.media = result.data
//
//                        completion(result)
//                       // completion("success")
//                    }  catch {
//                        //completion(SocialFeedModel.CodingKeys.self)
//                        print("ERROR:", error)
//                    }
                
                if(result == "success") {
                    
                    let dataDict = data as! NSDictionary
                    print(dataDict)
                    
                    completion("success")
                }else if (result == "error") {
                    
                    //let dataDict = data as! NSDictionary
                    //Common.ShowAlert(Title: Common.Title, Message:dataDict.value(forKey: "message") as! String, VC: vc)
                    //completion("error")
                }else if (result == "server") {
                    
                    //let dataDict = data as! NSDictionary
                    //Common.ShowAlert(Title: Common.Title, Message:dataDict.value(forKey: "message") as! String, VC: vc)
                    //completion("error")
                }
            }
        }else{
            //Common.ShowAlert(Title: Common.Title, Message: AlertMessage.NetworkAlert, VC: vc)
        }
    }
  
    func PostCommentOnOffService(postId : String, commentStatus : String, completion: @escaping(_ result : String?, _ responce : PostCommentOnOffModel?, _ error : String?) -> ()) {
        self.loading = true

        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId":UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? "",
                "postId": postId,
                "commentStatus" : commentStatus
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.post_comment_on_off.url, parameters: params as NSDictionary) { ( result , data) in

                self.loading = false
                if result != strResult.Network.rawValue{
                    DispatchQueue.main.async {
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let responce = try JSONDecoder().decode(PostCommentOnOffModel.self, from: apiData )

                            if responce.status != 0{
                                completion(strResult.success.rawValue,responce, nil)
                            }else{
                                completion(strResult.error.rawValue,responce, nil)
                            }
                        }catch (let error){
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

