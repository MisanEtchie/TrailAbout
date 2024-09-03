//
//  User.swift
//  TrailAbout
//
//  Created by Misan on 9/1/24.
//

import SwiftUI
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userBio
        case userUID
        case userEmail
        case userProfileURL
    }
}

