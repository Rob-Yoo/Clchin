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
        case climbingGymName = "content1"
        case contentText = "content"
        case productId = "product_id"
        case images = "files"
    }
}

final class UploadPostBodyDTOBuilder {
    private var climbingGymName: String = ""
    private var contentText: String = ""
    private var colors = [String]()
    private let productId: String = "climbing"
    private var images: [String] = []
    
    func climbingGymName(_ name: String) {
        self.climbingGymName = name
    }
    
    func contentText(_ text: String) {
        self.contentText = text
    }
    
    func levelColors(_ colors: [String]) {
        self.colors = colors
    }
    
    func images(_ images: [String]) {
        self.images = images
    }
    
    func build() -> UploadPostBodyDTO {
        let hashTagged = "#" + self.colors.joined(separator: "#")
        self.contentText += hashTagged

        return UploadPostBodyDTO(climbingGymName: climbingGymName, contentText: contentText, productId: productId, images: images)
    }
}
