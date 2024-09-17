//
//  PostCardView.swift
//  TrailAbout
//
//  Created by Misan on 9/6/24.
//v

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import FirebaseStorage

struct PostCardView: View {
    var post: Post
    @EnvironmentObject private var vm: LocationsViewModel
    
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListener: ListenerRegistration?
    
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    var body: some View {
        HStack (alignment: .top, spacing: 10) {
            
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            
            
            VStack (alignment: .leading, spacing: 6) {
                
                HStack (spacing: 0){
                    Text("\(post.username) • ")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(post.locationStatus == .visited ? "visited" : "wants to go")
                        .font(.footnote)
                    
                }
                
                Button {
                    vm.sheetLocation = vm.locations.first { $0.name == post.locationName }
                    
                } label: {locationTag}
                
                if let postImageURL = post.imageURL {
                    
                    WebImage(url: postImageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity) // Take up all available width
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .padding(.bottom, 4)
                }

                
                    
                
                Text(post.text )
                    .font(.callout)
                    .fontWeight(.semibold)
                
                
                HStack  {
                    
                    Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    
                    likedbutton//.hAlign(.trailing)
                        .padding(.vertical, 6)
                }
                .hAlign(.trailing)
            }
        }
        .hAlign(.leading)
        .overlay (alignment: .topTrailing, content:  {
            if post.userUID == userUID {
                Menu {
                    Button("Delete Post", role: .destructive, action: deletePost)
                    
                } label : {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                //.offset(x: 8)
            }
        })
        .onAppear {
            if docListener == nil{
                guard let postID = post.id else {return}
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({snapshot,
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
        .onDisappear {
            if let docListener {
                docListener.remove()
                self.docListener = nil
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
    
    func deletePost () {
        Task {
            do {
                if post.imageReferenceID != nil {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID!).delete()
                }
                guard let postID = post.id else {return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
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
