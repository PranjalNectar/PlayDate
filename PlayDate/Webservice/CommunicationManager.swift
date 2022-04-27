//
//  CommunicationManager.swift
//
//


import UIKit
import MobileCoreServices
import SystemConfiguration

class CommunicationManager: NSObject {
 
    let notificationName = Notification.Name("login")
    let defaults = UserDefaults.standard
    
    // MARK: - GET/Json
    func getResponseFor(strUrl : String, parameters: NSDictionary? , completion:@escaping (_ result: String, _ data : AnyObject)->()) {
        
        let request = NSMutableURLRequest(url: URL(string: strUrl)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if parameters != nil {
            var data : Data?
            do {
                data = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions(rawValue: 0))
                request.httpBody = data
            } catch {
                data = Data()
            }
        }
        
        self.callWebservice(request as URLRequest?) { (responseData) in
            
            DispatchQueue.main.async(execute: {
              // if responseData is NSDictionary {
                    // handle data here1
                    if  responseData["status"] != nil {
                        
                        let status = String(describing: responseData["status"] as AnyObject).lowercased()
                        
                        if status == "success" || status == "true" || status == "1"  {
                            completion("success", responseData as AnyObject)
                        }
                        else if status == "failed" || status == "false" || status == "0" {
                            if responseData["message"] as? String != nil{
                                completion("error", responseData as AnyObject)
                            }
                        }
                    } else {
                        //call back else case
                        completion("Network", "Something went wrong." as AnyObject)
                    }
               // }
            })
        }
    }

    
    // MARK: - Get/ Query param
    func getResponseForQueryParam(StrUrl : String, parameters: String, completion:@escaping (_ result: String, _ data : AnyObject)->()) {
        
        var serviceStr = "\(StrUrl)\(parameters)"
        serviceStr = serviceStr.replacingOccurrences(of: " ", with: "%20")

        
        let request = NSMutableURLRequest(url: URL(string: serviceStr)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let secretKey = SharedPreference.authToken()
        //        if AppTheme.getIsUserLogin() {
        //            let secretKey = AppTheme.getSecretKey()
        //request.setValue(secretKey, forHTTPHeaderField: "authorization")
        //        }

        
        self.callWebservice(request as URLRequest?) { (responseData) in
            
            DispatchQueue.main.async(execute: {
               // if responseData is NSDictionary {
                    // handle data here1
                    if  responseData["status"] != nil {
                        
                        let status = String(describing: responseData["status"] as AnyObject).lowercased()
                        
                        if status == "success" || status == "true" {
                            completion("success", responseData as AnyObject)
                        } else if status == "1001" {
                            print("Version Update")
                            //AppTheme.versionUpdated()
                        } else if status == "failed" || status == "false" || status == "0" {
                            
                            if let responceMsg : NSError = responseData["message"] as? NSError {
                                let data : NSMutableDictionary = responseData as! NSMutableDictionary
                                data["message"] = responceMsg.localizedDescription
                                
                                completion("error", data as AnyObject)
                            } else {
                                
                                if responseData["message"] as! String == "Invalid Token" {
                                   // AppTheme.tokenExpired()
                                } else {
                                    completion("error", responseData as AnyObject)
                                }
                            }
                        }
                    } else {
                        //call back else case
                        completion("error", "Something went wrong." as AnyObject)
                    }
               // }
            })
        }
    }
    
    
    
    // MARK: - Post/Json
    func getResponseForPost(strUrl : String, parameters: NSDictionary? , completion:@escaping (_ result: String, _ data : AnyObject)->()) {
        
        let request = NSMutableURLRequest(url: URL(string: strUrl)!)
        let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.token)
        let headerToken = "Bearer \(token ?? "")"
        request.setValue(headerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    
        if parameters != nil {
            var data : Data?
            do {
                data = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions(rawValue: 0))
                request.httpBody = data
            } catch {
                data = Data()
            }
        }
        self.callWebservice(request as URLRequest?) { (responseData) in
            
            DispatchQueue.main.async(execute: {
               // if responseData is NSDictionary {
                    // handle data here1
                    if  responseData["status"] != nil {
                        
                        let status = String(describing: responseData["status"] as AnyObject).lowercased()
                       
                        if status == "success" || status == "true" || status == "1"  {
                            completion("success", responseData as AnyObject)
                        }
                        else if status == "failed" || status == "false" || status == "2" {
                            if responseData["message"] as? String != nil{
                                completion("error", responseData as AnyObject)
                            }
                        }
                        else if status == "failed" || status == "false" || status == "0" {
                            if responseData["message"] as? String != nil{
                                 completion("error", responseData as AnyObject)
                            }
                        }
                    } else {
                        //call back else case
                        completion("Network", "Something went wrong." as AnyObject)
                    }
               // }
            })
        }
    }
    
    // MARK: - Post/Param
    func getResponseForParamType(strUrl : String, parameters: NSDictionary?, completion:@escaping (_ result: String, _ data : AnyObject)->()) {
        
        let body = NSMutableData()
        let request = NSMutableURLRequest(url: NSURL(string: strUrl)! as URL)
        let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.token)
        let headerToken = "Bearer \(token ?? "")"
        request.setValue(headerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let boundary = generateBoundaryString()
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data( "--\(boundary)\r\n".utf8))
                body.append(Data( "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data( "\(value)\r\n".utf8))
            }
        }
        body.append(Data( "--\(boundary)--\r\n".utf8))
        request.httpBody = body as Data
        
