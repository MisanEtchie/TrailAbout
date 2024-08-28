//
//  TrailAboutApp.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI

@main
struct TrailAboutApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView().environmentObject(vm)
        }
    }
}
