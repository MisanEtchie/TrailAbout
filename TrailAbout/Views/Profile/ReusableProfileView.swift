//
//  ReusableProfileView.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ReusableProfileView: View {
    var user: User
    
    @State private var currentUser: User? = nil
    @State private var isBlocked: Bool = false
    @State private var showActionSheet = false
    @State private var fetchedPosts: [Post] = []
    @State private var isBlockedByUser: Bool = false
    //
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVStack {
                
               
                    
                    
                        WebImage(url: user.userProfileURL)
                            .resizable()
                        
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(80)
                            .padding(.top, 40)
                
                
                VStack(spacing: 12) {
                    
                    Text("@" + user.username)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(user.userBio).hAlign(.center)
                    //.font(.caption)
                        
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    userStats
                        .padding(.top, 32)
                    
                    Text("Posts")
                        .font(.title)
                        .fontWeight(.semibold)
                        .hAlign(.leading)
                    
                    
                }.padding(.horizontal, 24)
                    //.padding(.top, 12)
                    .padding(.bottom, 24)
                
                if isBlockedByUser {
                    Text("No posts to show.")
                        .foregroundColor(.gray)
                        .padding()
                } else if isBlocked {
                    Text("You have blocked this user.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ReusablePostView(posts: $fetchedPosts, basedOnUUID: true, uuID: user.userUID)
                }

               
                
                
            }
            
            .overlay(
                           Group {
                               if user.userUID != Auth.auth().currentUser?.uid {
                                   Button(action: {
                                       showActionSheet = true
                                   }) {
                                       Image(systemName: "ellipsis")
                                           .font(.caption)
                                           .foregroundColor(.black)
                                           .padding(8)
                                           .contentShape(Rectangle())
                                   }
                                   .actionSheet(isPresented: $showActionSheet) {
                                       ActionSheet(
                                           title: Text("User Options"),
                                           buttons: actionSheetButtons()
                                       )
                                   }
                               }
                           },
                           alignment: .topTrailing
                       )
            
        }.onAppear {
            fetchCurrentUser()
            fetchBlockedByUser()
        }
            }
    
    
    func fetchBlockedByUser() {
        Firestore.firestore().collection("Users").document(user.userUID)
            .getDocument { document, error in
                if let error = error {
                    print("Error fetching viewed user's blockedUsers: \(error)")
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    if let blockedUsers = data?["blockedUsers"] as? [String],
                       let currentUserUID = Auth.auth().currentUser?.uid {
                        self.isBlockedByUser = blockedUsers.contains(currentUserUID)
                    } else {
                        self.isBlockedByUser = false
                    }
                } else {
                    self.isBlockedByUser = false
                }
            }
    }

        
    
    func fetchCurrentUser() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").whereField("userUID", isEqualTo: userUID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching current user: \(error)")
                    return
                }
                if let document = snapshot?.documents.first {
                    self.currentUser = try? document.data(as: User.self)
                    // Check if the viewed user is blocked
                    if let blockedUsers = self.currentUser?.blockedUsers {
                        self.isBlocked = blockedUsers.contains(user.userUID)
                    }
                }
            }
    }
    
    
    func blockUserTapped() {
            if isBlocked {
                unblockUser(blockedUserUID: user.userUID)
            } else {
                blockUser(blockedUserUID: user.userUID)
            }
        }

    func blockUser(blockedUserUID: String) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        let currentUserRef = db.collection("Users").document(currentUserUID)
        let blockedUserRef = db.collection("Users").document(blockedUserUID)

        let batch = db.batch()

        // Update the current user's 'blockedUsers' array
        batch.updateData(["blockedUsers": FieldValue.arrayUnion([blockedUserUID])], forDocument: currentUserRef)

        // Update the blocked user's 'blockedBy' array
        batch.updateData(["blockedBy": FieldValue.arrayUnion([currentUserUID])], forDocument: blockedUserRef)

        batch.commit { error in
            if let error = error {
                print("Error blocking user: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.isBlocked = true
                    print("User blocked successfully.")
                }
            }
        }
    }


    func unblockUser(blockedUserUID: String) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        let currentUserRef = db.collection("Users").document(currentUserUID)
        let blockedUserRef = db.collection("Users").document(blockedUserUID)

        let batch = db.batch()

        // Remove from current user's 'blockedUsers' array
        batch.updateData(["blockedUsers": FieldValue.arrayRemove([blockedUserUID])], forDocument: currentUserRef)

        // Remove from blocked user's 'blockedBy' array
        batch.updateData(["blockedBy": FieldValue.arrayRemove([currentUserUID])], forDocument: blockedUserRef)

        // Commit the batch
        batch.commit { error in
            if let error = error {
                print("Error unblocking user: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.isBlocked = false
                    print("User unblocked successfully.")
                }
            }
        }
    }




}



extension ReusableProfileView{
    
    func actionSheetButtons() -> [ActionSheet.Button] {
           var buttons: [ActionSheet.Button] = []

           if isBlocked {
               buttons.append(.default(Text("Unblock User"), action: {
                   blockUserTapped()
               }))
           } else {
               buttons.append(.destructive(Text("Block User"), action: {
                   blockUserTapped()
               }))
           }

           buttons.append(.cancel())
           return buttons
       }
    
    private var userStats: some View {
            let totalLikes = calculateTotalLikes()
            let uniquePlaces = calculateUniquePlaces()
            
            return HStack {
                VStack {
                    Text(String(uniquePlaces))
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text(uniquePlaces == 1 ? "Place" : "Places")
                        .font(.subheadline)
                }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("InverseColor"))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                VStack {
                    Text(String(totalLikes))
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text(totalLikes == 1 ? "Like" : "Likes")
                        .font(.subheadline)
                }
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color("InverseColor"))
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
        }
        
        // Moved calculations to separate functions
        private func calculateTotalLikes() -> Int {
            return fetchedPosts.reduce(0) { result, post in
                result + post.likedIDs.count
            }
        }
        
        private func calculateUniquePlaces() -> Int {
            return Set(fetchedPosts.map { post in
                post.locationName
            }).count
        }
}


#Preview {
    ReusableProfileView(user: User(username: "Misanetc", userBio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", userUID: "0dXsFkyW9cNBVxQ0ro0G6 up7fe54", userEmail: "misanetc@1243.com", userProfileURL: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/trailabout.appspot.com/o/Profile_Images%2F0dXsFkyW9cNBVxQ0ro0G6up7fe53?alt=media&token=1c579df4-9345-42fc-b5bd-ca6ad88efe57")!))
}
