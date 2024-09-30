//
//  LocationMapAnnotationView.swift
//  TrailAbout
//
//  Created by Misan on 8/28/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct LocationMapAnnotationView: View {
    
    //@EnvironmentObject private var vm: LocationsViewModel
    
    let accentColor = Color("AccentColor")
    
    let location: Location
    
    var body: some View {
        VStack (spacing: 0) {
            
//            if let imageName = location.imageNames[1] ?? location.imageNames.first {
//                
//                WebImage(url: URL(string: imageName))
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 45)
//                    .cornerRadius(12)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding(3)
//                    .background(accentColor)
//                    .cornerRadius(15)
//            }
            
            if let imageName = location.imageNames.first //(location.imageNames.count > 1 ? location.imageNames[1] : location.imageNames.first) 
            {
                WebImage(url: URL(string: imageName))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(12)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(3)
                    .background(accentColor)
                    .cornerRadius(15)
            }

            
//            if let imageName = location.imageNames[1] ?? location.imageNames.first
//            {
//                Image(imageName//systemName: "map.circle.fill"
//                )
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 45, height: 45)
//                    .cornerRadius(12)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding(3)
//                    .background(accentColor)
//                    .cornerRadius(15)
//            }
            
            
            
            
            Image(systemName: "triangle.fill")
               
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 70)
            
            
                
                
            
            
        }//.background(Color.blue)
    }
}

//#Preview {
//    LocationMapAnnotationView(location: LocationsDataService.locations.first!)//.environmentObject(LocationsViewModel())
//}
