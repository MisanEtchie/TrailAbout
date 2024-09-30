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
            mapLayer.ignoresSafeArea()
            
            locationsPreviewStack
        }
        .sheet(item: $vm.sheetLocation) { location in
            LocationsDetailsView(location: location)
        }
        .sheet(isPresented: $vm.createNewPost) {
            CreateNewPost(onPost: {post in
                vm.recentPosts.insert(post, at: 0 )
            }, location: vm.mapLocation, selectedStatus: vm.status)
        }
        .sheet(isPresented: $vm.showLocationsSearch) {
            SearchLocationView()
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
            
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                
                
                let range = (vm.zoomLevelForDisplay * 0.05)
                
                if location != vm.mapLocation && abs(location.latitude - vm.mapLocation.latitude) < range &&
                    abs(location.longitude - vm.mapLocation.longitude) < range {
                    EmptyView()
                } 
                
                else if (vm.zoomLevelForDisplay > 70 && vm.mapLocation != location) {
                    
                    //EmptyView()
                    
                    Text("•").fontWeight(.bold)
                        .foregroundColor(Color("AccentColor"))
                    
                    
                } else {
                    
                    LocationMapAnnotationView(location: location)
                        .scaleEffect(
                            
                            
                            vm.mapLocation == location
                            ?
                            
                                (vm.zoomLevelForDisplay < 10) ?
                             1.0 :
                                
                                0.7
                            :
                                (vm.zoomLevelForDisplay < 10) ?
                            0.7 :   (vm.zoomLevelForDisplay < 50) ? 0.4 : 0.2
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
            
            //Text(String(vm.zoomLevelForDisplay))
            
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
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .lineLimit(1) // Limit text to one line
                            .truncationMode(.tail) // Truncate with an ellipsis at the end
                            .animation(.none, value: vm.mapLocation)
                            .frame(maxWidth: .infinity)
                            .overlay(alignment: .leading) {
                                Image(systemName: "chevron.down")
                                    .padding()
                                    .bold()
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                            }
                            .overlay(alignment: .trailing) {
                                Button(action: vm.toggleLocationsSearch) {
                                    Image(systemName: "magnifyingglass")
                                        .padding()
                                        .bold()
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                }
                            }
                
//                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
//                    .font(.footnote)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 12)
//                    .lineLimit(1) // Limit text to one line
//                    .truncationMode(.tail)
//                    .animation(.none, value: vm.mapLocation )
//                //.frame(height: 55)
//                    .frame(maxWidth: .infinity)
//                    .overlay(alignment: .leading) {
//                        Image(systemName: "chevron.down")
//                            .padding().font(.footnote)
//                            .foregroundColor(.primary)
//                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
//                        
//                    }
            }
            
            
            if (vm.showLocationsList) {
                LocationsListView()
            }
        }
        .background(.appWhite)
        .cornerRadius(30)
    }
}
