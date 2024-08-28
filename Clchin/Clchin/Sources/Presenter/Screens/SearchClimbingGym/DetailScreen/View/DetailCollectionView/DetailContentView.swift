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
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let openTimeTitleLabel = UILabel().then {
        $0.text = "운영 시간"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    let openingHourView = OpeningHourView()
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(gymNameLabel)
        self.addSubview(contentOptionButtonStackView)
        self.addSubview(locationInfoView)
        self.addSubview(lineView)
        self.addSubview(openTimeTitleLabel)
        self.addSubview(openingHourView)
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
            make.height.equalTo(locationInfoView.snp.width).multipliedBy(0.7)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(locationInfoView.snp.bottom).offset(25)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        openTimeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(20)
        }
        
        openingHourView.snp.makeConstraints { make in
            make.top.equalTo(openTimeTitleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(150)
            make.width.equalTo(280)
        }
    }
    
    func bind(gymName: String, openingHours: [String]) {
        var days = [String]()
        var openHours = [String]()
        
        self.gymNameLabel.text = gymName
        
        for openingHour in openingHours {
            let components = openingHour.components(separatedBy: ": ")
            let (day, hour) = (components[0], components[1])
            days.append(day)
            openHours.append(hour)
        }
        
        openingHourView.openingHourLabelStackView.bind(days: days, openingHours: openHours)
    }
}

extension Reactive where Base: DetailContentView {
    var binder: Binder<ClimbingGym> {
        return Binder(base) { base, gym in
            base.bind(gymName: gym.name, openingHours: gym.openingHours)
        }
    }
}
