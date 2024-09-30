//
//  SplashScreen.swift
//  TrailAbout
//
//  Created by Misan on 9/28/24.
//

import SwiftUI

struct ViewCoordinator: View {
    @State private var isActive = false
    @AppStorage("log_status") var logStatus: Bool = false
    //
    var body: some View {
        if isActive {
            if logStatus == true {
                MainView()
            } else {
                LogInView()
            }
        }else {
            SplashScreen(isActive: $isActive)
        }
    }
}

struct SplashScreen: View {
    @State private var scale = 1.0
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            
            Image("Splash") // Replace with the image name in your assets
                        .resizable()
                        .scaledToFill() // Ensures the image fills the screen
                        .ignoresSafeArea()
               
            .scaleEffect(scale)
            .onAppear{
                withAnimation(.easeIn(duration: 0.5)) {
                    self.scale = 1.3
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
