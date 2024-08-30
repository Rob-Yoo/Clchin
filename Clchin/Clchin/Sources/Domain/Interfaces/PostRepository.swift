//
//  PostRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Foundation

protocol PostRepository {
    func fetchPostList(
        isPagination: Bool,
        completionHandler: @escaping (Result<[Post], NetworkError>) -> Void
    )
    
    func uploadImages(
        images: [Data],
        completionHandler: @escaping (Result<PostImages, NetworkError>) -> Void
    )
    func uploadPost(post: UploadPostBodyDTO)
}
