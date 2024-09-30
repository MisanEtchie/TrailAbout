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
    @State private var offset: CGFloat = 0

    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored : String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        ZStack {
            
            Image("TrailAboutLogIn") // Replace with the image name in your assets
                        .resizable()
                        .scaledToFill() // Ensures the image fills the screen
                        .ignoresSafeArea()
            
            VStack (spacing: 10) {
                
                
               
                
                Spacer()
                
                VStack (spacing: 12){
                    
                    VStack (spacing: 0) {
                        Text("Sign In To Trail About!")
                            .font(.largeTitle.bold())
                            //.hAlign(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            

                        
                        Text("Sign in top your account")
                            .font(.title3.bold())
                            //hAlign(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.bottom, 10)

                    
                    TextField("Email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                    
                    SecureField("Password", text: $password)
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
                    
                    HStack() {
                        Text("Don't have an account?")
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
                    
                }.padding(.vertical, 24)
                    .vAlign(.bottom)
                    
                
                
                //.vAlign(.bottom)
                
                
            }
            .vAlign(.top)
            .padding()
            .offset(y: -offset) // Move the view up based on the offset when keyboard appears
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                withAnimation {
                                    offset = keyboardFrame.height / 2 // Adjust this value based on how far up you want the view to move
                                }
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                            withAnimation {
                                offset = 0 // Reset view position when keyboard hides
                            }
                        }
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .fullScreenCover(isPresented: $createAccount){
                RegisterView()
            }
        .alert(errorMessage, isPresented: $showError, actions: {})
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Allow keyboard to overlap
                .onTapGesture {
                    hideKeyboard() // Tap anywhere to dismiss keyboard
                }
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
        
        //print(user)
        
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



#Preview {
    //RegisterView()
    LogInView()
}
