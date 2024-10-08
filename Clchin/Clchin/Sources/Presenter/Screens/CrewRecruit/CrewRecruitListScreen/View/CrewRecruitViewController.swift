//
//  CrewRecruitViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CrewRecruitViewController: BaseViewController<CrewRecruitRootView> {
    private let viewModel: CrewRecruitViewModel
    
    init(viewModel: CrewRecruitViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.navigationController?.navigationBar.isHidden = false
        configureNavBar()
    }
    
    override func bindViewModel() {
        let input = CrewRecruitViewModel.Input(
            crewRecruitRequestTrigger: BehaviorRelay(value: ()),
            refreshControlValueChanged: contentView.refreshControl.rx.controlEvent(.valueChanged),
            crewRecruitItemSelected: contentView.collectionView.rx.itemSelected
        )
        let output = self.viewModel.transform(input: input)
        
        output.crewRecruitItemList
            .bind(to: contentView.collectionView.rx.items(cellIdentifier: CrewRecruitItemCollectionViewCell.identifier, cellType: CrewRecruitItemCollectionViewCell.self)) { item, element, cell in
                cell.bind(item: element)
            }
            .disposed(by: disposeBag)
        
        output.refreshControlShouldStop
            .map { _ in false }
            .bind(to: contentView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.selectedCrewRecruit
            .bind(with: self) { owner, crewRecruit in
                let detailVC = CrewRecruitDetailViewController(viewModel: CrewRecruitDetailViewModel(crewRecruit: crewRecruit))
                
                detailVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension CrewRecruitViewController {
    private func configureNavBar() {
        let appearence = UINavigationBarAppearance()
        
        appearence.configureWithOpaqueBackground()
        appearence.backgroundColor = .black
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        self.navigationController?.navigationBar.standardAppearance = appearence
        configureLeftNavBar()
    } 
    
    private func configureLeftNavBar() {
        let titleLabel = UILabel().then {
            $0.text = "크루모집"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        let navTitleView = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = navTitleView
    }
}
