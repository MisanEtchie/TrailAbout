//
//  RegisterView.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore 
import FirebaseAuth
import FirebaseStorage

struct RegisterView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var userBio: String = ""
    @State var userProfileData: Data?
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    //view properties
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    
    @State var isLoading: Bool = false
    
    //saved user dafualts
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored : String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        ViewThatFits {
            ScrollView(.vertical, showsIndicators: false) {
                registerBody
            }
            //registerBody
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker , selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue{
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self ) else {
                            return
                        }
                        
                        await  MainActor.run(body: {
                            userProfileData = imageData
                        })
                    } catch {
                        
                    }
                }
            }
        }
        .alert(  errorMessage, isPresented: $showError) { }
        
    }
    
    func registerUser () {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                try await Auth.auth().createUser(withEmail: emailID, password: password )
                
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfileData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ =  try await storageRef.putDataAsync(imageData)
                
                let downloadURL = try await storageRef.downloadURL()
                
                let user = User(username: username, userBio: userBio, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil {
                         print("Saved Succesfully")
                        userNameStored = username
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                    }
                })
                
                
                 
            } catch {
                try await Auth.auth().currentUser?.delete()
                await setError(error )
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

extension RegisterView {
    private var registerBody: some View {
        VStack (spacing: 10) {
            
            ZStack {
                if let userProfileData, let image = UIImage(data: userProfileData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("nullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }.frame(width: 100, height: 100)
                .clipShape(Circle())
                .contentShape(Circle())
                .onTapGesture {
                    showImagePicker.toggle()
                }
                .padding(.top, 20)
            
            Text("Start Exploring... ")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Sign up")
                .font(.title3)
                .hAlign(.leading)
            
            VStack (spacing: 12){
                
                TextField("Username", text: $username)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("About You", text: $userBio, axis: .vertical)
                    .frame(minHeight: 100, alignment: .top)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                
                
                Button("Forget Password") {
                    
                }
                .font(.callout)
                .fontWeight(.medium)
                .tint(.black)
                .hAlign(.trailing)
                
                
                Button(action: {
                    registerUser()
                }, label: {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                }).fillView(.black)
                    .disableWithOpacity(username == "" ||  userBio == "" || password == "" || emailID == "" || userProfileData == nil)
            }
            
            .padding(.top, 24)
            
            HStack() {
                Text("Don't have an account")
                    .foregroundColor(.gray)
                
                Button("Register Now")
                {dismiss()}
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .font(.callout)
            .vAlign(.bottom)
            
            
        }
        .vAlign(.top)
        .padding()
    }
}


#Preview {
    RegisterView()
}
