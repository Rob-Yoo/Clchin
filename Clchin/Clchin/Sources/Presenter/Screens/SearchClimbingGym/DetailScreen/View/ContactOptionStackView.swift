//
//  ContactOptionStackView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class ContactOptionButtonStackView: BaseStackView {
    let phoneButton = ContactOptionView().then {
        $0.imageView.image = .phoneIcon
    }
    
    let locationPinButton = ContactOptionView().then {
        $0.imageView.image = .locationPinIcon
    }
    
    let instaButton = ContactOptionView().then {
        $0.imageView.image = .instaIcon
    }
    
    private var buttons: [UIView] {
        return [phoneButton, locationPinButton, instaButton]
    }
    
    override func configureStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
        self.buttons.forEach { self.addArrangedSubview($0) }
    }
}

final class ContactOptionView: BaseView {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureView() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.8
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }

    override func configureHierarchy() {
        self.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        self.addSubview(imageView)
    }
    
}
