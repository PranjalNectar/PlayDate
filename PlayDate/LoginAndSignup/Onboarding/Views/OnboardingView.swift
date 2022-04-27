
import SwiftUI

struct OnboardingView: View {
    
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "couple1", bg: "grayBG")),
        UIHostingController(rootView: Subview(imageString: "couple1", bg: "grayBG")),
        UIHostingController(rootView: Subview(imageString: "couple1", bg: "grayBG"))
    ]
    
    var titles = ["Take some time out", "Lets Go for Date", "Create a peaceful mind"]
    
    var captions =  ["Take your time out and bring awareness into your everyday life", "Meditating helps you dealing with anxiety and other psychic problems", "Regular medidation sessions creates a peaceful inner mind"]
    
    @State private var offset: CGFloat = -200.0
    @State var currentPageIndex = 0
    @State private var animationAmount: CGFloat = 1
    @State var zoomed = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                
                PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                
                VStack(spacing:10) {
                    
                    Image("PlayDate")
                        .padding(.top,60)
                    Spacer()
                    VStack(alignment:.center,spacing:20) {
                        Text(titles[currentPageIndex])
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text(captions[currentPageIndex])
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(3)
                    }
                    .padding()
                    
                    PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                    
                    Button(action: {
                        
                        if self.currentPageIndex+1 == self.subviews.count {
                            self.currentPageIndex = 0
                        } else {
                            self.currentPageIndex += 1
                        }
                    }) {
                        
                        TestPulseColorView()
                    }
                    .padding(.bottom,50)
                }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        
        .edgesIgnoringSafeArea(.all)
    }
}



#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
#endif
