//
//  CrewRecruitDetail.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import Foundation

struct CrewRecruitDetail {
    
    enum ClimbingType: String {
        case indoor
        case outdoor
        
        var title: String {
            switch self {
            case .indoor:
                return "실내 클라이밍"
            case .outdoor:
                return "실외 클라이밍"
            }
        }
    }
    
    struct Member {
        let nickName: String
        let profileImage: String?
        
        static func makeMember(_ creator: CrewRecruit.Creator) -> Self {
            return Member(nickName: creator.nickName, profileImage: APIKey.sesacBaseURL + "/" + (creator.profileImage ?? ""))
        }
    }
    
    struct Coordinate {
        let lat: Double
        let lng: Double
    }
    
    let postId: String
    let images: [String]
    let climbingType: ClimbingType
    let host: Member
    let title: String
    let contentText: String
    let climbingGymName: String
    let location: Coordinate
    let meetingDate: String
    let price: String
//    let participants: [Member]
    let isLike: Bool
    let likeCount: Int
    
    static func makeCrewRecruitDetail(_ entity: CrewRecruit) -> Self {
        let climbingType = ClimbingType(rawValue: entity.climbingType.rawValue) ?? .indoor
        let location = Coordinate(lat: entity.location.lat, lng: entity.location.lng)
        let meetingDate = DateFormatManger.shared.convertToString(format: "M.d(E) a h:mm", target: entity.meetingDate)
        let price = entity.price.formatted() + "원"
        let images = entity.images.map { APIKey.sesacBaseURL + "/" + $0 }
        
        return CrewRecruitDetail(postId: entity.id, images: images, climbingType: climbingType, host: Member.makeMember(entity.creator), title: entity.recruitTitle, contentText: entity.recruitContentText, climbingGymName: entity.climbingGymName, location: location, meetingDate: meetingDate, price: price, isLike: entity.isLike, likeCount: entity.likeCount)
    }
}
