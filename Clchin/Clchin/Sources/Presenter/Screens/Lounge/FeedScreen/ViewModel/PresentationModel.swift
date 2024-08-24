//
//  PresentationModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/23/24.
//

import Foundation

struct PostItem {
    
    let creator: Creator
    let climbingGymName: String
    let elapsedTime: String
    let postImages: [String]
    let contentText: String
    let levelColors: [String]
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    
    static func makePostItem(post: Post, elapsedTime: String) -> Self {
        let postImages = post.images.map { APIKey.sesacBaseURL + "/" + $0 }
        
        return PostItem(creator: Creator.makeCreator(post.creator), climbingGymName: post.climbingGymName, elapsedTime: elapsedTime, postImages: postImages, contentText: post.content, levelColors: post.levelColors, isLike: post.isLike, likeCount: post.likeCount, commentCount: post.commentCount)
    }
}

struct Creator {
    let nickName: String
    let profileImage: String?
    
    static func makeCreator(_ creator: Post.Creator) -> Self {
        return Creator(nickName: creator.nickName, profileImage: APIKey.sesacBaseURL + "/" + (creator.profileImage ?? ""))
    }
}

struct Comment {
    let creator: Creator
    let content: String
    let elapsedTime: String
    
    static func makeComment(_ comment: Post.Comment, elapsedTime: String) -> Comment {
        return Comment(creator: Creator.makeCreator(comment.creator), content: comment.content, elapsedTime: elapsedTime)
    }
}
