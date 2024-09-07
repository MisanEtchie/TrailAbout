//
//  PostCardView.swift
//  TrailAbout
//
//  Created by Misan on 9/6/24.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import FirebaseStorage

struct PostCardView: View {
    var post: Post
    
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            
            
            VStack (alignment: .leading, spacing: 6) {
                Text(post.username)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(post.text )
                    .font(.callout)
                    .fontWeight(.semibold)
                
                if let postImageURL = post.imageURL {
                    GeometryReader {
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    }
                    .frame(height: 300)
                }
                
                HStack  {
                    locationTag
                    
                    likedbutton//.hAlign(.trailing)
                        .padding(.vertical, 6)
                }.hAlign(.trailing)
            }
        }
        .hAlign(.leading)
        .onAppear {
            if docListener == nil{
                guard let postID = post.id else {return}
                docListener = Firestore.firestore().collection("Users").document(postID).addSnapshotListener({snapshot,
                error in
                    if let snapshot {
                        if snapshot.exists {
                            if let updatedPost = try? snapshot.data(as: Post.self) {
                                onUpdate(updatedPost)
                            }
                        } else {
                            onDelete()
                        }
                    }
                })
            }
        }
    }
    
    func likePost () {
        Task {
            guard let postID = post.id else  {return}
            if post.likedIDs.contains(userUID) {
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
            else {
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
}

extension PostCardView {
    private var likedbutton: some View {
        
        Button (action: likePost) {
                
                HStack (spacing: 6) {
                    Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                    Text("\(post.likedIDs.count)")
                }
                .font(.caption)
                .foregroundColor(.pink)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(20)
            }
        
    }
    
    private var locationTag: some View {
        
            //Text("\(post.likedIDs.count)")
        
        Text(post.locationName + ", " + post.locationCity)
            .font(.caption)
        .foregroundColor(Color("AccentColor"))
        .padding(.vertical, 6)
        .padding(.horizontal, 18)
        .background(Color("AccentColor").opacity(0.1))
        .cornerRadius(20)
    }
}
