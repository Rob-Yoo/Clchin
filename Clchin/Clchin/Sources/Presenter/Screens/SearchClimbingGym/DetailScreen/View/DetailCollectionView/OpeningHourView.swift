//
//  OpeningHourView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class OpeningHourLabelView: BaseView {
    let dayLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let openingHourLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }
    
    override func configureHierarchy() {
        self.addSubview(dayLabel)
        self.addSubview(openingHourLabel)
    }
    
    override func configureLayout() {
        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        openingHourLabel.snp.makeConstraints { make in
            make.leading.equalTo(dayLabel.snp.trailing).offset(50)
            make.centerY.equalToSuperview()
        }
    }
}

final class OpeningHourLabelStackView: BaseStackView {
    let openingHourLabelViews = (0..<7).map { _ in
        OpeningHourLabelView()
    }
    
    override func configureStackView() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 3
        self.openingHourLabelViews.forEach { self.addArrangedSubview($0) }
    }
    
    func bind(days: [String], openingHours: [String]) {
        for (day, openingHourLabelView) in zip(days, openingHourLabelViews) {
            openingHourLabelView.dayLabel.text = day
        }
        
        for (openingHour, openingHourLabelView) in zip(openingHours, openingHourLabelViews) {
            openingHourLabelView.openingHourLabel.text = openingHour
        }
    }
}

final class OpeningHourView: BaseView {
    let openingHourLabelStackView = OpeningHourLabelStackView()
    
    override func configureView() {
        self.backgroundColor = .customGray
        self.layer.cornerRadius = 15
    }
    
    override func configureHierarchy() {
        self.addSubview(openingHourLabelStackView)
    }
    
    override func configureLayout() {
        openingHourLabelStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
