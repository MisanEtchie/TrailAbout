//
//  LoadingView.swift
//  TrailAbout
//
//  Created by Misan on 9/1/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous ))
                }
            }
        }
            .animation(.easeIn(duration: 0.25), value: show)
    }
}

 
