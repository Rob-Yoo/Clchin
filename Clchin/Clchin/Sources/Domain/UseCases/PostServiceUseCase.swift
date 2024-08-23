//
//  PostServiceUseCase.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import RxSwift

protocol PostServiceUseCase {
    func fetchPostList(isPagination: Bool) -> Single<Result<[Post], NetworkError>>

    func uploadPost(post: UploadPostBodyDTO)
}


final class DefaultPostServiceUseCase: PostServiceUseCase {
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func fetchPostList(isPagination: Bool) -> Single<Result<[Post], NetworkError>> {
        return Single.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            postRepository.fetchPostList(isPagination: isPagination) { result in
                switch result {
                case .success(let postList):
                    observer(.success(.success(postList)))
                case .failure(let error):
                    observer(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func uploadPost(post: UploadPostBodyDTO) {
        postRepository.uploadPost(post: post)
    }
    
    
}
