//
//  Post.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Foundation

struct Post: Identifiable {
    
    struct Comment: Identifiable {
        let id: String
        let content: String
        let createdAt: Date
        let creator: Creator
    }
    
    struct Creator: Identifiable {
        let id: String
        let nickName: String
        let profileImage: String?
    }

    let id: String
    let creator: Creator
    let climbingGymName: String
    let createdAt: Date

    let images: [String]
    let content: String
    let levelColors: [String]
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let comments: [Comment]
}


