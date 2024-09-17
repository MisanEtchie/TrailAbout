//
//  LocationsListView.swift
//  TrailAbout
//
//  Created by Misan on 8/26/24.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    var body: some View {
        List {
            ForEach(vm.locations) { location in
                
                Button {
                    vm.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)
                }
                .padding(.vertical, 6)
                .listRowBackground(Color.clear)

               
               
                    
                
            }
        }.listStyle(PlainListStyle())
    }
}

#Preview {
    LocationsListView().environmentObject(LocationsViewModel())
}


extension LocationsListView {
    private func listRowView (location: Location) -> some View {
        HStack{
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .cornerRadius(7)
            }
            
            VStack (alignment: .leading) {
                Text(location.name).font(.footnote)
                Text(location.cityName).font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.red)
                
        }
    }
}
