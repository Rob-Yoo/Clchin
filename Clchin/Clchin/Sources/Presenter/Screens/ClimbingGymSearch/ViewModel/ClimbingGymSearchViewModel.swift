//
//  ClimbingGymSearchViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import RxSwift
import RxCocoa
import CoreLocation
import Then

final class ClimbingGymSearchViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let sortButtonsTapped: [ControlEvent<Void>]
//        let userLocation: Observable<Result<CLLocationCoordinate2D, LocationServiceManager.LocationServiceError>>
    }
    
    struct Output {
        let gymList: BehaviorRelay<[ClimbingGym]>
        let sortStatusArray: BehaviorRelay<[Bool]>
        let authorizationAlertTrigger: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let searchClimbingGymUseCase: SearchClimbingGymUseCase
    
    private var userCoordinate = CLLocationCoordinate2D(latitude: .nan, longitude: .nan)
    private var climbingGymList = [ClimbingGym]()
    private var sortStatusArray = Array(repeating: false, count: SortType.allCases.count)
    
    init(searchClimbingGymUseCase: SearchClimbingGymUseCase) {
        self.searchClimbingGymUseCase = searchClimbingGymUseCase
    }
    
    func transform(input: Input) -> Output {
        let climbingGymListRelay = BehaviorRelay(value: climbingGymList)
        let sortStatusArrayRelay = BehaviorRelay(value: sortStatusArray)
        let authorizationAlertTrigger = PublishRelay<Void>()
        
        input.viewDidLoad
            .flatMap { LocationServiceManager.shared.requestLocation() }
            .flatMap { [weak self] result in
                guard let self else {
                    return Single<Result<[ClimbingGym], Error>>.never()
                }
                
                switch result {
                case .success(let coord):
                    self.userCoordinate = coord
                    return self.searchClimbingGymUseCase.execute(textQuery: "", userCoordinate: coord)
                case .failure:
                    authorizationAlertTrigger.accept(())
                    return self.searchClimbingGymUseCase.execute(textQuery: "", userCoordinate: self.userCoordinate)
                }
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
        
        input.searchText
            .skip(1)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { [weak self] text in
                guard let self else {
                    return Single<Result<[ClimbingGym], Error>>.never()
                }
                return self.searchClimbingGymUseCase.execute(textQuery: text, userCoordinate: self.userCoordinate)
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

        return Output(gymList: climbingGymListRelay, sortStatusArray: sortStatusArrayRelay, authorizationAlertTrigger: authorizationAlertTrigger)
    }
}

extension ClimbingGymSearchViewModel {
    private func sortClimbingGymList(climbingGymList: [ClimbingGym]) -> [ClimbingGym] {
        var sortedClimbingGymList = climbingGymList
        
        zip(sortStatusArray, SortType.allCases)
            .forEach { isEnabled, sortType in
                guard isEnabled else { return }

                switch sortType {
                case .isOpenNow:
                    sortedClimbingGymList = sortedClimbingGymList.filter { $0.isOpen }
                case .distance:
                    sortedClimbingGymList = sortedClimbingGymList.sorted { $0.coordinate.distance(from: userCoordinate) < $1.coordinate.distance(from: userCoordinate) }
                case .rating:
                    sortedClimbingGymList = sortedClimbingGymList.sorted { $0.rate > $1.rate }
                }
            }
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
