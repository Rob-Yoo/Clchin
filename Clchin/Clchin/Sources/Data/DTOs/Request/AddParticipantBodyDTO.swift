//
//  AddParticipantBodyDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/29/24.
//

import Foundation

struct AddParticipantBodyDTO: Encodable {
    let willAdd: Bool
    
    enum CodingKeys: String, CodingKey {
        case willAdd = "like_status"
    }
}
