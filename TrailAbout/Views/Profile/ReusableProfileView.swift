//
//  ReusableProfileView.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileView: View {
    var user: User
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
                    
                    Text(user.userBio)
                    //.font(.caption)
                        
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }.padding(.horizontal, 24)
                    .padding(.top, 12)
                
                
                Text("Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .hAlign(.leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

            }
            
        }
    }
}

#Preview {
    ReusableProfileView(user: User(username: "Misanetc", userBio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", userUID: "0dXsFkyW9cNBVxQ0ro0G6 up7fe54", userEmail: "misanetc@1243.com", userProfileURL: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/trailabout.appspot.com/o/Profile_Images%2F0dXsFkyW9cNBVxQ0ro0G6up7fe53?alt=media&token=1c579df4-9345-42fc-b5bd-ca6ad88efe57")!))
}
