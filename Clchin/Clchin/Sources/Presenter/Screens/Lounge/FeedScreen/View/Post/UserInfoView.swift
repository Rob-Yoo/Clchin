//
//  UserInfoView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

extension Reactive where Base: UserInfoView {
    var binder: Binder<Post> {
        return Binder(base) { base, post in
            base.bind(userName: post.userName, createdAt: post.createdAt)
        }
    }
}

final class UserInfoView: BaseView {
    let profileImageView = ProfileImageView(frame: .zero)
        .then {
            $0.image = .emptyProfileIcon
        }
    let userNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    let createdTimeLabel = UILabel().then {
        $0.textColor = .lightGray.withAlphaComponent(0.7)
        $0.font = .systemFont(ofSize: 11)
    }
    
    override func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        self.addSubview(createdTimeLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(3)
            make.leading.equalToSuperview().offset(7)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
        
        createdTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
    }
    
    fileprivate func bind(userName: String, createdAt: String) {
        userNameLabel.text = userName
        createdTimeLabel.text = createdAt
    }
    
}
