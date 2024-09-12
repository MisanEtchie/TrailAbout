//
//  ProfileView.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile {
                    ReusableProfileView(user: myProfile)
                    
                        .refreshable {
                            self.myProfile = nil
                            await fetchUserData()
                        }
                        
                }
                else {
                    ProgressView()
                }
            }
            .refreshable {
                myProfile = nil
                await fetchUserData()
            }
            
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        
                        Button ("Logout", action: logOutUser)
                        
                        Button ("Delete Account", role: .destructive, action: deleteAccount)
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {
            
        }
        .task {
            if myProfile != nil {return}
            await fetchUserData()
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else {return}
        
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
        
    }
    
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                
                let reference = Storage.storage().reference().child("Profile_Image").child(userUID)
                
                try await reference.delete()
                
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                
                try await Auth.auth().currentUser?.delete()
                
                logStatus = false
            } catch {
                
            }
        }
    }
    
    func setError (_ error: Error) async {
        await MainActor.run(body: {
            errorMessage =  error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

#Preview {
    ProfileView()
}
