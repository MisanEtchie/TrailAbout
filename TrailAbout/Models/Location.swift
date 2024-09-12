//
//  Location.swift
//  TrailAbout
//
//  Created by Misan on 8/25/24.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseFirestore

struct Location: Identifiable, Codable, Equatable, Hashable {
   
    
    @DocumentID var id: String?
    var name: String
    var cityName: String
    var region: String//RegionsOfTheWorld
    var type: String//PlaceCategory
    var latitude: Double
    var longitude: Double
    var description: String
    var imageNames: [String]
    var link: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case cityName
        case region
        case type
        case latitude
        case longitude
        case description
        case imageNames
        case link
    }

}

enum RegionsOfTheWorld: String, Codable {
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

enum PlaceCategory: String, Codable {
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

//
//struct Location: Identifiable, Codable, Equatable, Hashable {
//    //@DocumentID var id: String?
//    var name: String
//    var cityName: String
//    var region: RegionsOfTheWorld
//    var type: PlaceCategory
//    var coordinates: CLLocationCoordinate2D
//    var description: String
//    var imageNames: [String]
//    var link: String
//    
//    var id: String {
//        name + cityName
//    }
//    
//    static func == (lhs: Location, rhs: Location) -> Bool {
//        lhs.id ==  rhs.id
//    }
//    
//    enum CodingKeys: CodingKey {
//        case id
//        case name
//        case cityName
//        case region
//        case type
//        case coordinates
//        case description
//        case imageNames
//        case link
//    }
//    
//}
