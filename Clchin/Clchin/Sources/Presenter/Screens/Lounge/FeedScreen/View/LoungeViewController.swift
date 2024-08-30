//
//  LoungeViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LoungeViewController: BaseViewController<LoungeRootView> {
    private let viewModel: LoungeViewModel
    
    init(viewModel: LoungeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    override func bindViewModel() {
        let input = LoungeViewModel.Input(
            postRequestTrigger: BehaviorRelay(value: ()),
            refreshControlValueChanged: contentView.refreshControl.rx.controlEvent(.valueChanged),
            prefetchItems: contentView.collectionView.rx.prefetchItems)
        let output = viewModel.transform(input: input)
        
        output.postItemList
            .bind(to: contentView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) { item, element, cell in
                Observable.just(element)
                    .bind(to: cell.creatorInfoView.rx.binder)
                    .disposed(by: cell.disposeBag)
                cell.bind(post: element)
                
                cell.readMoreActionLabel.rx.tapGesture()
                    .when(.recognized)
                    .bind { _ in
                        cell.removeReadMoreActionLabel()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tapGesture()
                    .when(.recognized)
                    .bind(with: self) { owner, _ in
                        let nc = NavigationController(rootViewController: CommentViewController())
                        
                        nc.modalPresentationStyle = .pageSheet
                        self.present(nc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.commentActionLabel.rx.tapGesture()
                    .when(.recognized)
                    .bind(with: self) { owner, _ in
                        let nc = NavigationController(rootViewController: CommentViewController())
                        
                        nc.modalPresentationStyle = .pageSheet
                        self.present(nc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.refreshControlShouldStop
            .map { _ in false }
            .bind(to: contentView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        contentView.writePostBarButton.rx.tap
            .bind(with: self) { owner, _ in
                let nextVC = AddFeedViewController(viewModel: AddFeedViewModel(postUseCase: DefaultPostServiceUseCase(postRepository: DefaultPostRepository())))
                
                nextVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Cofigure NavigationBar
extension LoungeViewController {
    private func configureNavBar() {
        let appearence = UINavigationBarAppearance()
        
        appearence.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        self.navigationController?.navigationBar.standardAppearance = appearence
        configureLeftNavBar()
        configureRightNavBar()
    }
    
    private func configureLeftNavBar() {
        let titleLabel = UILabel().then {
            $0.text = "라운지"
            $0.textColor = .black.withAlphaComponent(0.85)
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        let navTitleView = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = navTitleView
    }
    
    private func configureRightNavBar() {
        self.navigationItem.rightBarButtonItem = contentView.writePostBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
}
