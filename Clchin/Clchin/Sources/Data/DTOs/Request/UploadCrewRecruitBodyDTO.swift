//
//  UploadCrewRecruitBodyDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

struct UploadCrewRecruitBodyDTO: Encodable {
    let productId: String
    let title: String
    let price: Int
    let contentText: String
    let climbingGymName: String
    let location: String
    let meetingDate: String
    let maxPeopleCount: String
    let climbingType: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case productId, title, price
        case contentText = "content"
        case climbingGymName = "content1"
        case location = "content2"
        case meetingDate = "content3"
        case maxPeopleCount = "content4"
        case climbingType = "content5"
        case images = "files"
    }
}
