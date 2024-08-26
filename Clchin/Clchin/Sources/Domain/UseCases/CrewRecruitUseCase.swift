//
//  CrewRecruitUseCase.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import RxSwift

protocol CrewRecruitUseCase {
    func fetchCrewRecruitList(isPagination: Bool) -> Single<Result<[CrewRecruit], NetworkError>>

    func uploadCrewRecruit(post: UploadCrewRecruitBodyDTO)
}


final class DefaultCrewRecruitUseCase: CrewRecruitUseCase {
    
    private let crewRecruitRepository: CrewRecruitRepository
    
    init(crewRecruitRepository: CrewRecruitRepository) {
        self.crewRecruitRepository = crewRecruitRepository
    }
    
    func fetchCrewRecruitList(isPagination: Bool) -> Single<Result<[CrewRecruit], NetworkError>> {
        return Single.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            crewRecruitRepository.fetchCrewRecruitList(isPagination: isPagination) { result in
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
    
    func uploadCrewRecruit(post: UploadCrewRecruitBodyDTO) {
        crewRecruitRepository.uploadCrewRecruit(post: post)
    }
    
    
}
