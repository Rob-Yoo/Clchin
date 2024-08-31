//
//  CrewRecruitFooterCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/31/24.
//

import UIKit
import SnapKit
import Then

final class CrewRecruitFooterCell: BaseCollectionViewCell {
    override func configureView() {
        self.contentView.backgroundColor = .customBlack
        self.contentView.layer.cornerRadius = 15
    }
    
    func bind(model: FooterSectionModel) {
        
    }
}
