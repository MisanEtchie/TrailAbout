//
//  Post.swift
//  TrailAbout
//
//  Created by Misan on 9/4/24.
//

import SwiftUI
import FirebaseFirestore

enum LocationStatus: String, Codable {
        case visited
        case wantsToGo
    }

struct Post: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String?
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var locationStatus: LocationStatus
    //
    var username: String
    var userUID: String
    var userProfileURL: URL
    //
    var locationName: String
    var locationCity: String
    
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case likedIDs
        case locationStatus
        case username
        case userUID
        case userProfileURL
        case locationName
        case locationCity
    }
}


