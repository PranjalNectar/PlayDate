
import SwiftUI

struct NavigationSection: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image("profileplaceholder")
            }
            Spacer()
            Button(action: {}) {
                Image("tinder-icon")
                    .resizable().aspectRatio(contentMode: .fit).frame(height:45)
            }
            
            Spacer()
            Button(action: {}) {
                Image("chats")
            }
        }.padding([.horizontal, .bottom])
    }
}

struct NavigationSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSection()
    }
}
