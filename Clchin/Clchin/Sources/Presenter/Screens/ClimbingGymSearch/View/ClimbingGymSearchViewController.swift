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
    
    override func bindViewModel() {
        let input = ClimbingGymSearchViewModel.Input(viewDidLoad: self.rx.viewDidLoad, searchText: contentView.searchController.searchBar.rx.text.orEmpty)
        let output = self.viewModel.transform(input: input)
        
        output.gymList
            .observe(on: MainScheduler.instance)
            .bind(to: contentView.collectionView.rx.items(cellIdentifier: ClimbingGymCollectionViewCell.identifier, cellType: ClimbingGymCollectionViewCell.self)) { item, element, cell in
                cell.bind(gym: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "암장 검색"
        self.navigationItem.searchController = contentView.searchController
    }
}
