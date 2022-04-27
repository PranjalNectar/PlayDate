
import SwiftUI

struct Subview: View {
    
    var imageString: String
    var bg: String
    
    var body: some View {
        ZStack{
            Image(imageString)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            Image(bg)
                .resizable()
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

//"grayBG"
