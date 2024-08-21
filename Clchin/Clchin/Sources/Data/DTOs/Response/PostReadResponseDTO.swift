//
//  PostReadResponseDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation

struct PostReadResponseDTO: Decodable {
    let data: [PostDataDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

struct PostDataDTO: Decodable {
    let postId: String
    let productId: String?
    let contentText: String?
    let climbingGym: String?
    let createdAt: String
    let creator: CreatorDTO
    let files: [String]
    let likes: [String]
    let levelColors: [String]
    let comments: [CommentDTO]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case contentText = "content"
        case climbingGym = "content1"
        case createdAt, creator, files, likes, comments
        case levelColors = "hashTags"
    }
}

struct CreatorDTO: Decodable {
    let userId: String
    let nickName: String
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickName = "nick"
        case profileImageURL = "profielImage"
    }
}

struct CommentDTO: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: CreatorDTO
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}
