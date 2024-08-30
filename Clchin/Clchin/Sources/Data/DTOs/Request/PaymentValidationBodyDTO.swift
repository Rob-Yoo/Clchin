//
//  PaymentValidationBodyDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/29/24.
//

import Foundation

struct PaymentValidationBodyDTO: Encodable {
    let impUID: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
        case postId = "post_id"
    }
}

