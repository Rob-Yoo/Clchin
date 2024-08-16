//
//  ClimbingGymSearchRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import SnapKit
import Then

final class ClimbingGymSearchRootView: BaseView {
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "암장 이름, 지역 검색"
        $0.searchBar.searchBarStyle = .prominent
        $0.searchBar.autocapitalizationType = .none
        $0.searchBar.autocorrectionType = .no
        $0.automaticallyShowsCancelButton = true
        $0.searchBar.tintColor = .black
        $0.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    let locationButton = LocationButton().then {
        $0.isSelected = false
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(ClimbingGymCollectionViewCell.self, forCellWithReuseIdentifier: ClimbingGymCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = width * 0.85
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        return layout
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(locationButton)
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(locationButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

