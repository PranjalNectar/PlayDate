//
//  SceneDelegate.swift
//  PlayDate
//
//  Created by Pallavi Jain on 19/04/21.
//

import UIKit
import SwiftUI
import AuthenticationServices


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var settings = UserSettings()
    private(set) static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //Check whether user is already signup or not
        // self.sessionController = SessionController(context: self.persistentContainer.viewContext)
        Self.shared = self
        if let userID = UserDefaults.standard.object(forKey: "userId") as? String {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { (state, error) in
                
                DispatchQueue.main.async {
                    switch state
                    {
                    case .authorized: // valid user id
                        self.settings.authorization = 1
                        break
                    case .revoked: // user revoked authorization
                        self.settings.authorization = -1
                        break
                    case .notFound: //not found
                        self.settings.authorization = 0
                        break
                    default:
                        break
                    }
                }
            }
        }
        
        // Create the SwiftUI view that provides the window contents.+
        //  var contentView = OnboardingView()
       
        
        let controller = UserDefaults.standard.string(forKey: Constants.UserDefaults.controller)
        
        //  let  UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.isLogin)
        let isLogin = UserDefaults.standard.bool(forKey: Constants.UserDefaults.isLogin)
        if isLogin{
            let  contentView =  NavigationView { BottomMenuView() }
            
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = HostingController(wrappedView: contentView)
                self.window = window
                window.makeKeyAndVisible()
            }
        }else {
           UserDefaults.standard.setValue(false, forKey: Constants.UserDefaults.backButton)
            if controller == "birthDate"{
                let  contentView = NavigationView { Age(comingFromEdit:.constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "gender"{
                let contentView = NavigationView { UserGenderView(comingFromEdit:.constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "relationship"{
                let contentView = NavigationView { Relationship(comingFromEdit:.constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "genderInterest"{
                let contentView = NavigationView { GenderInterest(comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "username"{
                let contentView = NavigationView { Username (comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "personalBio"{
                let contentView = NavigationView { PersonalBio(comingFromEdit: .constant(false),coupleid:.constant(""), relationship: .constant("")) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "uploadImage"{
                let contentView = NavigationView { UploadImage(comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "ineterstList"{
                let contentView = NavigationView { Interest(comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "restaurant"{
                let contentView = NavigationView { Restaurant(comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "profileVideoPath"{
                let contentView = NavigationView { RecordProfileVideo(comingFromEdit: .constant(false), isNewVideo: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
            else if controller == "businessPhoto"{
                let contentView = NavigationView { BusinessPhotoView(comingFromEdit: .constant(false)) }
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
            else if controller == "dashboard"{
                let contentView = NavigationView { BottomMenuView() }
                
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else if controller == "login"{
                UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                let contentView = NavigationView { LoginView() }
                
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }else {
                UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.backButton)
                let  contentView = OnboardingView()
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = HostingController(wrappedView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
        }
        
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        newAppearance.backgroundColor = .clear
        newAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = newAppearance
        
        if SharedPreferance.getAppDarkTheme(){
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = .dark
        }else{
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = .light
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}


struct StatusBarStyleKey: PreferenceKey {
  static var defaultValue: UIStatusBarStyle = .default
  
  static func reduce(value: inout UIStatusBarStyle, nextValue: () -> UIStatusBarStyle) {
    value = nextValue()
  }
}

class HostingController: UIHostingController<AnyView> {
  var statusBarStyle = UIStatusBarStyle.default

  //UIKit seems to observe changes on this, perhaps with KVO?
  //In any case, I found changing `statusBarStyle` was sufficient
  //and no other method calls were needed to force the status bar to update
  override var preferredStatusBarStyle: UIStatusBarStyle {
    statusBarStyle
  }

  init<T: View>(wrappedView: T) {
// This observer is necessary to break a dependency cycle - without it
// onPreferenceChange would need to use self but self can't be used until
// super.init is called, which can't be done until after onPreferenceChange is set up etc.
    let observer = Observer()

    let observedView = AnyView(wrappedView.onPreferenceChange(StatusBarStyleKey.self) { style in
      observer.value?.statusBarStyle = style
    })

    super.init(rootView: observedView)
    observer.value = self
  }

  private class Observer {
    weak var value: HostingController?
    init() {}
  }

  @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
    // We aren't using storyboards, so this is unnecessary
    fatalError("Unavailable")
  }
}

extension View {
  func statusBar(style: UIStatusBarStyle) -> some View {
    preference(key: StatusBarStyleKey.self, value: style)
  }
}

struct ToggleModel {
    var isDark: Bool = true {
        didSet {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = isDark ? .dark : .light
            SharedPreferance.setAppDarkTheme(isDark)
        }
    }
}
