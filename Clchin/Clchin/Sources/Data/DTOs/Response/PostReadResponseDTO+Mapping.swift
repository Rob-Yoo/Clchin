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
    let productId: String
    let contentText: String
    let climbingGymName: String
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
        case climbingGymName = "content1"
        case createdAt, creator, files, likes, comments
        case levelColors = "hashTags"
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

extension PostReadResponseDTO {
    func toDomain() -> [Post] {
        return self.data.map { $0.toDomain() }
    }
}

extension PostDataDTO {
    func toDomain() -> Post {
        let createdAt = DateFormatManger.shared.convertToISOFormatDate(target: self.createdAt)
        let isLike = self.likes.contains(UserDefaultsStorage.userId)
        
        return Post(
            id: self.postId,
            creator: self.creator.toDomain(), 
            climbingGymName: self.climbingGymName,
            createdAt: createdAt,
            images: self.files,
            content: self.contentText,
            levelColors: self.levelColors,
            isLike: isLike,
            likeCount: self.likes.count,
            commentCount: self.comments.count,
            comments: self.comments.map { $0.toDomain() }
        )
    }
}

extension CommentDTO {
    func toDomain() -> Post.Comment {
        let createdAt = DateFormatManger.shared.convertToISOFormatDate(target: self.createdAt)
        
        return Post.Comment(
            id: self.commentId,
            content: self.content,
            createdAt: createdAt,
            creator: self.creator.toDomain()
        )
    }
}

extension CreatorDTO {
    func toDomain() -> Post.Creator {
        return Post.Creator(
            id: self.userId,
            nickName: self.nickName,
            profileImage: self.profileImageURL
        )
    }
}
