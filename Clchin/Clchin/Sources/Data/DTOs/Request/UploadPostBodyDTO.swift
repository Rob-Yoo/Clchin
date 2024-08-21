//
//  UploadPostBodyDTO.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation

struct UploadPostBodyDTO: Encodable {
    let content: String
    let content1: String
    let product_id: String
    let files: [String]
}
