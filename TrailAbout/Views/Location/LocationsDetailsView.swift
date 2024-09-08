//
//  LocationsDetailsView.swift
//  TrailAbout
//
//  Created by Misan on 8/29/24.
//

import SwiftUI
import MapKit

struct LocationsDetailsView: View {
    
    let location: Location
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    @State private var fetchedPosts: [Post] = []
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                detailsImage
                
               
                
                VStack{
                    
                    HStack {
                        detailsTitle
                        
                        mapDetail
                    }
                    
                    Divider().padding(.top, 18).padding(.bottom, 12)
                    
                    //statusButtons
                    
                    detailsContent
                    
                    
                    
                    
                    
                }.padding()
                
                Text("Posts from here")
                    .font(.title)
                    .fontWeight(.bold)
                    .hAlign(.leading)
                    .padding()
                
                ReusablePostView(posts: $fetchedPosts, basedOnLocation: true, locationName: location.name, cityName: location.cityName)
                
                    .padding(.bottom, 60)
                
                
                
                
                
            }
            
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}



extension LocationsDetailsView {
    private var detailsImage: some View {
        TabView {
            ForEach(location.imageNames , id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    
    private var detailsTitle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var detailsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
            
            if let url = URL(string: location.link) {
                
                Link(destination: url) {
                               HStack {
                                   Image(systemName: "arrow.up.forward.app")
                                       .font(.headline)
                                       .foregroundColor(.blue)
                                   Text("Read more...")
                                       .font(.headline)
                                       .foregroundColor(.blue)
                               }
                               .padding(.vertical, 6)
                               .padding(.horizontal, 16)
                               
                               .background(Color.blue.opacity(0.2))
                               .cornerRadius(26)
                           }
                
                
            }
            
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statusButtons: some View {
        HStack {
                    // "Visited" Button
                    Button(action: {
                        //selectedStatus = .visited
                    }) {
                        Text("🤩 Visited")
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor"))
                            .foregroundColor(.white )
                            .cornerRadius(25)
                    }

                    // "Wants to Go" Button
                    Button(action: {
                       
                    }) {
                        Text("🧳 Want to Go")
                            .fontWeight(.medium)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor( .white )
                            .cornerRadius(25)
                    }
                }
        .padding(.horizontal, 15)
    }
    
    private var mapDetail: some View {
        
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: location.coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))),
            
            annotationItems: [location]
        ) {
            location in
            
            MapAnnotation(coordinate: location.coordinates) { LocationMapAnnotationView(location: location).scaleEffect(0.6)}
        }
        .allowsHitTesting(false)
        .frame(width: 100, height: 100)
        .cornerRadius(12)
        //.aspectRatio(1, contentMode: .fill)
        
        
    }
    
    
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label : {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .padding()
        }
    }
}


#Preview {
    LocationsDetailsView(location: LocationsDataService.locations[2]).environmentObject(LocationsViewModel())
}


