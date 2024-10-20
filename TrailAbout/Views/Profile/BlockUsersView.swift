//
//  BlockUsersView.swift
//  TrailAbout
//
//  Created by Misan on 10/14/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct BlockUsersView: View {
    var blockedUserUIDs: [String]

    @State private var blockedUsers: [User] = []
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode

    @State private var showConfirmationAlert = false
    @State private var userToUnblock: User?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if blockedUsers.isEmpty {
                    Text("You have not blocked any users.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(blockedUsers) { user in
                            HStack {
                                WebImage(url: user.userProfileURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.callout)
                                        .hAlign(.leading)

                                    NavigationLink(destination: ReusableProfileView(user: user)) {
                                        EmptyView()
                                    }
                                    .frame(width: 0, height: 0)
                                    .hidden()
                                }
                                .padding(.vertical, 6)

                                Spacer()

                                Button(action: {
                                    userToUnblock = user
                                    showConfirmationAlert = true
                                }) {
                                    Text("Unblock")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Blocked Users")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                Task {
                    await fetchBlockedUsers()
                }
            }
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Unblock User"),
                    message: Text("Are you sure you want to unblock \(userToUnblock?.username ?? "this user")?"),
                    primaryButton: .destructive(Text("Unblock"), action: {
                        if let userUID = userToUnblock?.userUID {
                            unblockUser(blockedUserUID: userUID)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }

    // Function to unblock the user and update UI accordingly
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
                    // Update the blocked users list by removing the unblocked user
                    self.blockedUsers.removeAll { $0.userUID == blockedUserUID }
                    print("User unblocked successfully.")
                }
            }
        }
    }

    // Function to fetch blocked users from Firestore
    func fetchBlockedUsers() async {
        guard !blockedUserUIDs.isEmpty else {
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        var users: [User] = []

        for uid in blockedUserUIDs {
            do {
                let document = try await db.collection("Users").document(uid).getDocument()
                if let user = try? document.data(as: User.self) {
                    users.append(user)
                }
            } catch {
                print("Error fetching user \(uid): \(error.localizedDescription)")
            }
        }

        await MainActor.run {
            self.blockedUsers = users
            self.isLoading = false
        }
    }
}
