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
    
    let climbingTypeTagView = ClimbingTypeTagView()
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.numberOfLines = 1
    }
    
    let pinIconImageView = UIImageView().then {
        $0.image = UIImage.locationPinFillIcon
        $0.contentMode = .scaleAspectFit
    }
    
    let climbingGymNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.numberOfLines = 1
        $0.textColor = .gray
    }
    
    let calendarIconImageView = UIImageView().then {
        $0.image = UIImage.calenderIcon
        $0.contentMode = .scaleAspectFit
    }
    
    let meetingDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13)
        $0.numberOfLines = 1
        $0.textColor = .gray
    }
    
    let hostProfileImageView = ProfileImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let hostNicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.numberOfLines = 1
    }
    
    let peopleIconImageView = UIImageView().then {
        $0.image = UIImage.peopleIcon
        $0.contentMode = .scaleAspectFit
    }
    
    let participantStatusLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
        $0.numberOfLines = 1
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 15
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(titleImageView)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(climbingTypeTagView)
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
            make.verticalEdges.equalToSuperview().inset(9)
            make.leading.equalToSuperview().offset(9)
            make.width.equalTo(titleImageView.snp.height)
        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(titleImageView.snp.leading).offset(7)
            make.bottom.equalTo(titleImageView.snp.bottom).offset(-7)
            make.size.equalTo(20)
        }
        
        climbingTypeTagView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.width.equalTo(76)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(climbingTypeTagView.snp.bottom).offset(5)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-35)
        }
        
        pinIconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.size.equalTo(15)
        }
        
        climbingGymNameLabel.snp.makeConstraints { make in
            make.top.equalTo(pinIconImageView)
            make.leading.equalTo(pinIconImageView.snp.trailing).offset(3)
            make.trailing.lessThanOrEqualToSuperview().offset(-35)
        }
        
        calendarIconImageView.snp.makeConstraints { make in
            make.top.equalTo(pinIconImageView.snp.bottom).offset(7)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.size.equalTo(15)
        }
        
        meetingDateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarIconImageView)
            make.leading.equalTo(calendarIconImageView.snp.trailing).offset(3)
            make.trailing.lessThanOrEqualToSuperview().offset(-35)
        }
        
        hostProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(calendarIconImageView.snp.bottom).offset(7)
            make.leading.equalTo(titleImageView.snp.trailing).offset(10)
            make.size.equalTo(15)
        }
        
        hostNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView)
            make.leading.equalTo(hostProfileImageView.snp.trailing).offset(3)
        }
        
        peopleIconImageView.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView)
            make.leading.equalTo(hostNicknameLabel.snp.trailing).offset(3)
            make.size.equalTo(15)
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
        climbingTypeTagView.typeLabel.text = item.climbingType.title
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

final class ClimbingTypeTagView: BaseView {
    let typeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .black.withAlphaComponent(0.7)
    }
    
    override func configureView() {
        self.backgroundColor = .secondary
        self.layer.cornerRadius = 13
    }
    
    override func configureHierarchy() {
        self.addSubview(typeLabel)
    }
    
    override func configureLayout() {
        typeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
