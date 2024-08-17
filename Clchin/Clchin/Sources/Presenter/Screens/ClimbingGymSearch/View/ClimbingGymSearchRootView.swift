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
    
    let sortButtonsStackView = SortButtonsStackView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(ClimbingGymCollectionViewCell.self, forCellWithReuseIdentifier: ClimbingGymCollectionViewCell.identifier)
        $0.keyboardDismissMode = .onDrag
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
        self.addSubview(sortButtonsStackView)
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        
        sortButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalTo(35)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonsStackView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
