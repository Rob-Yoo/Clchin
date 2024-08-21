//
//  LoginResponseDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let userId: String
    let email: String
    let nickname: String
    let profileImageURL: String?
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname = "nick"
        case profileImageURL = "profileImage"
        case email, accessToken, refreshToken
    }
}
