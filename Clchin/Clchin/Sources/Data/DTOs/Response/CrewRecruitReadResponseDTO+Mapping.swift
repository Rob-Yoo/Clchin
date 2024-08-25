//
//  CrewRecruitReadResponseDTO+Mapping.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

struct CrewRecruitReadResponseDTO: Decodable {
    let data: [CrewRecruitDataDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct CrewRecruitDataDTO: Decodable {
    let postId: String
    let productId: String
    let creator: CreatorDTO
    let createdAt: String

    let title: String
    let price: Int
    let contentText: String
    let climbingGymName: String
    let coordinate: String
    let meetingDate: String
    let maxPeopleCount: String
    let climbingType: String
    let files: [String]
    let likes: [String]
    let participants: [String]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case contentText = "content"
        case createdAt, creator, title, price, files, likes
        case climbingGymName = "content1"
        case coordinate = "content2"
        case meetingDate = "content3"
        case maxPeopleCount = "content4"
        case climbingType = "content5"
        case participants = "likes2"
    }
}

extension CrewRecruitReadResponseDTO {
    func toDomain() -> [CrewRecruit] {
        return self.data.map { $0.toDomain() }
    }
}

extension CrewRecruitDataDTO {
    func toDomain() -> CrewRecruit {
        let createdAt = DateFormatManger.shared.convertToISOFormatDate(target: self.createdAt)
        let coord = self.coordinate.components(separatedBy: ", ")
        let (lat, lng) = (Double(coord[0])!, Double(coord[1])!)
        let meetingDate = DateFormatManger.shared.convertToDate(target: self.meetingDate)
        let climbingType = CrewRecruit.ClimbingType(rawValue: self.climbingType) ?? .indoor
        let isLike = self.likes.contains(UserDefaultsStorage.userId)
        
        return CrewRecruit(
            id: self.postId,
            creator: self.creator.toDomain(),
            createdAt: createdAt,
            recruitTitle: self.title,
            recruitContentText: self.contentText,
            climbingGymName: self.climbingGymName,
            location: CrewRecruit.Coordinate(lat: lat, lng: lng),
            meetingDate: meetingDate,
            maxPeopleCount: Int(self.maxPeopleCount)!,
            climbingType: climbingType,
            images: self.files,
            isLike: isLike,
            likeCount: self.likes.count,
            participantCount: self.participants.count
        )
    }
}


extension CreatorDTO {
    func toDomain() -> CrewRecruit.Creator {
        return CrewRecruit.Creator(
            id: self.userId,
            nickName: self.nickName,
            profileImage: self.profileImageURL
        )
    }
}

