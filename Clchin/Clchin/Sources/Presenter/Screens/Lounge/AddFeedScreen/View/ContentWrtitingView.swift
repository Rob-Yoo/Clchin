//
//  ContentWrtitingView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

extension Reactive where Base: PhotoSelectionButtonView {
    var binder: Binder<Int> {
        return Binder(base) { base, selectedPhotoCount in
            base.bind(photoCount: selectedPhotoCount)
        }
    }
}

final class ContentWrtitingView: BaseView {
    
    let photoSelectionButtonView = PhotoSelectionButtonView()
    
    lazy var selectedImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(SelectedPhotoCell.self, forCellWithReuseIdentifier: SelectedPhotoCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    let contentTextView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.showsVerticalScrollIndicator = true
        $0.textColor = .black
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 10
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }
    
    override func configureHierarchy() {
        self.addSubview(photoSelectionButtonView)
        self.addSubview(selectedImageCollectionView)
        self.addSubview(contentTextView)
    }
    
    override func configureLayout() {
        photoSelectionButtonView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(60)
        }
        
        selectedImageCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(photoSelectionButtonView)
            make.leading.equalTo(photoSelectionButtonView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(photoSelectionButtonView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

final class PhotoSelectionButtonView: BaseView {
    
    let cameraImageView = UIImageView().then {
        $0.image = .cameraIcon
        $0.contentMode = .scaleAspectFill
    }
    
    let photoCountStatusLabel = UILabel().then {
        $0.text = "0 / 5"
        $0.textColor = .lightGray.withAlphaComponent(0.7)
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 10)
    }
    
    override func configureView() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
    
    override func configureHierarchy() {
        self.addSubview(cameraImageView)
        self.addSubview(photoCountStatusLabel)
    }
    
    override func configureLayout() {
        cameraImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        
        photoCountStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraImageView.snp.bottom).offset(3)
            make.centerX.equalTo(cameraImageView)
        }
    }
    
    func bind(photoCount: Int) {
        self.photoCountStatusLabel.text = "\(photoCount) / 5"
    }
}
