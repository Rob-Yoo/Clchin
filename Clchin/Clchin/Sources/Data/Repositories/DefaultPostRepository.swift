//
//  DefaultPostRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Foundation
import RxSwift

final class DefaultPostRepository: PostRepository {

    private var next: String? = nil
    private let disposeBag = DisposeBag()

    func fetchPostList(isPagination: Bool, completionHandler: @escaping (Result<[Post], PostReadError>) -> Void) {
        
        if (isPagination == true), let next, next == "0" {
            print("마지막 페이지임")
            return
        } else if (isPagination == false) {
            next = nil
        }

        NetworkProvider.shared.requestAPI(PostAPI.getPosts(next: next), responseType: PostReadResponseDTO.self, errorType: PostReadError.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.next = response.nextCursor
                    completionHandler(.success(response.toDomain()))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func uploadImages(images: [Data], completionHandler: @escaping (Result<PostImages, PostImageUploadError>) -> Void) {
        NetworkProvider.shared.requestAPI(PostAPI.uploadImages(images), responseType: PostImageResponseDTO.self, errorType: PostImageUploadError.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    completionHandler(.success(PostImages(files: response.files)))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func uploadPost(post: UploadPostBodyDTO) {
        NetworkProvider.shared.requestAPI(PostAPI.uploadPost(post), responseType: EmptyResponse.self, errorType: PostUploadError.self)
            .subscribe(with: self) { owner, _ in }
            .disposed(by: disposeBag)
    }
}
