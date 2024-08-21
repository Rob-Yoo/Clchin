//
//  PostRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Foundation

protocol PostRepository {
    func fetchPostList(
        next: String?,
        completionHandler: @escaping (Result<PostReadResponseDTO, NetworkError>) -> Void
    )
    
    func uploadPost(post: UploadPostBodyDTO)
}
