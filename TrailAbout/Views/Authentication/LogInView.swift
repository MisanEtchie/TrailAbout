//
//  LogInView.swift
//  TrailAbout
//
//  Created by Misan on 8/30/24.
//

import SwiftUI
 
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct LogInView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var createAccount: Bool = false
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    @State var isLoading: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored : String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Sign In To Trail About!")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Sign in top your account")
                .font(.title3)
                .hAlign(.leading)
            
            VStack (spacing: 12){
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button("Forget Password") {
                    resetPassword()
                }
                .font(.callout)
                .fontWeight(.medium)
                .tint(.black)
                .hAlign(.trailing)
                
                
                Button(action: {
                    loginUser()
                }, label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                }).fillView(.black)
            }.padding(.top, 24)
            
            HStack() {
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
               // createAccount.toggle()
                
                Button("Register Now")
                {
                    createAccount.toggle()
                }
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .font(.callout)
            .vAlign(.bottom)
            
            
        }
        .vAlign(.top)
        .padding()
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    
    func loginUser (){
        isLoading = true
        closeKeyboard()
        Task {
            do {
                try await
                Auth.auth().signIn(withEmail: emailID, password: password)
                print("User found...")
                try await fetchUser()
                logStatus = true
            } catch {
                await setError(error)
            }
        }
    }
    
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user =  try await  Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        print("tAG ALONG")
        
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
        
        
    }
    
    func resetPassword() {
        Task {
            do {
                try await
                Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link sent...")
            } catch {
                await setError(error)
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
    //RegisterView()
    LogInView()
}
