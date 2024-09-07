//
//  MainView.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var vm = LocationsViewModel()
    @State private var selectedTab: Tab = .locations
    
    enum Tab {
        case feed
        case locations
        case account
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: selectedTab == .feed ? "rectangle.portrait.on.rectangle.portrait.angled.fill" : "rectangle.portrait.on.rectangle.portrait.angled")
                    //Text("Feed")
                }
                .tag(Tab.feed)
            
            LocationsView().environmentObject(vm)
            
                .tabItem {
                    Image(systemName: selectedTab == .locations ? "map.fill" : "map")
                    //Text("Locations")
                }
                .tag(Tab.locations)
            
            ProfileView()
                
                .tabItem {
                    Image(systemName: selectedTab == .account ? "person.circle.fill" : "person.circle")
                        
                    //Text("Account")
                }
            
                .tag(Tab.account)
        }
        .accentColor(Color("AccentColor")) // The color for the selected tab
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "InverseColor") // Set the color for unselected tabs
        }
       
    }
}

#Preview {
    MainView()
}
