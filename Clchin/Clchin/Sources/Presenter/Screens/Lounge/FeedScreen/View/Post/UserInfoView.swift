//
//  UserInfoView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift

extension Reactive where Base: UserInfoView {
    var binder: Binder<PostItem> {
        return Binder(base) { base, postItem in
            base.bind(creator: postItem.creator, climbingGymName: postItem.climbingGymName, elapsedTime: postItem.elapsedTime)
        }
    }
}

final class UserInfoView: BaseView {
    let profileImageView = ProfileImageView(frame: .zero)
        .then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    let userNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    let climbingGymLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .light)
    }
    let elapsedTimeLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 11, weight: .light)
        $0.textAlignment = .right
    }
    
    override func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        self.addSubview(climbingGymLabel)
        self.addSubview(elapsedTimeLabel)
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
        
        climbingGymLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
        
        elapsedTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-7)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    fileprivate func bind(creator: Creator, climbingGymName: String, elapsedTime: String) {
        userNameLabel.text = creator.nickName
        climbingGymLabel.text = climbingGymName
        elapsedTimeLabel.text = elapsedTime

        self.profileImageView.kf.setImage(with: URL(string: creator.profileImage ?? "")) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.image = .emptyProfileIcon
                }
            }
        }
    }
    
}
