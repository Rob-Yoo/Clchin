//
//  ClimbingGymDetailCellViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/28/24.
//

import RxSwift
import RxCocoa
import RxGesture
import Foundation

final class ClimbingGymDetailCellViewModel: ViewModelType {
    struct Input {
        let locationPinButtonTapped: TapControlEvent
        let instaButtonTapped: TapControlEvent
    }
    
    struct Output {
        let gymDetail: BehaviorRelay<ClimbingGym>
        let name: PublishRelay<String>
        let website: PublishRelay<URL?>
    }

    private let climbingGym: ClimbingGym
    private let disposeBag = DisposeBag()
    
    init(climbingGym: ClimbingGym) {
        self.climbingGym = climbingGym
    }
    
    func transform(input: Input) -> Output {
        let gymDetail = BehaviorRelay(value: climbingGym)
        let address = PublishRelay<String>()
        let website = PublishRelay<URL?>()
        
        input.locationPinButtonTapped
            .bind(with: self) { owner, _ in
                address.accept(owner.climbingGym.name)
            }
            .disposed(by: disposeBag)
        
        input.instaButtonTapped
            .bind(with: self) { owner, _ in
                website.accept(owner.climbingGym.website)
            }
            .disposed(by: disposeBag)
        
        return Output(gymDetail: gymDetail, name: address, website: website)
    }
}
