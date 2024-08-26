//
//  CrewRecruitRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import UIKit
import SnapKit
import Then

final class CrewRecruitRootView: BaseView {
    
    let refreshControl = UIRefreshControl()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(CrewRecruitItemCollectionViewCell.self, forCellWithReuseIdentifier: CrewRecruitItemCollectionViewCell.identifier)
        $0.refreshControl = refreshControl
        $0.backgroundColor = .secondary
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
