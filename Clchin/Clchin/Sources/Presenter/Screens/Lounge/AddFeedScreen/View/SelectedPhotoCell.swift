//
//  SelectedPhotoCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/30/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SelectedPhotoCell: BaseCollectionViewCell {
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let removeButton = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.setTitle("x", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(removeButton)
    }
    
    override func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.size.equalTo(20)
        }
    }
    
    func bind(photo: UIImage) {
        photoImageView.image = photo
    }
}
