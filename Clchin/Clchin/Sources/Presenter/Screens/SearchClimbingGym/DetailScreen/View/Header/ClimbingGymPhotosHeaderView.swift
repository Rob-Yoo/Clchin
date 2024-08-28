//
//  ClimbingGymPhotosHeaderView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/28/24.
//

import UIKit
import SnapKit
import Then
import GooglePlaces

final class ClimbingGymPhotosHeaderView: UICollectionReusableView {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let isOpenBadgeView = OpenBadgeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(isOpenBadgeView)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        isOpenBadgeView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
    }
    
    func bind(photo: GMSPlacePhotoMetadata, isOpen: Bool) {
        let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photo, maxSize: CGSizeMake(500, 500))

        GMSPlacesClient.shared().fetchPhoto(with: fetchPhotoRequest) { [weak self] image, error in
            guard let image, error == nil else {
                print(error?.localizedDescription)
              return }
            self?.imageView.image = image
        }
        
        let openText = isOpen ? "영업 중" : "영업 종료"
        let badgeColor = isOpen ? UIColor.systemGreen : UIColor.systemRed
        
        isOpenBadgeView.isOpenLabel.text = openText
        isOpenBadgeView.backgroundColor = badgeColor
    }
}

final class OpenBadgeView: BaseView {
    
    let isOpenLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 13, weight: .medium)
        $0.textAlignment = .center
    }
    
    override func configureView() {
        self.layer.cornerRadius = 16
    }
    
    override func configureHierarchy() {
        self.addSubview(isOpenLabel)
    }
    
    override func configureLayout() {
        isOpenLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