        self.callWebservice(request as URLRequest?) { (responseData) in
            DispatchQueue.main.async(execute: {
                //if responseData is NSDictionary {
                    // handle data here1
                    if  responseData["ok"] != nil {
                        
                        let status = String(describing: responseData["ok"] as AnyObject).lowercased()
                        
                        if status == "success" || status == "true" || status == "1"  {
                            completion("success", responseData as AnyObject)
                        }
                        else if status == "failed" || status == "false" || status == "0" {
                            if responseData["message"] as? String != nil{
                                completion("error", responseData as AnyObject)
                            }
                        }
                    } else {
                        //call back else case
                        completion("Network", "Something went wrong." as AnyObject)
                    }
//                } else {
//                    //call back else case
//                    completion("Network", "Something went wrong." as AnyObject)
//                }
            })
        }
    }
    
    // MARK: - Post/Param (Multipart- Image)
    //My function for sending data with image
    func getResponseForMultipartType(strUrl : String, parameters: NSDictionary?, mediaData : [Data], mediaKey: String , check : String,  completion:@escaping (_ result: String, _ data : AnyObject)->()) {
        //filePath
        let request = NSMutableURLRequest(url: NSURL(string: strUrl)! as URL)
        let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.token)
        let headerToken = "Bearer \(token ?? "")"
        request.setValue(headerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let boundary = generateBoundaryString()
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(parameters: parameters, imageKey: mediaKey , imageData: mediaData, boundary: boundary, check : check) as Data
        self.callWebservice(request as URLRequest?) { (responseData) in
            
            DispatchQueue.main.async(execute: {
              //  if responseData is NSDictionary {
                    // handle data here1
                    if  responseData["status"] != nil {
                        
                        let status = String(describing: responseData["status"] as AnyObject).lowercased()
                        
                        if status == "success" || status == "true" || status == "1"  {
                            completion("success", responseData as AnyObject)
                        }
                        else if status == "failed" || status == "false" || status == "0" {
                            if responseData["message"] as? String != nil{
                                completion("error", responseData as AnyObject)
                            }
                        }
                    } else {
                        //call back else case
                        completion("Network", "Something went wrong." as AnyObject)
                    }
//                } else {
//                    //call back else case
//                    completion("Network", "Something went wrong." as AnyObject)
//                }
            })
            
        }
    }
    
    func createBodyWithParameters(parameters: NSDictionary?, imageKey: String, imageData: [Data], boundary: String, check : String) -> NSData {
        
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
    
        var name = ""
        var filename = ""
        var mimetype = ""
        if !imageData.isEmpty {
            for i in 0...imageData.count-1 {
                if !imageData[i].isEmpty {
                    
                    if check == "image"{
                        filename = "feed\(i).jpg"
                        mimetype = "image/png"
                    }else if check == "profilevideo"{
                        filename = "profilevideo\(i).mp4"
                        mimetype = "video/mp4"
                    }else if check == "chat_image"{
                        filename = "chat\(i).jpg"
                        mimetype = "image/png"
                    }else if check == "chat_video"{
                        filename = "chatvideo\(i).mp4"
                        mimetype = "video/mp4"
                    }else if check == "audio"{
                        filename = "chataudio\(i).m4a"
                        mimetype = "audio/m4a"
                    }else{
                        filename = "feed\(i).mp4"
                        mimetype = "video/mp4"
                    }

                    name = imageKey
                    body.append(Data( "--\(boundary)\r\n".utf8))
                    body.append(Data( "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".utf8))
                    body.append(Data( "Content-Type: \(mimetype)\r\n\r\n".utf8))
                    body.append(imageData[i] as Data)
                    body.append(Data( "\r\n".utf8))
                    body.append(Data( "--\(boundary)--\r\n".utf8))
                }
            }
        }
        
//        if !arrimageData.isEmpty {
//            for i in 0...arrimageData.count-1 {
//                if !arrimageData[i].isEmpty {
//                    let filename = "user-profile\(i).jpg"
//                    let mimetype = "image/jpg"
//
//                    if check == "profile"{
//                        name = arrimageKey
//                    }
//
//                    body.append(Data( "--\(boundary)\r\n".utf8))
//                    body.append(Data( "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".utf8))
//                    body.append(Data( "Content-Type: \(mimetype)\r\n\r\n".utf8))
//                    body.append(arrimageData[i] as Data)
//                    body.append(Data( "\r\n".utf8))
//                    body.append(Data( "--\(boundary)--\r\n".utf8))
//                }
//            }
//        }
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    
    func downloadImage(fromURL: URL,completion:@escaping (_ responseData : AnyObject) -> ()) {
        let task = URLSession.shared.dataTask(with: fromURL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                let errorDictionary = NSMutableDictionary()
              //  errorDictionary.setValue("0", forKey: WebServiceKey.Status.rawValue)
               // errorDictionary.setValue(error!.localizedDescription, forKey: WebServiceKey.Message.rawValue)
                completion(errorDictionary)
            } else {
                completion(data as AnyObject)
            }
        })
        task.resume()
    }
    
   
    func callWebservice(_ request: URLRequest!, completion:@escaping (_ responseData : NSDictionary) -> ()) {
        
        let task = URLSession.shared
            .dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                if (error != nil) {
                    print(error!.localizedDescription)
                    let errorDictionary = NSMutableDictionary()
                    completion(errorDictionary)
                } else {
                    do {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments)//(rawValue: 0))
                        completion((parsedJSON as AnyObject) as! NSDictionary)
                    } catch let JSONError as NSError {
                        let errorDictionary = NSMutableDictionary()
                        print(JSONError)
                        completion(errorDictionary)
                    }
                }
            })
        task.resume()
    }
    
    func showAlert(title:String , message : String , cancelButtonTitle:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
    
}


public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            /* Only Working for WIFI
             let isReachable = flags == .reachable
             let needsConnection = flags == .connectionRequired
             
             return isReachable && !needsConnection
             */
            
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
            
            return ret
            
        }
    
}
