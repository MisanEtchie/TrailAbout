//
//  TrailAboutApp.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI
import Firebase

@main
struct TrailAboutApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    @AppStorage("log_status") var logStatus: Bool = false
    
    init() {
        FirebaseApp.configure() 
    }
    
    var body: some Scene {
        WindowGroup {
            
            if logStatus {
                MainView()
            } else {
                LogInView()
            }
            
            //ContentView()
            //LogInView()
            //LocationsView().environmentObject(vm)
        }
    }
}
