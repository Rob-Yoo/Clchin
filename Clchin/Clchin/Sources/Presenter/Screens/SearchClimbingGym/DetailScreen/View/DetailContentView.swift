//
//  DetailContentView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class DetailContentView: BaseView {
    let gymNameLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.numberOfLines = 0
    }
    
    let contentOptionButtonStackView = ContactOptionButtonStackView()
    
    let locationInfoView = LocationInfoView()
    
    override func configureView() {
        self.backgroundColor = .white
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        self.addSubview(gymNameLabel)
        self.addSubview(contentOptionButtonStackView)
        self.addSubview(locationInfoView)
    }
    
    override func configureLayout() {
        gymNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentOptionButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(gymNameLabel.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        locationInfoView.snp.makeConstraints { make in
            make.top.equalTo(contentOptionButtonStackView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
    }
    
    fileprivate func bind(gymName: String) {
        self.gymNameLabel.text = gymName
    }
}

extension Reactive where Base: DetailContentView {
    var binder: Binder<ClimbingGym> {
        return Binder(base) { base, gym in
            print(gym.phoneNumber, gym.website?.absoluteString)
            base.bind(gymName: gym.name)
        }
    }
}
