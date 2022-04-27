
import SwiftUI
import AuthenticationServices

class AppleSignUpCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignUpWithAppleView?
    @Published var name: String = ""
    init(_ parent: SignUpWithAppleView) {
        self.parent = parent
        super.init()
    }
    
    @objc func didTapButton() {
        //Create an object of the ASAuthorizationAppleIDProvider
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //Create a request
        let request         = appleIDProvider.createRequest()
        //Define the scope of the request
        request.requestedScopes = [.fullName, .email]
        //Make the request
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        //Assingnig the delegates
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
    
    //If authorization is successfull then this method will get triggered
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization)
    {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credentials not found....")
            return
        }
        
        //Storing the credential in user default for demo purpose only deally we should have store the credential in Keychain
        let defaults = UserDefaults.standard
        defaults.set(credentials.user, forKey: "userId")
        // parent?.name = "\(credentials.fullName?.givenName ?? "")"
        
        print(credentials.email ?? "")
        print(credentials.fullName?.givenName ?? "")
        print(credentials.fullName?.familyName ?? "")
        print(credentials.user)  // This is a user identifier
        print(credentials.identityToken?.base64EncodedString() ?? "") //JWT Token
        
        var info = [String : Any]()
        info["email"] = credentials.email ?? ""
        info["sourceSocialId"] = credentials.user
        info["sourceType"] = "Apple"
        
        NotificationCenter.default.post(name: NSNotification.appleLogin, object: nil, userInfo: ["info":info])
    }
    
    //If authorization faced any issue then this method will get triggered
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        //If there is any error will get it here
        print("Error In Credential")
    }
}
