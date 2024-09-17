//
//  LocationsViewModel.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI
import MapKit
import SwiftUI
import FirebaseFirestore

class LocationsViewModel: ObservableObject {
    
    //all loaded locations
    @Published var locations: [Location]
    
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation )
        }
    }
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var showLocationsList: Bool = false
    
    @Published var showLocationsSearch: Bool = false
    
    @Published var sheetLocation: Location? = nil
    
    @Published var createNewPost: Bool = false
    
    @Published var recentPosts: [Post] = []
    
    @Published var status: LocationStatus = .wantsToGo
    
    @Published var zoomLevelForDisplay: Double = 0.0
    
    private var xyz: [Location] = []
    
    private var previousZoomLevel: Double = 0.0
    private var zoomChangeTimer: Timer?
    
    init() {
       // await fetchLocations()
        self.locations = []
            self.mapLocation = Location(
                name: "Colosseum",
                cityName: "Rome",
                region: ".southernEurope",
                type: ".monument",
                latitude: 41.8902, longitude: 12.4922,
                description: "The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy, just east of the Roman Forum. It is the largest ancient amphitheatre ever built, and is still the largest standing amphitheatre in the world today, despite its age.",
                imageNames: [
                    "rome-colosseum-1",
                    "rome-colosseum-2",
                    "rome-colosseum-3",
                ],
                link: "https://en.wikipedia.org/wiki/Colosseum") // Provide a default location to avoid crashes
            self.updateMapRegion(location: mapLocation)
            startZoomChangeTimer()
            
            // Fetch the locations asynchronously
            Task {
                await fetchLocations()
            }
    }
    
    func fetchLocations() async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("Locations")
            
            
            // Fetch the documents
            let docs = try await query.getDocuments()
            
            // Attempt to convert documents to Location instances
            let fetchedLocations = docs.documents.compactMap { doc -> Location? in
                        do {
                            return try doc.data(as: Location.self)
                        } catch {
                            print("Error decoding document")
                            return nil
                        }
                    }
            
//            for document in docs.documents {
//                        // Print the entire document
//                        print("Document data: \(document.data())")
//                        
//                        // If you want to print specific fields, you can access them like this:
//                        if let name = document.data()["name"] as? String,
//                           let cityName = document.data()["cityName"] as? String {
//                            print("Location Name: \(name), City: \(cityName)")
//                        }
//                    }
            
            // Debugging: Print how many locations were fetched
            print("Fetched \(fetchedLocations.count) locations.")
            
            if fetchedLocations.isEmpty {
                print("No locations found.")
            } else {
                print("Locations fetched: \(fetchedLocations)")
            }
            
            let shuffledLocations = fetchedLocations.shuffled()

            // Ensure the UI is updated on the main thread
            await MainActor.run {
                self.xyz = shuffledLocations
                if let firstLocation = xyz.first {
                    self.locations = xyz
                    self.mapLocation = firstLocation
                    self.updateMapRegion(location: firstLocation)
                }
            }
        } catch {
            // Print the error if fetching fails
            print("Error fetching locations: \(error.localizedDescription)")
        }
    }


    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: mapSpan
            )
        }
       
    }
    
    var zoomLevel: Double {
            return mapRegion.span.longitudeDelta
        }
   
    func startZoomChangeTimer() {
           zoomChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
               guard let self = self else { return }
               if self.previousZoomLevel != self.zoomLevel {
                   self.previousZoomLevel = self.zoomLevel
                   zoomLevelForDisplay = zoomLevel//String(format: "Zoom Level: %.2f", zoomLevel)
                   self.printZoomLevel()
               }
           }
       }
    
    func printZoomLevel() {
            print("Current Zoom Level (latitudeDelta): \(zoomLevel)")
        }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList = !showLocationsList
        }
    }
    
    func toggleLocationsSearch() {
        withAnimation(.easeInOut) {
            showLocationsSearch = !showLocationsSearch
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
        mapLocation = location
            showLocationsList = false
        }
        
    }
    
    func nextButtonPressed() {
        withAnimation(.easeInOut) {
            
            guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else {
                print("could not find index")
                return
            }
            
            let nextIndex = currentIndex + 1
            
            guard locations.indices.contains(nextIndex) else {
                let firstLocation = locations.first
                showNextLocation(location: firstLocation!)
                return
            }
            
            let nextLocation = locations[nextIndex]
            
            showNextLocation(location: nextLocation)
            
//            let currentIndex = locations.firstIndex{
//                location in
//                return location == mapLocation
//            }
            
            
        }
    }
    
    deinit {
            zoomChangeTimer?.invalidate()
        }
}
