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

final class PostCollectionViewCell: BaseCollectionViewCell {
    let userInfoView = UserInfoView()
    let postImageView = UIImageView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    let postActionStackView = PostActionStackView()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
            make.top.equalTo(postImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(38)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}


