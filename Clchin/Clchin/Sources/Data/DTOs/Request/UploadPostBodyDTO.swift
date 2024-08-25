//
//  UploadPostBodyDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation

struct UploadPostBodyDTO: Encodable {
    let climbingGymName: String
    let contentText: String
    let productId: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case climbingGymName = "content"
        case contentText = "content1"
        case productId = "product_id"
        case images = "files"
    }
}
