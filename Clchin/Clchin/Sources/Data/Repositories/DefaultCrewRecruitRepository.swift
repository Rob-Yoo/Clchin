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

    func fetchCrewRecruitList(isPagination: Bool, completionHandler: @escaping (Result<[CrewRecruit], PostReadError>) -> Void) {
        
        if (isPagination == true), let next, next == "0" {
            print("마지막 페이지임")
            return
        } else if (isPagination == false) {
            next = nil
        }

        NetworkProvider.shared.requestAPI(CrewRecruitAPI.getRecruits(next: next), responseType: CrewRecruitReadResponseDTO.self, errorType: PostReadError.self)
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
        NetworkProvider.shared.requestAPI(CrewRecruitAPI.uploadRecruit(post), responseType: EmptyResponse.self, errorType: PostUploadError.self)
            .subscribe(with: self) { owner, _ in }
            .disposed(by: disposeBag)
    }
    
    func requestPaymentValidation(payment: PaymentValidationBodyDTO, completionHandler: @escaping (Result<Payment, PaymentValidationError>) -> Void) {
        NetworkProvider.shared.requestAPI(CrewRecruitAPI.validatePayment(payment), responseType: PaymentValidationResponseDTO.self, errorType: PaymentValidationError.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    let payment = Payment(buyerId: response.buyerId, postId: response.postId)
                    completionHandler(.success(payment))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func addParticipant(postId: String, _ body: AddParticipantBodyDTO) {
        NetworkProvider.shared.requestAPI(CrewRecruitAPI.addNewParticipant(postId: postId, body), responseType: EmptyResponse.self, errorType: LikeError.self)
            .subscribe(with: self) { owner, _ in }
            .disposed(by: disposeBag)
    }
}
