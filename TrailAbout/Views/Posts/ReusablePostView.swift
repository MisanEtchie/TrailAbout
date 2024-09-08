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
                            .foregroundStyle(.gray)
                    } else {
                        Posts()
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
            PostCardView (post: post) { updatedPost in
                
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
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts )
                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

#Preview {
    MainView()
}
