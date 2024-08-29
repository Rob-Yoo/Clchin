//
//  PostImageCollectionView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/24/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PostImageCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(imageURL: String) {
        imageView.kf.setImage(with: URL(string: imageURL))
    }
}
