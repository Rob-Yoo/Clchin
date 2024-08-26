//
//  CrewRecruitDetailViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import RxSwift
import RxCocoa

final class CrewRecruitDetailViewModel: ViewModelType {
    
    struct Input {
        let crewRecruitDetailRequestTrigger: BehaviorRelay<Void>
    }
    
    struct Output {
        let crewRecruitDetail = PublishRelay<CrewRecruitDetail>()
    }
    
    private let output = Output()
    private let disposeBag = DisposeBag()
    
    private let crewRecruit: CrewRecruit
    
    init(crewRecruit: CrewRecruit) {
        self.crewRecruit = crewRecruit
    }
    
    func transform(input: Input) -> Output {
        
        input.crewRecruitDetailRequestTrigger
            .bind(with: self) { owner, _ in
                let crewRecruitDetail = CrewRecruitDetail.makeCrewRecruitDetail(owner.crewRecruit)
                
                owner.output.crewRecruitDetail.accept(crewRecruitDetail)
            }
            .disposed(by: disposeBag)
        return self.output
    }
}
