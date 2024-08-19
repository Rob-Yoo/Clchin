//
//  ClimbingGymSearchViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import GooglePlaces

final class ClimbingGymSearchViewController: BaseViewController<ClimbingGymSearchRootView> {

    private let viewModel: ClimbingGymSearchViewModel
    
    init(viewModel: ClimbingGymSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.navigationItem.title = "암장 검색"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white        
    }
    
    override func bindViewModel() {
        let input = ClimbingGymSearchViewModel.Input(
            searchText: contentView.searchController.searchBar.rx.text.orEmpty,
            searchBarCancelButtonTapped: contentView.searchController.searchBar.rx.cancelButtonClicked,
            sortButtonsTapped: contentView.sortButtonsStackView.sortButtons.map { $0.rx.tap },
            userLocation: LocationServiceManager.shared.requestLocation()
        )
        let output = self.viewModel.transform(input: input)
        
        output.gymList
            .observe(on: MainScheduler.instance)
            .bind(to: contentView.collectionView.rx.items(cellIdentifier: ClimbingGymCollectionViewCell.identifier, cellType: ClimbingGymCollectionViewCell.self)) { item, element, cell in
                cell.bind(gym: element)
            }
            .disposed(by: disposeBag)
        
        output.sortStatusArray
            .bind(to: contentView.sortButtonsStackView.rx.binder)
            .disposed(by: disposeBag)
        
        output.authorizationAlertTrigger
            .bind(with: self) { owner, _ in
                let alert = UIAlertController.makeLocationSettingAlert()
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.scrollToTopTrigger
            .bind(with: self) { owner, _ in
                owner.contentView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            .disposed(by: disposeBag)
        
        contentView.collectionView.rx.modelSelected(ClimbingGym.self)
            .bind(with: self) { owner, gym in
                let vc = ClimbingGymDetailViewController(viewModel: ClimbingGymDetailViewModel(climbingGym: gym))
                vc.hidesBottomBarWhenPushed = true
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = contentView.searchController
    }
}
