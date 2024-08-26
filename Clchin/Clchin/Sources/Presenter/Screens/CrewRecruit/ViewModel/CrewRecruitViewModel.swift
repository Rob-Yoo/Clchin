//
//  CrewRecruitViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import RxSwift
import RxCocoa

final class CrewRecruitViewModel: ViewModelType {
    struct Input {
        let crewRecruitRequestTrigger: BehaviorRelay<Void>
        let refreshControlValueChanged: ControlEvent<Void>
    }
    
    struct Output {
        let crewRecruitItemList = PublishRelay<[CrewRecruitItem]>()
        let refreshControlShouldStop = PublishRelay<Void>()
    }
    
    private let crewRecruitUseCase: CrewRecruitUseCase
    private let disposeBag = DisposeBag()
    private let output = Output()
    
    private var isPagination = false
    private var crewRecruitItemList = [CrewRecruitItem]()
    
    init(crewRecruitUseCase: CrewRecruitUseCase) {
        self.crewRecruitUseCase = crewRecruitUseCase
    }
    
    func transform(input: Input) -> Output {
        input.crewRecruitRequestTrigger
            .flatMap { [weak self] in
                guard let self else { return Single<Result<[CrewRecruit], NetworkError>>.never() }

                return crewRecruitUseCase.fetchCrewRecruitList(isPagination: isPagination)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let list):
                    owner.emitCrewRecruitItemListRelay(list)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlValueChanged
            .bind(with: self) { owner, _ in
                owner.isPagination = false
                input.crewRecruitRequestTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return self.output
    }
}

//MARK: - Emit Relay
extension CrewRecruitViewModel {
    private func emitCrewRecruitItemListRelay(_ itemList: [CrewRecruit]) {
        let crewRecruitItemList = itemList.map { CrewRecruitItem.makeCrewRecruitItemModel($0) }
        
        if (isPagination) {
            self.crewRecruitItemList.append(contentsOf: crewRecruitItemList)
        } else {
            self.crewRecruitItemList = crewRecruitItemList
        }

        output.refreshControlShouldStop.accept(())
        output.crewRecruitItemList.accept(self.crewRecruitItemList)
    }
}
