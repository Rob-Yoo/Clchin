//
//  ClimbingGymDetailViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import RxDataSources

final class ClimbingGymDetailViewController: BaseViewController<ClimbingGymDetailRootView> {
    
    private let viewModel: ClimbingGymDetailViewModel
    
    init(viewModel: ClimbingGymDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func bindViewModel() {
        let input = ClimbingGymDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        let datasource = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, ClimbingGym>> { datasource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClimbingGymDetailCollectionViewCell.identifier, for: indexPath) as? ClimbingGymDetailCollectionViewCell else { return UICollectionViewCell() }
            
            cell.viewModel = ClimbingGymDetailCellViewModel(climbingGym: output.gymDetail.value)
            return cell
        }
        
        datasource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ClimbingGymPhotosHeaderView.identifier, for: indexPath) as? ClimbingGymPhotosHeaderView else { return UICollectionReusableView() }
            if !(output.gymDetail.value.photos.isEmpty) {
                header.bind(photo: output.gymDetail.value.photos[0], isOpen: output.gymDetail.value.isOpen)
            }
            return header
        }
        
        let section = [SectionModel(model: 0, items: [output.gymDetail.value])]
        
        
        output.gymDetail
            .map { [SectionModel(model: 0, items: [$0])] }
            .bind(to: contentView.collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
}

