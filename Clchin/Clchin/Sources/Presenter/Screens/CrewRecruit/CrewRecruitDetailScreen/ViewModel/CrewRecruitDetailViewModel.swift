//
//  CrewRecruitDetailViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class CrewRecruitDetailViewModel: ViewModelType {
    
    struct Input {
        let crewRecruitDetailRequestTrigger: Observable<Void>
        let joinButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        var detailSections = Observable<[RecruitDetailSectionModel]>.empty()
        let payment = PublishRelay<Payment>()
    }
    
    private var output = Output()
    private let disposeBag = DisposeBag()
    
    private let crewRecruit: CrewRecruit
    
    init(crewRecruit: CrewRecruit) {
        self.crewRecruit = crewRecruit
    }
    
    func transform(input: Input) -> Output {
        
        input.crewRecruitDetailRequestTrigger
            .bind(with: self) { owner, _ in
                let crewRecruitDetail = CrewRecruitDetail.makeCrewRecruitDetail(owner.crewRecruit)
                
                let headerSection = RecruitDetailSectionModel(items: [
                    .header(HeaderSectionModel(
                        imageURL: crewRecruitDetail.images[0],
                        recruitTitle: crewRecruitDetail.title,
                        climbingType: crewRecruitDetail.climbingType.title))
                ])
                
                let bodySection = RecruitDetailSectionModel(items: [
                    .body(BodySectionModel(
                        hostProfileImageURL: crewRecruitDetail.host.profileImage,
                        hostName: crewRecruitDetail.host.nickName,
                        recruitText: crewRecruitDetail.contentText))
                ])
                
                let footerSection = RecruitDetailSectionModel(items: [
                    .footer(FooterSectionModel(empty: ""))
                ])
                
                owner.output.detailSections = .just([headerSection, bodySection, footerSection])
            }
            .disposed(by: disposeBag)
        
        input.joinButtonTapped
            .bind(with: self) { owner, _ in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "1").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = "드래곤크루 모집"
                        $0.buyer_name = "유진영"
                        $0.app_scheme = "clchin"
                    }
                let postId = owner.crewRecruit.id
                
                owner.output.payment.accept(Payment(iamportPayment: payment, postId: postId))
            }
            .disposed(by: disposeBag)

        return self.output
    }
}

extension CrewRecruitDetailViewModel {
    struct Payment {
        let iamportPayment: IamportPayment
        let postId: String
    }
}
