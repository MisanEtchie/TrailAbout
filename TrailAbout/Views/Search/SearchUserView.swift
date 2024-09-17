//
//  SearchUserView.swift
//  TrailAbout
//
//  Created by Misan on 9/13/24.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct SearchUserView: View {
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment (\.dismiss) private var dismiss
    var body: some View {
        
        List {
            ForEach(fetchedUsers) {user in
                NavigationLink {
                    ReusableProfileView(user: user)
                } label : {
                    
                    HStack {
                        
                        WebImage(url: user.userProfileURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        
                        
                        Text(user.username)
                            .font(.callout)
                            .hAlign(.leading)
                        
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search Users")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        
        .onSubmit(of: .search, {
            Task {
                await searchUsers()
            }
        })
        
        .onChange(of: searchText) { newValue in
            Task {
                await searchUsers()
            }
        }
        
        .onAppear {
                   Task {
                       await searchUsers() // Fetch all users when the view appears
                   }
               }
        //
        
        
    }
    
    func searchUsers() async {
        do {
            if searchText.isEmpty {
                // Fetch all users if search text is empty
                let documents = try await Firestore.firestore().collection("Users").getDocuments()
                let users = try documents.documents.compactMap { doc -> User? in
                    try doc.data(as: User.self)
                }
                await MainActor.run {
                    fetchedUsers = users
                }
            } else {
                let queryLowerCase = searchText.lowercased()
                let queryUpperCase = searchText.uppercased()
                
                let documents = try await Firestore.firestore().collection("Users")
                    .whereField("username", isGreaterThanOrEqualTo: queryUpperCase)
                    .whereField("username", isLessThanOrEqualTo: "\(queryLowerCase)\u{f8ff}")
                    .getDocuments()
                
                let users = try documents.documents.compactMap { doc -> User? in
                    try doc.data(as: User.self)
                }
                
                await MainActor.run(body: {
                    fetchedUsers = users
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SearchUserView()
}
