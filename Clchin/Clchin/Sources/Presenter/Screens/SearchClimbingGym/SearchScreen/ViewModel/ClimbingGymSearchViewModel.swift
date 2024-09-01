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
        let searchText: ControlProperty<String>
        let searchBarCancelButtonTapped: ControlEvent<Void>
        let sortButtonsTapped: [ControlEvent<Void>]
        let userLocation: Observable<Result<CLLocationCoordinate2D, LocationServiceManager.LocationServiceError>>
    }
    
    struct Output {
        let gymList: BehaviorRelay<[ClimbingGym]>
        let sortStatusArray: BehaviorRelay<[Bool]>
        let authorizationAlertTrigger: PublishRelay<Void>
        let scrollToTopTrigger: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let searchClimbingGymUseCase: SearchClimbingGymUseCase
    
    private var userCoordinate = CLLocationCoordinate2D(latitude: .nan, longitude: .nan)
    private var searchText = ""
    private var climbingGymList = [ClimbingGym]()
    private var sortStatusArray = Array(repeating: false, count: SortType.allCases.count)
    
    private lazy var climbingGymListRelay = BehaviorRelay(value: climbingGymList)
    private lazy var sortStatusArrayRelay = BehaviorRelay(value: sortStatusArray)
    private let authorizationAlertTrigger = PublishRelay<Void>()
    private let scrollToTopTrigger = PublishRelay<Void>()
    
    init(searchClimbingGymUseCase: SearchClimbingGymUseCase) {
        self.searchClimbingGymUseCase = searchClimbingGymUseCase
    }
    
    func transform(input: Input) -> Output {
        
        input.userLocation
            .flatMap { [weak self] result in
                guard let self else {
                    return Single<Result<[ClimbingGym], Error>>.never()
                }
                
                return executeUseCaseWithUserLocation(result: result)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let gymList):
                    owner.emitClimbingGymList(list: gymList)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .skip(1)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { [weak self] text in
                guard let self else {
                    return Single<Result<[ClimbingGym], Error>>.never()
                }
                
                return executeUseCaseWithSearchText(text: text)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let gymList):
                    owner.emitClimbingGymList(list: gymList)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.searchBarCancelButtonTapped
            .bind(with: self) { owner, _ in
                if !owner.searchText.isEmpty {
                    input.searchText.onNext("")                    
                }
            }
            .disposed(by: disposeBag)
        
        zip(input.sortButtonsTapped, SortType.allCases)
            .forEach { event, sortType in
                event
                    .bind(with: self) { owner, _ in
                        owner.emitSortedClimbingGymList(sortType: sortType)
                    }
                    .disposed(by: disposeBag)
            }

        return Output(gymList: climbingGymListRelay, sortStatusArray: sortStatusArrayRelay, authorizationAlertTrigger: authorizationAlertTrigger,
            scrollToTopTrigger: scrollToTopTrigger
        )
    }
}

//MARK: - Execute UseCase
extension ClimbingGymSearchViewModel {
    private func executeUseCaseWithUserLocation(result: Result<CLLocationCoordinate2D, LocationServiceManager.LocationServiceError>) -> Single<Result<[ClimbingGym], any Error>> {
        
        switch result {
        case .success(let coord):
            userCoordinate = coord
        case .failure:
            authorizationAlertTrigger.accept(())
        }
        
        return self.searchClimbingGymUseCase.execute(textQuery: searchText, userCoordinate: userCoordinate)
    }
    
    private func executeUseCaseWithSearchText(text: String) -> Single<Result<[ClimbingGym], Error>> {
        searchText = text
        return self.searchClimbingGymUseCase.execute(textQuery: searchText, userCoordinate: userCoordinate)
    }
}

//MARK: - Emit Climbing Gym List
extension ClimbingGymSearchViewModel {
    private func emitClimbingGymList(list: [ClimbingGym]) {
        let sortedClimbingGymList = sortClimbingGymList(climbingGymList: list)
        
        climbingGymList = sortedClimbingGymList
        climbingGymListRelay.accept(sortedClimbingGymList)
        if !climbingGymList.isEmpty {
            scrollToTopTrigger.accept(())
        }
    }
    
    private func emitSortedClimbingGymList(sortType: SortType) {
        sortStatusArray[sortType.rawValue].toggle()
        sortStatusArrayRelay.accept(sortStatusArray)

        let sortedClimbingGymList = sortClimbingGymList(climbingGymList: climbingGymList)

        climbingGymListRelay.accept(sortedClimbingGymList)
        if !sortedClimbingGymList.isEmpty {
            scrollToTopTrigger.accept(())
        }
    }
    
    private func sortClimbingGymList(climbingGymList: [ClimbingGym]) -> [ClimbingGym] {
        var sortedClimbingGymList = climbingGymList
        
        zip(sortStatusArray, SortType.allCases)
            .forEach { isEnabled, sortType in
                guard isEnabled else { return }

                switch sortType {
                case .isOpenNow:
                    sortedClimbingGymList = sortedClimbingGymList.filter { $0.isOpen }
                case .distance:
                    sortedClimbingGymList = sortedClimbingGymList.sorted { $0.distance < $1.distance }
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
