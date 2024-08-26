//
//  CrewRecruitItemCollectionViewCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CrewRecruitItemCollectionViewCell: BaseCollectionViewCell {
    
    let titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    let likeButton = UIButton()
    
    let climbingTypeLabel = UILabel().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17)
        $0.numberOfLines = 1
    }
    
    let pinIconImageView = UIImageView().then {
        $0.image = UIImage.locationPinFill
        $0.contentMode = .scaleAspectFit
    }
    
    let climbingGymNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 1
        $0.textColor = .lightGray
    }
    
    let calendarIconImageView = UIImageView().then {
        $0.image = UIImage.calenderIcon
        $0.contentMode = .scaleAspectFit
    }
    
    let meetingDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 1
        $0.textColor = .lightGray
    }
    
    let hostProfileImageView = ProfileImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let hostNicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray.withAlphaComponent(0.8)
        $0.numberOfLines = 1
    }
    
    let peopleIconImageView = UIImageView().then {
        $0.image = UIImage.peopleIcon
        $0.contentMode = .scaleAspectFit
    }
    
    let participantStatusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray.withAlphaComponent(0.8)
        $0.numberOfLines = 1
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 15
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(titleImageView)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(climbingTypeLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(pinIconImageView)
        self.contentView.addSubview(climbingGymNameLabel)
        self.contentView.addSubview(calendarIconImageView)
        self.contentView.addSubview(meetingDateLabel)
        self.contentView.addSubview(hostProfileImageView)
        self.contentView.addSubview(hostNicknameLabel)
        self.contentView.addSubview(peopleIconImageView)
        self.contentView.addSubview(participantStatusLabel)
    }
    
    override func configureLayout() {
        titleImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(titleImageView.snp.height)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(titleImageView.snp.leading).offset(5)
            make.bottom.equalTo(titleImageView.snp.bottom).offset(-5)
            make.size.equalTo(15)
        }
        
        climbingTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalTo(titleImageView.snp.trailing).offset(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(climbingTypeLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleImageView.snp.trailing).offset(6)
            make.trailing.lessThanOrEqualToSuperview().offset(-35)
        }
        
        pinIconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleImageView.snp.trailing).offset(6)
            make.size.equalTo(7)
        }
        
        climbingGymNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(pinIconImageView.snp.trailing).offset(3)
            make.trailing.lessThanOrEqualToSuperview().offset(-35)
        }
        
        hostProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(climbingGymNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleImageView.snp.trailing).offset(6)
            make.size.equalTo(15)
        }
        
        hostNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView)
            make.leading.equalTo(hostProfileImageView.snp.trailing).offset(3)
        }
        
        peopleIconImageView.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView)
            make.leading.equalTo(hostNicknameLabel.snp.trailing).offset(3)
        }
        
        participantStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView)
            make.leading.equalTo(peopleIconImageView.snp.trailing).offset(3)
        }
    }
    
    func bind(item: CrewRecruitItem) {
        let likeImage = item.isLike ? UIImage.heartFillIcon?.withTintColor(.red) : UIImage.heartIcon?.withTintColor(.white)

        titleImageView.kf.setImage(with: URL(string: item.titleImage))
        likeButton.setImage(likeImage, for: .normal)
        climbingTypeLabel.text = item.climbingType.title
        titleLabel.text = item.title
        climbingGymNameLabel.text = item.climbingGymName
        meetingDateLabel.text = item.meetingDate
        hostNicknameLabel.text = item.creator.nickName
        participantStatusLabel.text = item.participationStatus
        
        self.hostProfileImageView.kf.setImage(with: URL(string: item.creator.profileImage ?? "")) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.hostProfileImageView.image = .emptyProfileIcon
                }
            }
        }
    }
}
