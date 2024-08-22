//
//  LoungeViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Post {
    let userName: String
    let createdAt: String
    let isLike: Bool
    let likeCount: Int
    let commentCount: Int
    let isBookMarked: Bool
}

final class LoungeViewController: BaseViewController<LoungeRootView> {
    let a = DefaultPostRepository()
    private let list: [Post] = [
        Post(userName: "axcvxasdf", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
        Post(userName: "rgsdhfsdgh", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
        Post(userName: "3qgdafb", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
        Post(userName: "shbcvbewh3t", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
        Post(userName: "uyktyik", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
        Post(userName: "zcxvbcvnsgh", createdAt: "\(Int.random(in: 1...14))분전", isLike: Bool.random(), likeCount: Int.random(in: 90...5000), commentCount: Int.random(in: 90...900), isBookMarked: Bool.random()),
    ]
    
    override func bindViewModel() {
        Observable.just(list)
            .bind(to: contentView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) { item, element, cell in
                Observable.just(element)
                    .bind(to: cell.userInfoView.rx.binder, cell.postActionStackView.rx.binder)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
//        a.fetchPostList(next: nil) { result in
//            print("-----------")
//            switch result {
//            case .success(let res):
//                print(res.data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
