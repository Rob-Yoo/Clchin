//
//  File.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

struct CrewRecruitItem {
    
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
    
    struct Creator {
        let nickName: String
        let profileImage: String?
        
        static func makeCreator(_ creator: CrewRecruit.Creator) -> Self {
            return Creator(nickName: creator.nickName, profileImage: APIKey.sesacBaseURL + "/" + (creator.profileImage ?? ""))
        }
    }
    
    let titleImage: String
    let climbingType: ClimbingType
    let title: String
    let climbingGymName: String
    let meetingDate: String
    let creator: Creator
    let participationStatus: String
    let isLike: Bool
    
    static func makeCrewRecruitItemModel(_ entity: CrewRecruit) -> Self {
        let titleImage = APIKey.sesacBaseURL + "/" + entity.images[0]
        let climbingType = ClimbingType(rawValue: entity.climbingType.rawValue) ?? .indoor
        let meetingDate = DateFormatManger.shared.convertToString(format: "M.d(E) a h:mm", target: entity.meetingDate)
        let remainingCount = (entity.maxPeopleCount - entity.participantCount)
        let participationStatus = remainingCount <= 2 ? "\(remainingCount)자리 남음" : "\(entity.participantCount)명 참여"

        return CrewRecruitItem(titleImage: titleImage, climbingType: climbingType, title: entity.recruitTitle, climbingGymName: entity.climbingGymName, meetingDate: meetingDate, creator: Creator.makeCreator(entity.creator), participationStatus: participationStatus, isLike: entity.isLike)
    }
}
