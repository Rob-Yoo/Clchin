//
//  ClimbingGymSearchViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import RxSwift
import RxCocoa

final class ClimbingGymSearchViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let gymList: PublishRelay<[ClimbingGym]>
    }
    
    private let disposeBag = DisposeBag()
    private let searchClimbingGymUseCase: SearchClimbingGymUseCase
    
    init(searchClimbingGymUseCase: SearchClimbingGymUseCase) {
        self.searchClimbingGymUseCase = searchClimbingGymUseCase
    }
    
    func transform(input: Input) -> Output {
        let climbingGymList = PublishRelay<[ClimbingGym]>()
        
        Observable.combineLatest(input.viewDidLoad, input.searchText)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { String($0.1) }
            .distinctUntilChanged()
            .flatMap { [weak self] text in
                guard let self else {
                    return Single<Result<[ClimbingGym], Error>>.never()
                }
                return self.searchClimbingGymUseCase.execute(textQuery: text)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let gymList):
                    climbingGymList.accept(gymList)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(gymList: climbingGymList)
    }
}
