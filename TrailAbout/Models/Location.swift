//
//  Location.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable {
   
    let name: String
    let cityName: String
    let region: RegionsOfTheWorld
    let type: PlaceCategory
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    var id: String {
        name + cityName
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id ==  rhs.id
    }
}

enum RegionsOfTheWorld: String {
       // Africa
       case northernAfrica = "Northern Africa"
       case westernAfrica = "Western Africa"
       case centralAfrica = "Central Africa"
       case easternAfrica = "Eastern Africa"
       case southernAfrica = "Southern Africa"
       
       // Americas
       case northernAmerica = "Northern America"
       case centralAmerica = "Central America"
       case caribbean = "Caribbean"
       case southAmerica = "South America"
       
       // Asia
       case centralAsia = "Central Asia"
       case easternAsia = "Eastern Asia"
       case southernAsia = "Southern Asia"
       case southeastAsia = "South East Asia"
       case middleEast = "Middle East"
       
       // Europe
       case easternEurope = "Eastern Europe"
       case centralEurope = "Central Europe"
       case northernEurope = "Northern Europe"
       case southernEurope = "Southern Europe"
       case westernEurope = "Western Europe"
       
       // Oceania
       case oceania = "Oceania"
       
       // Antarctica
       case antarctica = "Antarctica"
}

enum PlaceCategory: String {
    case tourism = "Tourism"
    case park = "Park"
    case monument = "Monument"
    case historicalSite = "Historical Site"
    case entertainment = "Entertainment"
    case naturalWonder = "Natural Wonder"
    case cultural = "Cultural"
    case religious = "Religious"
    case shopping = "Shopping"
    case accommodation = "Accommodation"
    case dining = "Dining"
}
