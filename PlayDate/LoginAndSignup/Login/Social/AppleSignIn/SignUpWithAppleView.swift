
import SwiftUI
import AuthenticationServices

struct SignUpWithAppleView: UIViewRepresentable {
    
    @Binding var name : String
    
    func makeCoordinator() -> AppleSignUpCoordinator {
        return AppleSignUpCoordinator(self)
    }
    
    func makeUIView(context: Context) -> UIButton {
        //Creating the apple sign in button
        
//        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
//                                                  authorizationButtonStyle: .whiteOutline)
//
        //let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        let button = UIButton()
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    
        
        //Adding the tap action on the apple sign in button
        button.addTarget(context.coordinator,
                         action: #selector(AppleSignUpCoordinator.didTapButton),
                         for: .touchUpInside)
            
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
    }
}
