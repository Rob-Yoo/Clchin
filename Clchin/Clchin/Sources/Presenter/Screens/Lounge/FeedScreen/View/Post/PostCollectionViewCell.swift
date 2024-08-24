//
//  PostCollectionViewCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Kingfisher
//
//extension Reactive where Base: UIImageView {
//    var binder: Binder<[String]> {
//        return Binder(base) { base, images in
//            base.bind(creator: postItem.creator, climbingGymName: postItem.climbingGymName, elapsedTime: postItem.elapsedTime)
//        }
//    }


final class PostCollectionViewCell: BaseCollectionViewCell {
    let userInfoView = UserInfoView()
    let postImageView = UIImageView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let postActionStackView = PostActionStackView()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        postImageView.image = nil
        postActionStackView.likeActionView.likeCountLabel.text = nil
        postActionStackView.commentActionView.commentCountLabel.text = nil
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(userInfoView)
        self.addSubview(postImageView)
        self.addSubview(postActionStackView)
    }
    
    override func configureLayout() {
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(45)
        }
        
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(postImageView.snp.width)
        }
        
        postActionStackView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(38)
            make.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
    }
    
    func loadImages(imageURLs: [String]) {
        for imageURL in imageURLs {
            self.postImageView.kf.setImage(with: URL(string: imageURL))
        }
    }
}


