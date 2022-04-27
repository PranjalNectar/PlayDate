//
//  ProfileViewModel.swift
//  PlayDate
//
//  Created by Pranjal on 24/05/21.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var loading = false

    func AddMediaService(_ sectiontype : String, mediatype : String, imgData : Data, check : String, completion: @escaping(_ result : String?, _ responce : AddMediaModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [:] as [String : Any]
            
            print(params)
            print(EndPoints.add_media.url + "?section=\(sectiontype)&mediaType=\(mediatype)")
            CommunicationManager().getResponseForMultipartType(strUrl: EndPoints.add_media.url + "?section=\(sectiontype)&mediaType=\(mediatype)", parameters: params as NSDictionary, mediaData: [imgData], mediaKey: "mediaFeed", check: mediatype) { (result, data) in
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
    
    
    func AddPostFeedService(_ location : String, mediaId : String, postType: String, txtdescription: String,friendtag: String, completion: @escaping(_ result : String?, _ responce : AddPostFeedModel?, _ error : String?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            let params = [
                "location":location,
                "mediaId": mediaId,
                "postType" : postType,
                "tag" : txtdescription,
                "tagFriend":friendtag
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
    
    func GetProfileDetailService(userID:String,comeFromProfileTab:Bool,  completion: @escaping(_ result : String?, _ responce : ProfileDetailModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            var userIDS = ""
            if comeFromProfileTab{
                userIDS = UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
            }else {
                userIDS = userID
            }
            let params = [
                "userId":userIDS
            ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_profile_details.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(ProfileDetailModel.self, from: apiData )
                        
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
    
    func GetMyFeedService(_ limit : Int, page : Int,userId:String,comeFromProfileTab:Bool, completion: @escaping(_ result : String?, _ responce : SocialFeedModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            var userIDS = ""
            if comeFromProfileTab{
                userIDS = UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
            }else {
                userIDS = userId
            }
            let params = [
                "userId" : userIDS,
                "limit": limit,
                "pageNo" : page
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_my_post_feed.url, parameters: params as NSDictionary) { ( result , data) in
                
                if result != strResult.Network.rawValue{
                        do {
                            let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                            let response = try JSONDecoder().decode(SocialFeedModel.self, from: apiData )
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
    
    func GetSaveGalleryService(_ limit : Int, page : Int, completion: @escaping(_ result : String?, _ responce : ProfileSaveGalleryModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let params = [
                "userId" : UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
//                "limit": limit,
//                "pageNo" : page
                ] as [String : Any]
            
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_post_save_gallery.url, parameters: params as NSDictionary) { ( result , data) in
                
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(ProfileSaveGalleryModel.self, from: apiData )
                        // print("JSON", result.data.fullName)
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
    
    func GetCoupleProfileDetailService(userID:String,comeFromProfileTab:Bool,  completion: @escaping(_ result : String?, _ responce : CoupleProfileResultModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            var userIDS = ""
            if comeFromProfileTab{
                userIDS = UserDefaults.standard.string(forKey: Constants.UserDefaults.userId) ?? ""
            }else {
                userIDS = userID
            }
            let params = [
                "userId":userIDS
            ] as [String : Any]
            print(params)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.get_couple_profile.url, parameters: params as NSDictionary) { ( result , data) in
                self.loading = false
                if result != strResult.Network.rawValue{
                    do {
                        let apiData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        let response = try JSONDecoder().decode(CoupleProfileResultModel.self, from: apiData )
                        
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
    
    func callUpdateCoupleProfileApi(parameters:[String:Any],completion: @escaping(_ result : String?, _ responce : UserProfileModel?, _ error : String?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            self.loading = true
            
           
            print(parameters)
            CommunicationManager().getResponseForPost(strUrl: EndPoints.update_couple_profile.url, parameters: parameters as NSDictionary) { ( result , data) in
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
