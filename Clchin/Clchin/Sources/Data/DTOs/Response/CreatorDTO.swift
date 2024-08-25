//
//  CreatorDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

struct CreatorDTO: Decodable {
    let userId: String
    let nickName: String
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickName = "nick"
        case profileImageURL = "profileImage"
    }
}
