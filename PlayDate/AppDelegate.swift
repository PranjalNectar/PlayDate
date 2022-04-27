//
//  AppDelegate.swift
//  PlayDate
//
//  Created by Pallavi Jain on 19/04/21.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import GoogleSignIn
import FirebaseAuth

struct CredentialsConstant {
    static let applicationID:UInt = 92325
    static let authKey = "b-fMQWgrgEHnmjY"
    static let authSecret = "QQ3AE4xpCxGJuh9"
    static let accountKey = "h2Lamr-7G9BLQz-1gFDx"

}

struct TimeIntervalConstant {
    static let answerTimeInterval: TimeInterval = 60.0
    static let dialingTimeInterval: TimeInterval = 5.0
}

struct AppDelegateConstant {
    static let enableStatsReports: UInt = 1
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    let gcmMessageIDKey = "gcm.Message_ID"
    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
      
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        application.applicationIconBadgeNumber = 0
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Logging out from chat.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Logging out from chat.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Logging in to chat.
      
    }
    
 
    func application(
           _ app: UIApplication,
           open url: URL,
           options: [UIApplication.OpenURLOptionsKey : Any] = [:]
       ) -> Bool {

           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )
        return GIDSignIn.sharedInstance().handle(url)

       }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
        let state = application.applicationState
        switch state {
        
        case .inactive:
            print("Inactive")
            
        case .background:
            print("Background")
            // update badge count here
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
            
        case .active:
            print("Active")
            application.applicationIconBadgeNumber = 0
            
        @unknown default: break
            
        }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let devicetokenString = deviceToken.hexString
        saveDeviceToken(deviceToken: "\(devicetokenString)")
        print(devicetokenString)
    }
}


extension NSNotification {
    static let googleLogin = NSNotification.Name.init("GoogleLogin")
    static let appleLogin = NSNotification.Name.init("AppleLogin")
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        
       // saveDeviceToken(deviceToken: "\(fcmToken ?? "")")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    
    
    
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
                
    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)
    
    
    NotificationCenter.default.post(name: Notification.Name("PushNotification"), object: nil, userInfo: userInfo)

    completionHandler()
  }
}
extension AppDelegate : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if  error != nil {
        //print(error?.localizedDescription)
        return
      }

        guard user.authentication != nil else { return }
   //   let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                     //   accessToken: authentication.accessToken)
      // ...
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        //Logging to Firebase...
        
        Auth.auth().signIn(with: credential) { (res, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            //User Logged in Successfully
            
            //Sending Notification to UI...
            
           // NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
            var info = [String : Any]()
            info["email"] = res?.user.email
            info["sourceSocialId"] = res?.user.uid
            info["sourceType"] = "Google"
        
            NotificationCenter.default.post(name: NSNotification.googleLogin, object: nil, userInfo: ["info":info])
            //print(res?.user.email)
            
        }
        
        func call(completion: @escaping (User) -> ()) {
            
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
extension Data {
    var hexString : String {
        let hexString = map { String(format: "%02.2hhx", $0)}.joined()
        return hexString
    }
}

