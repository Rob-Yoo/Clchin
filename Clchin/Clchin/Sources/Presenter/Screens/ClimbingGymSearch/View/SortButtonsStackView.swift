//
//  SortButtonsStackView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/17/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SortButtonsStackView: BaseStackView {
    var sortButtons: [SortButton] = ClimbingGymSearchViewModel.SortType.allCases.map {
        let title = $0.title
        let button = SortButton().then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
            $0.isSelected = false
        }
        button.snp.makeConstraints { make in
            make.width.equalTo(button.titleLabel!.intrinsicContentSize.width + 20)
        }
        
        return button
    }
    
    override func configureStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 10
        self.sortButtons.forEach { self.addArrangedSubview($0) }
    }
    
    fileprivate func bind(statusArray: [Bool]) {
        zip(sortButtons, statusArray)
            .forEach { (button, isSelected) in
                button.isSelected = isSelected
            }
    }
}

extension Reactive where Base: SortButtonsStackView {
    var binder: Binder<[Bool]> {
        return Binder(base) { base, statusArray in
            base.bind(statusArray: statusArray)
        }
    }
}

