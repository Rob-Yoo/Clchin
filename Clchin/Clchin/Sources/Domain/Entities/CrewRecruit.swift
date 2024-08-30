//
//  CrewRecruit.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

struct CrewRecruit: Identifiable {

    struct Creator: Identifiable {
        let id: String
        let nickName: String
        let profileImage: String?
    }
    
    struct Coordinate {
        let lat: Double
        let lng: Double
    }

    enum ClimbingType: String {
        case indoor
        case outdoor
    }
    
    let id: String
    let creator: Creator
    let createdAt: Date

    let recruitTitle: String
    let recruitContentText: String
    let price: Int
    let climbingGymName: String
    let location: Coordinate
    let meetingDate: Date
    let maxPeopleCount: Int
    let climbingType: ClimbingType
    let images: [String]
    let isLike: Bool
    let likeCount: Int
    let participants: [String]
    let participantCount: Int
}
