//
//  DefaultCrewRecruitRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import RxSwift

final class DefaultCrewRecruitRepository: CrewRecruitRepository {

    private var next: String? = nil
    private let disposeBag = DisposeBag()

    func fetchCrewRecruitList(isPagination: Bool, completionHandler: @escaping (Result<[CrewRecruit], NetworkError>) -> Void) {
        
        if (isPagination == true), let next, next == "0" {
            print("마지막 페이지임")
            return
        } else if (isPagination == false) {
            next = nil
        }

        NetworkProvider.shared.requestAPI(CrewRecruitAPI.getRecruits(next: next), responseType: CrewRecruitReadResponseDTO.self)
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
    
    func uploadCrewRecruit(post: UploadCrewRecruitBodyDTO) {
        NetworkProvider.shared.requestAPI(CrewRecruitAPI.uploadRecruit(post), responseType: EmptyResponse.self)
            .subscribe(with: self) { owner, _ in }
            .disposed(by: disposeBag)
    }
}
