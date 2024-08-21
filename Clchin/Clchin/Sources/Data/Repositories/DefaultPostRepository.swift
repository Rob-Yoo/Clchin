//
//  DefaultPostRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Foundation
import Alamofire
import RxSwift

final class DefaultPostRepository: PostRepository {

    private let disposeBag = DisposeBag()

    func fetchPostList(next: String?, completionHandler: @escaping (Result<PostReadResponseDTO, NetworkError>) -> Void) {
        NetworkProvider.shared.requestAPI(PostAPI.getPosts(next: next), responseType: PostReadResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func uploadPost(post: UploadPostBodyDTO) {
        return
    }
    
    
}
