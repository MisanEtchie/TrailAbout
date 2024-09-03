//
//  LocationsView.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI
import MapKit


struct LocationsView: View {
    
    let accentColor = Color("AccentColor")
    
    //@StateObject private var vm = LocationsViewModel()
    @EnvironmentObject private var vm: LocationsViewModel
    
    var body: some View {
        ZStack{
            mapLayer
            
                .ignoresSafeArea()
            
            locationsPreviewStack
        }
        .sheet(item: $vm.sheetLocation) { location in
            LocationsDetailsView(location: location)
        }
    }
}










#Preview {
    LocationsView().environmentObject(LocationsViewModel())
    
}

#Preview {
    LocationsView().environmentObject(LocationsViewModel())
        .preferredColorScheme(.dark)
    
}

extension LocationsView {
    
    
    
    
    private var mapLayer: some View {
        
        
        
        Map(coordinateRegion: $vm.mapRegion, annotationItems:  vm.locations, annotationContent: { location in
            
            MapAnnotation(coordinate: location.coordinates) {
                
                
                let range = (vm.zoomLevelForDisplay * 0.1)
                
                if location != vm.mapLocation && abs(location.coordinates.latitude - vm.mapLocation.coordinates.latitude) < range &&
                    abs(location.coordinates.longitude - vm.mapLocation.coordinates.longitude) < range {
                    EmptyView()
                } else if (vm.zoomLevelForDisplay > 70 && vm.mapLocation != location) {
                    
                    EmptyView()
                    
                } else {
                    
                    LocationMapAnnotationView(location: location)
                        .scaleEffect(
                            vm.mapLocation == location
                            ?
                            1.0
                            :
                                (vm.zoomLevelForDisplay < 10) ?
                            0.7 : 0.4
                        )
                        .onTapGesture {
                            vm.showNextLocation(location: location)
                        }
                }
            }
            
            
        }
        )
        
    }
    
    private var locationsPreviewStack: some View {
        VStack (spacing: 0){
            
            header.padding(.horizontal, 12)
            
            Text(String(vm.zoomLevelForDisplay))
            
            Spacer()
            
            ZStack {
                
                
                ForEach (vm.locations) { location in
                    
                    if vm.mapLocation == location {
                        LocationsPreviewView(location: vm.mapLocation)
                            .padding()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        
                        
                    }
                }
            }
            
            //frame(height: 20)
            
            //LocationsPreviewView(location: vm.mapLocation).padding()
        }.padding(.bottom, 20)
    }
    
    private var header: some View {
        VStack {
            Button(action: vm.toggleLocationsList) {
                
                
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .animation(.none, value: vm.mapLocation )
                //.frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "chevron.down")
                            .padding().font(.headline)
                            .foregroundColor(.primary)
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                        
                    }
            }
            
            
            if (vm.showLocationsList) {
                LocationsListView()
            }
        }
        .background(.appWhite)
        .cornerRadius(12)
    }
}
