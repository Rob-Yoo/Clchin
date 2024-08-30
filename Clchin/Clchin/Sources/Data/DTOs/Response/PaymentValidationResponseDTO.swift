//
//  PaymentValidationResponseDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/29/24.
//

import Foundation

struct PaymentValidationResponseDTO: Decodable {
    let buyerId: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case postId = "post_id"
    }
}
