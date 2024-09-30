//
//  ReusablePostView.swift
//  TrailAbout
//
//  Created by Misan on 9/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct ReusablePostView: View {
    @Binding var posts: [Post]
    var basedOnLocation : Bool = false
    var locationName: String?
    var cityName: String?
    
    var basedOnUUID: Bool = false
    var uuID: String?
    
    var showProfileLink: Bool = false
    
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    //
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        Text(
                            basedOnLocation ?
                            "No posts in this location\n\nBe the first!" :
                                basedOnUUID ? "No posts" :
                                "No posts found"
                        )
                        .multilineTextAlignment(.center)
                        
                        .foregroundStyle(.gray)
                    } else {
                        VStack {
                            
                            
                            Posts()
                        }
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            guard !basedOnLocation else {return}
            isFetching = true
            posts = []
            //
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else {return}
            await fetchPosts()
        }
    }
    
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView (post: post, showProfileLink: showProfileLink) { updatedPost in
                
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
                    posts[index].likedIDs = updatedPost.likedIDs
                }
                
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll{post.id == $0.id}
                }
            }
            .onAppear {
                if post.id == posts.last?.id && paginationDoc != nil {
                    //print("Fetch new posts")
                    Task {await fetchPosts()}
                }
            }
            
            Divider()
                .padding(.horizontal, 15)
                .padding(.bottom)
            
        }
    }
    
    func fetchPosts() async {
        do {
            var query: Query!
            
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 5)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 5)
            }
            
            if basedOnLocation {
                query = query
                    .whereField("locationName", isEqualTo: locationName)
            }
            
            if basedOnUUID {
                query = query
                    .whereField("userUID", isEqualTo: uuID)
            }
            
            
            
            let docs = try await query.getDocuments()
            
            
            
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            
            print(fetchedPosts)
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts )
                paginationDoc = docs.documents.last
                isFetching = false
            })
            print(posts)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

//extension ReusablePostView {
//    private var userStats: some View {
//        HStack {
//            
//            let totalLikes = posts.reduce(0) { result, post in
//                result + post.likedIDs.count
//            }
//            
//            let uniquePlaces = Set(posts.map { post in
//                post.locationName
//            }).count
//            
//            
//            VStack{
//                Text(String(uniquePlaces))
//                    .font(.title)
//                    .fontWeight(.heavy)
//                
//                Text("Places")
//                    .font(.subheadline)
//            }
//                .font(.footnote)
//                .fontWeight(.medium)
//                .padding(.vertical, 8)
//                .frame(maxWidth: .infinity)
//            //.background(Color("AccentColor"))
//                .foregroundColor(Color("InverseColor"))
//                .background(.ultraThinMaterial)
//                .cornerRadius(20)
//            
//            VStack{
//                Text(String(totalLikes))
//                font(.title)
//                .fontWeight(.heavy)
//                
//                Text("Likes")
//                    .font(.subheadline)
//            }
//                .font(.footnote)
//                .fontWeight(.medium)
//                .padding(.vertical, 8)
//                .frame(maxWidth: .infinity)
//            //.background(Color("AccentColor"))
//                .foregroundColor(Color("InverseColor"))
//                .background(.ultraThinMaterial)
//                .cornerRadius(20)
//        }
//    }
//}

#Preview {
    MainView()
}
