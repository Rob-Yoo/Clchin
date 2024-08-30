//
//  PresentationModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/23/24.
//

import Foundation

struct PostItem {
    
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
    
    let creator: Creator
    let climbingGymName: String
    let elapsedTime: String
    let postImages: [String]
    let contentText: String
    let levelColors: Set<String>
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    
    static func makePostItem(post: Post, elapsedTime: String) -> Self {
        let postImages = post.images.map { APIKey.sesacBaseURL + "/" + $0 }
        let hashTagStartIdx = post.content.firstIndex(of: "#") ?? post.content.startIndex
        let content = String(post.content.prefix(upTo: hashTagStartIdx))
        let levelColors = post.content.suffix(from: hashTagStartIdx).filter { $0 != "#" }.map { String($0) }

        return PostItem(creator: Creator.makeCreator(post.creator), climbingGymName: post.climbingGymName, elapsedTime: elapsedTime, postImages: postImages, contentText: content, levelColors: Set(levelColors), isLike: post.isLike, likeCount: post.likeCount, commentCount: post.commentCount)
    }
}
