//
//  ClimbingGymDetailViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import RxSwift
import RxCocoa

final class ClimbingGymDetailViewModel: ViewModelType {
    struct Input {}
    
    struct Output {
        let gymDetail: BehaviorRelay<ClimbingGym>
    }

    private let output: Output
    
    init(climbingGym: ClimbingGym) {
        self.output = Output(gymDetail: BehaviorRelay(value: climbingGym))
    }
    
    func transform(input: Input) -> Output {
        return output
    }
}
