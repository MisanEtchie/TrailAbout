//
//  LocationsView.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI
import MapKit


struct LocationsView: View {
    
    //@StateObject private var vm = LocationsViewModel()
    @EnvironmentObject private var vm: LocationsViewModel
    
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.1983, longitude: -111.6513),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        //        List {
        //            ForEach(vm.locations) {
        //                Text($0.name)
        //            }
        //        }
        ZStack{
            Map(coordinateRegion: $vm.mapRegion )
                .ignoresSafeArea()
            
            VStack (spacing: 0){
                
                header.padding(.horizontal, 12)
                
                Spacer()
            }
        }
    }
}

#Preview {
    LocationsView().environmentObject(LocationsViewModel())
}

extension LocationsView {
    private var header: some View {
        VStack {
            Button(action: vm.toggleLocationsList) {
                
          
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .animation(.none, value: vm.mapLocation)
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
         .background(.white)
        .cornerRadius(12)
    }
}
