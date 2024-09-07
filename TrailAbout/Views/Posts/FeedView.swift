//
//  FeedView.swift
//  TrailAbout
//
//  Created by Misan on 9/6/24.
//

import SwiftUI

struct FeedView: View {
   
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack{
                ReusablePostView(posts: $vm.recentPosts)
                
            }
            .navigationTitle("Feed")
        }
        
    }
}

//#Preview {
//    FeedView()
//}
