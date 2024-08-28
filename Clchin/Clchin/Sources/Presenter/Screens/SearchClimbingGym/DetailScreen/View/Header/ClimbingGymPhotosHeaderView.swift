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
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(photo: GMSPlacePhotoMetadata) {
        let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photo, maxSize: CGSizeMake(500, 500))

        GMSPlacesClient.shared().fetchPhoto(with: fetchPhotoRequest) { [weak self] image, error in
            guard let image, error == nil else {
                print(error?.localizedDescription)
              return }
            self?.imageView.image = image
        }
    }
}
