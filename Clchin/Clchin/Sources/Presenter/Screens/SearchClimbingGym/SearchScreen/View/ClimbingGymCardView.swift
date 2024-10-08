//
//  ClimbingGymCardView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import Cosmos

final class ClimbingGymCardView: BaseView {
    
    let gymImageView = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .lightGray.withAlphaComponent(0.6)
        $0.layer.borderWidth = 0.1
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let addressLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13)
    }
    
    let ratingStackView = RatingStackView()
    
    let openingHourStackView = OpeningHourStackView()
    
    override func configureView() {
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    override func configureHierarchy() {
        self.addSubview(gymImageView)
        self.addSubview(nameLabel)
        self.addSubview(addressLabel)
        self.addSubview(ratingStackView)
        self.addSubview(openingHourStackView)
    }
    
    override func configureLayout() {
        gymImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(gymImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.leading.equalTo(nameLabel.snp.leading)
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
            make.leading.equalTo(addressLabel.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
            make.height.equalTo(15)
        }
        
        openingHourStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(8)
            make.leading.equalTo(ratingStackView.snp.leading)
            make.height.equalTo(15)
        }
    }
}

final class RatingStackView: BaseStackView {

    let ratingLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 13)
    }
    
    let ratingView = CosmosView().then {
        $0.settings.fillMode = .precise
        $0.settings.starSize = 15
        $0.settings.starMargin = 1
    }
    
    let userRatingCountLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 13)
    }
    
    let distanceLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 13)
    }
    
    private var arrangedViews: [UIView] {
        return [ratingLabel, ratingView, userRatingCountLabel, distanceLabel]
    }
    
    override func configureStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 3
        self.arrangedViews.forEach { self.addArrangedSubview($0) }
    }
}

final class OpeningHourStackView: BaseStackView {
    let isOpenLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    let openingHourLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 13)
    }
    
    private var arrangedViews: [UIView] {
        return [isOpenLabel, openingHourLabel]
    }
    
    override func configureStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 5
        self.arrangedViews.forEach { self.addArrangedSubview($0) }
    }
}
