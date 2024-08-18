//
//  ClimbingGymDetailViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import RxSwift
import RxCocoa

final class ClimbingGymDetailViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: ControlEvent<Void>
    }
    
    struct Output {
        let gymDetail: PublishRelay<ClimbingGym>
    }
    
    private let climbingGym: ClimbingGym
    private let disposeBag = DisposeBag()
    
    init(climbingGym: ClimbingGym) {
        self.climbingGym = climbingGym
    }
    
    func transform(input: Input) -> Output {
        let gymDetail = PublishRelay<ClimbingGym>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                gymDetail.accept(owner.climbingGym)
            }
            .disposed(by: disposeBag)
        
        return Output(gymDetail: gymDetail)
    }
}
