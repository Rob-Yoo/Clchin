//
//  ClimbingGym.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/16/24.
//

import GooglePlaces

struct ClimbingGym: Identifiable {
    typealias Identifier = String

    let id: Identifier
    let name: String
    let address: String
    let photos: [GMSPlacePhotoMetadata]
    let lat: Double
    let lng: Double
    let distance: Double
    let rate: Float
    let userRatingCount: Int
    let openingHours: [String]
    let currentOpeningHour: String
    let isOpen: Bool
    let phoneNumber: String
    let website: URL?
}
