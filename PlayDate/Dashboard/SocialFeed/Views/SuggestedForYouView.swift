//
//  SuggestedForYouView.swift
//  PlayDate
//
//  Created by Pallavi Jain on 25/04/21.
//

import SwiftUI
struct SocialFeedListModel: Identifiable {
    let id: Int
    let imageView: String
    let name: String
}
struct SocialFeedListListView: View {
    let postImages: SocialFeedListModel
    let postName: SocialFeedListModel
    var body: some View {
        VStack(alignment: .center ,spacing: 12) {
            Image(postImages.imageView)
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.top , 10)
                .padding(.leading , 10)
                .padding(.trailing , 0)
                .clipShape(Circle())
            
            Text(postImages.name)
                .foregroundColor(.black)
                .frame(width: 60, alignment: .center)
                .padding(.leading , 10)
                .padding(.trailing , 0)
        }
       
    }
}
struct SuggestedForYouView: View {
    let data: [SocialFeedListModel] = [
        .init(id: 0, imageView: "Ellipse 185" , name: "aaa"),
        .init(id: 1, imageView: "user1", name: "bbb"),
        .init(id: 2, imageView: "user2", name: "ccc"),
        .init(id: 3, imageView: "user3", name: "ddd"),
        .init(id: 4, imageView: "user1", name: "eee"),
        .init(id: 5, imageView: "user3", name: "fff"),
        .init(id: 6, imageView: "user1", name: "ggg"),
        .init(id: 7, imageView: "user2", name: "hhh")
    ]
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(data, id: \.id) { post in
                     
                        SocialFeedListListView(postImages: post, postName: post)
                          
                    }
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
    }
}
struct SuggestedForYouView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestedForYouView()
            .previewLayout(.sizeThatFits)
    }
}
