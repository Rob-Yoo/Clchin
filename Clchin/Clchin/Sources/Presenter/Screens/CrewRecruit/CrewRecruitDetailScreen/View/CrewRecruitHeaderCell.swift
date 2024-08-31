//
//  CrewRecruitHeaderCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/31/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CrewRecruitHeaderCell: BaseCollectionViewCell {
    
    private let climbingTypeTagView = ClimbingTypeTagView()
    
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    private let recruitTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .black)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override func configureView() {
        self.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .customBlack
        
        configureGradient()
    }
    
    override func configureHierarchy() {
        self.addSubview(headerImageView)
        self.layer.addSublayer(gradientLayer)
        self.addSubview(climbingTypeTagView)
        self.addSubview(recruitTitleLabel)
    }
    
    override func configureLayout() {
        
        headerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recruitTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        climbingTypeTagView.snp.makeConstraints { make in
            make.bottom.equalTo(recruitTitleLabel.snp.top).offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(76)
            make.height.equalTo(24)
        }
    }
    
    private func configureGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.7, 1.0]
        gradientLayer.frame = contentView.bounds
    }
    
    func bind(model: HeaderSectionModel) {
        self.headerImageView.kf.setImage(with: URL(string: model.imageURL)) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.headerImageView.image = .emptyProfileIcon
                }
            }
        }
        
        self.climbingTypeTagView.typeLabel.text = model.climbingType
        self.recruitTitleLabel.text = model.recruitTitle
    }
}
