//
//  LoungeViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoungeViewModel: ViewModelType {
    struct Input {
        let postRequestTrigger: BehaviorRelay<Void>
        let refreshControlValueChanged: ControlEvent<Void>
        let prefetchItems: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let postItemList: PublishRelay<[PostItem]>
        let refreshControlShouldStop: PublishRelay<Void>
    }
    
    private var isPagination = false
    private var postItemList = [PostItem]()
    private let postServiceUseCase: PostServiceUseCase

    private let refreshControlShouldStop = PublishRelay<Void>()
    private let postItemListRelay = PublishRelay<[PostItem]>()
    private let disposeBag = DisposeBag()
    
    init(postServiceUseCase: PostServiceUseCase) {
        self.postServiceUseCase = postServiceUseCase
    }
    
    func transform(input: Input) -> Output {
        input.postRequestTrigger
            .flatMap { [weak self] in
                guard let self else { return Single<Result<[Post], NetworkError>>.never() }
                
                return postServiceUseCase.fetchPostList(isPagination: isPagination)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let postList):
                    owner.emitPostItemListRelay(postList: postList)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlValueChanged
            .bind(with: self) { owner, _ in
                owner.isPagination = false
                input.postRequestTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .subscribe(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if (owner.postItemList.count - 2 == indexPath.item) {
                        owner.isPagination = true
                        input.postRequestTrigger.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postItemList: postItemListRelay, refreshControlShouldStop: refreshControlShouldStop)
    }
}

//MARK: - Emit Relay
extension LoungeViewModel {
    private func emitPostItemListRelay(postList: [Post]) {
        let now = Date.now
        let postItemList = postList.map {
            let elapsedTime = self.makeElapsedTime(createdAt: $0.createdAt, now: now)

            return PostItem.makePostItem( post: $0, elapsedTime: elapsedTime)
        }
        
        if (isPagination) {
            self.postItemList.append(contentsOf: postItemList)
        } else {
            self.postItemList = postItemList
            refreshControlShouldStop.accept(())
        }
        
        postItemListRelay.accept(self.postItemList)
    }
}

//MARK: - Presentaion Logic
extension LoungeViewModel {
    private func makeElapsedTime(createdAt: Date, now: Date) -> String {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createdAt, to: now)
        
        if let years = components.year, years > 0 {
            return DateFormatManger.shared.convertToString(format: "yyyy년 M월 d일", target: createdAt)
        }
        
        if let months = components.month, months > 0 {
            return DateFormatManger.shared.convertToString(format: "M월 d일", target: createdAt)
        }
        
        if let days = components.day, days > 0 {
            if days < 7 {
                return "\(days)일 전"
            } else {
                return DateFormatManger.shared.convertToString(format: "M월 d일", target: createdAt)
            }
        }
        
        if let hours = components.hour, hours > 0 {
            return "\(hours)시간 전"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes)분 전"
        }
        
        if let seconds = components.second, seconds >= 0 {
            return "방금 전"
        }
        
        return ""
    }
}
