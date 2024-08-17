//
//  ClimbingGymSearchViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

final class ClimbingGymSearchViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let sortButtonsTapped: [ControlEvent<Void>]
    }
    
    struct Output {
        let gymList: BehaviorRelay<[ClimbingGym]>
        let sortStatusArray: BehaviorRelay<[Bool]>
    }
    
    private let disposeBag = DisposeBag()
    private let searchClimbingGymUseCase: SearchClimbingGymUseCase
    private var climbingGymList = [ClimbingGym]()
    private var sortStatusArray = Array(repeating: false, count: SortType.allCases.count)
    private let locationManager = CLLocationManager()
    
    init(searchClimbingGymUseCase: SearchClimbingGymUseCase) {
        self.searchClimbingGymUseCase = searchClimbingGymUseCase
    }
    
    func transform(input: Input) -> Output {
        let climbingGymListRelay = BehaviorRelay(value: climbingGymList)
        let sortStatusArrayRelay = BehaviorRelay(value: sortStatusArray)
        
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
                    let sortedClimbingGymList = owner.sortClimbingGymList(climbingGymList: gymList)
                    owner.climbingGymList = sortedClimbingGymList
                    climbingGymListRelay.accept(sortedClimbingGymList)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        zip(input.sortButtonsTapped, SortType.allCases)
            .forEach { event, sortType in
                event
                    .bind(with: self) { owner, _ in
                        owner.sortStatusArray[sortType.rawValue].toggle()
                        sortStatusArrayRelay.accept(owner.sortStatusArray)

                        let sortedClimbingGymList = owner.sortClimbingGymList(climbingGymList: owner.climbingGymList)

                        climbingGymListRelay.accept(sortedClimbingGymList)
                    }
                    .disposed(by: disposeBag)
            }

        return Output(gymList: climbingGymListRelay, sortStatusArray: sortStatusArrayRelay)
    }
}

extension ClimbingGymSearchViewModel {
    private func sortClimbingGymList(climbingGymList: [ClimbingGym]) -> [ClimbingGym] {
        var sortedClimbingGymList = climbingGymList
        print(sortedClimbingGymList)
        zip(sortStatusArray, SortType.allCases)
            .forEach { isEnabled, sortType in
                guard isEnabled else { return }

                switch sortType {
                case .isOpenNow:
                    sortedClimbingGymList = sortedClimbingGymList.filter { $0.isOpen }
                case .distance:
                    return
                case .rating:
                    sortedClimbingGymList = sortedClimbingGymList.sorted { $0.rate > $1.rate }
                }
            }
        
        print(sortedClimbingGymList)
        return sortedClimbingGymList
    }
}

extension ClimbingGymSearchViewModel {
    enum SortType: Int, CaseIterable {
        case isOpenNow = 0
        case distance
        case rating
        
        var title: String {
            switch self {
            case .isOpenNow:
                return "지금 영업 중"
            case .distance:
                return "거리순"
            case .rating:
                return "평점순"
            }
        }
    }
}
