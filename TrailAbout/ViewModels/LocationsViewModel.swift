//
//  LocationsViewModel.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import SwiftUI
import MapKit

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
    
    @Published var sheetLocation: Location? = nil
    
    @Published var createNewPost: Bool = false
    
    @Published var recentPosts: [Post] = []
    
    @Published var status: LocationStatus = .wantsToGo
    
    @Published var zoomLevelForDisplay: Double = 0.0
    
    private var previousZoomLevel: Double = 0.0
    private var zoomChangeTimer: Timer?
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first! )
        startZoomChangeTimer()
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates, span: mapSpan
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
