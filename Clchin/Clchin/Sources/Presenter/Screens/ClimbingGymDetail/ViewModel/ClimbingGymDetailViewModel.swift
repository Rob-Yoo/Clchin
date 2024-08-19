//
//  ClimbingGymDetailViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class ClimbingGymDetailViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let locationPinButtonTapped: ControlEvent<UITapGestureRecognizer>
        let instaButtonTapped: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let gymDetail: PublishRelay<ClimbingGym>
        let name: PublishRelay<String>
        let website: PublishRelay<URL?>
    }
    
    private let climbingGym: ClimbingGym
    private let disposeBag = DisposeBag()
    
    init(climbingGym: ClimbingGym) {
        self.climbingGym = climbingGym
    }
    
    func transform(input: Input) -> Output {
        let gymDetail = PublishRelay<ClimbingGym>()
        let address = PublishRelay<String>()
        let website = PublishRelay<URL?>()
        
        input.viewDidLoad
            .bind(with: self) { owner, _ in
                gymDetail.accept(owner.climbingGym)
            }
            .disposed(by: disposeBag)
        
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
