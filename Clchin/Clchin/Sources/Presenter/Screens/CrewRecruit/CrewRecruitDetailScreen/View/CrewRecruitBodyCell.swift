//
//  CrewRecruitBodyCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/31/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CrewRecruitBodyCell: BaseCollectionViewCell {
    let hostProfileImageView = ProfileImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let hostNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    let recruitTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    override func configureView() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .customBlack
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(hostProfileImageView)
        self.contentView.addSubview(hostNameLabel)
        self.contentView.addSubview(recruitTextLabel)
    }
    
    override func configureLayout() {
        hostProfileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
        
        hostNameLabel.snp.makeConstraints { make in
            make.top.equalTo(hostProfileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        recruitTextLabel.snp.makeConstraints { make in
            make.top.equalTo(hostNameLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func bind(model: BodySectionModel) {
        self.hostProfileImageView.kf.setImage(with: URL(string: model.hostProfileImageURL ?? "")) { result in
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
        
        hostNameLabel.text = model.hostName
        recruitTextLabel.text = model.recruitText
    }
}
