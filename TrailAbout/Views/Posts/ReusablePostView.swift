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
    @State var isFetching: Bool = true
    //
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if posts.isEmpty {
                        Text("No posts found")
                            .foregroundStyle(.gray)
                    } else {
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            isFetching = true
            posts = []
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
                
            } onDelete: {
                
            }
            
            Divider()
                .padding(.horizontal, 15)

        }
    }
    
    func fetchPosts() async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            
            let docs = try await query.getDocuments()
            
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts = fetchedPosts
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
