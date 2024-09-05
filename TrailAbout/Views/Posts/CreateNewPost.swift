//
//  CreateNewPost.swift
//  TrailAbout
//
//  Created by Misan on 9/4/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct CreateNewPost: View {
    var onPost: (Post) -> ()
    var location: Location
    @State var selectedStatus: LocationStatus
    
    @State private var postText: String = ""
    @State private var postImageData: Data?
    
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userNameStored : String = ""
    @AppStorage("user_UID") private  var userUID: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack {
            
            VStack {
                HStack {
                    Menu {
                        
                        Button("Cancel", role: .destructive) {
                            dismiss()
                        }
                        
                    } label : {
                        Text("Cancel")
                            .font(.callout)
                        //.foregroundColor(.black)
                    }
                    .hAlign(.leading)
                    
                    
                    Button (action: createPost) {
                        Text("Post")
                            .font(.callout)
                            .foregroundColor(Color("appWhite"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 6)
                            .background(Color("InverseColor"), in: Capsule())
                    }
                    .disableWithOpacity(postText == "")
                    
                }
                
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    Rectangle()
                        .fill(.gray.opacity(0.05))
                        .ignoresSafeArea()
                }//Hstack
                
                ScrollView (.vertical, showsIndicators: false) {
                    
                    locationHeader
                        .padding(.top, 18)
                    
                    statusButtons
                    
                    addPostBody
                    
                }
                
                Divider()
                
                HStack {
                    Button {
                        showImagePicker.toggle()
                    } label : {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title3)
                            
                            Text("Post a picture of your trip")
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                        
                        //.foregroundColor(.black)
                    }.hAlign(.leading)
                    
                    Button("Done") {
                        showKeyboard = false
                    }
                    
                }
                .foregroundColor(Color("InverseColor"))
                .padding(15)
            }
            
        }
        .vAlign(.top)
        .photosPicker(isPresented: $showImagePicker , selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue{
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self ),
                              
                                let image = UIImage(data: imageData),
                              let compressedImageData = image.jpegData(compressionQuality: 0.5)
                                
                        else {
                            return
                        }
                        
                        
                        await  MainActor.run(body: {
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    } catch {
                        
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func createPost () {
        isLoading = true
        showKeyboard = false
        
        Task {
            do {
                
            } catch {
                
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage =  error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

extension CreateNewPost {
    private var locationHeader: some View {
        HStack (spacing: 16) {
            ZStack{
                if let imageName = location.imageNames.first
                {
                    Image(imageName)
                        .resizable()
                    
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                }
            }
            .padding(6)
            .background(Color.white)
            .cornerRadius(26)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(location.cityName)
                
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("AccentColor").opacity(0.2))
        )
        .cornerRadius(25)
        .padding(.horizontal, 15)
    }
    
    private var addPostBody: some View {
        
            VStack (spacing: 15) {
                
                TextField(selectedStatus == .visited ? "Tell us how your visit was..." : "What do you love about this place...", text: $postText, axis: .vertical)
                    .font(.title3)
                    .frame(minHeight: 120) // Adjust the height to show up to 4 lines
                    //.lineLimit(4)
                    .focused($showKeyboard)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(25)
                
                if let postImageData, let image = UIImage(data: postImageData) {
                    GeometryReader{
                        let size = $0.size
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    withAnimation(.easeIn(duration: 0.25)) {
                                        self.postImageData = nil
                                    }
                                } label : {
                                    Image(systemName: "trash")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .tint(.white)
                                        .padding(8)
                                        .background(Color.red.opacity(0.8))
                                        .cornerRadius(20)
                                }
                                .padding(10)
                            }
                    }
                    .clipped()
                    .frame(height: 200)
                }
            }
            .padding(15)
        
    }
    
    
    private var statusButtons: some View {
        HStack {
                    // "Visited" Button
                    Button(action: {
                        selectedStatus = .visited
                    }) {
                        Text("🤩 Visited")
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedStatus == .visited ? Color("AccentColor") : Color.gray.opacity(0.2))
                            .foregroundColor(selectedStatus == .visited ? .white : .black)
                            .cornerRadius(25)
                    }

                    // "Wants to Go" Button
                    Button(action: {
                        selectedStatus = .wantsToGo
                    }) {
                        Text("🧳 Want to Go")
                            .fontWeight(.medium)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(selectedStatus == .wantsToGo ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedStatus == .wantsToGo ? .white : .black)
                            .cornerRadius(25)
                    }
                }
        .padding(.horizontal, 15)
            }
    
}

#Preview {
    CreateNewPost(onPost: {_ in}, location: Location(
        name: "Trevi Fountain",
        cityName: "Rome",
        region: .southernEurope,
        type: .tourism,
        coordinates: CLLocationCoordinate2D(latitude: 41.9009, longitude: 12.4833),
        description: "The Trevi Fountain is a fountain in the Trevi district in Rome, Italy, designed by Italian architect Nicola Salvi and completed by Giuseppe Pannini and several others. Standing 26.3 metres high and 49.15 metres wide, it is the largest Baroque fountain in the city and one of the most famous fountains in the world.",
        imageNames: [
            "rome-trevifountain-1",
            "rome-trevifountain-2",
            "rome-trevifountain-3",
        ],
        link: "https://en.wikipedia.org/wiki/Trevi_Fountain"),
                  selectedStatus: .wantsToGo
    )//.preferredColorScheme(.dark)
}
