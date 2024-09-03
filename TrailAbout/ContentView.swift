////
////  ContentView.swift
////  TrailAbout
////
////  Created by Misan on 8/25/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var vm = LocationsViewModel()
//    @AppStorage("log_status") var logStatus: Bool = false
//    //
//    var body: some View {
//        if logStatus {
//            LocationsView().environmentObject(vm)
//        } else {
//            LogInView()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
