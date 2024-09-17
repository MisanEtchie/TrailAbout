//
//  SearchLocationView.swift
//  TrailAbout
//
//  Created by Misan on 9/14/24.
//

import SwiftUI

struct SearchLocationView: View {
    @EnvironmentObject var vm: LocationsViewModel
    @State private var searchText: String = ""
    @State private var fetchedLocations: [Location] = []
    @State private var selectedRegion: String? = nil
    
    var regions: [String: [Location]] {
            Dictionary(grouping: vm.locations, by: { $0.region })
        }
    
    var body: some View {
        NavigationStack {
            VStack {
                //                SearchBar(text: $searchText)
                //                    .padding()
                //Text("Searching for \(searchText)")
                
                if searchText.isEmpty {
                    // Group locations by region and display regions
                    List {
                        ForEach(regions.keys.sorted(), id: \.self) { region in
                            Section(header: Text(region)) {
                                ForEach(regions[region] ?? []) { location in
                                    Button(action: {
                                        vm.showNextLocation(location: location)
                                        vm.showLocationsSearch = false
                                    }) {
                                        listRowView(location: location)
                                    }
                                }
                            }
                        }
                    }.listStyle(PlainListStyle())
                } else {
                    
                    List {
                        ForEach(fetchedLocations) {location in
                            Button(action: {
                                // Select location and close search
                                vm.showNextLocation(location: location)
                                vm.showLocationsSearch = false
                            }) {
                                listRowView(location: location)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Search Locations")//.navigationBarTitleDisplayMode(.inline)
                }
                
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText, perform: { newValue in
            Task {
                await searchLocation()
            }
        })
        // .navigationTitle("Search Locations")
    }
    
    func searchLocation() async {
        if searchText.isEmpty {
            fetchedLocations = []
        } else {
            await MainActor.run(body: {
                
                
                fetchedLocations = vm.locations.filter { location in
                    location.name.lowercased().contains(searchText.lowercased()) ||
                    location.cityName.lowercased().contains(searchText.lowercased()) ||
                    location.description.lowercased().contains(searchText.lowercased())
                }
            })
        }
    }
}

extension SearchLocationView {
    private func listRowView (location: Location) -> some View {
        HStack{
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .cornerRadius(7)
            }
            
            VStack (alignment: .leading) {
                Text(location.name).font(.footnote)
                Text(location.cityName).font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
                //.background(Color.red)
                
        }
    }
}
