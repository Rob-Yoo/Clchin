//
//  FooterActionView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import UIKit
import SnapKit
import Then

final class FooterActionView: BaseView {
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    
    let heartButton = UIImageView().then {
        $0.image = UIImage.heartIcon?.withTintColor(.red)
        $0.isUserInteractionEnabled = true
    }
    
    let likeCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textColor = .red
        $0.textAlignment = .center
        $0.text = "3"
    }
    
    let joinButton = JoinButton()
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(lineView)
        self.addSubview(heartButton)
        self.addSubview(likeCountLabel)
        self.addSubview(joinButton)
    }
    
    override func configureLayout() {
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(30)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom).offset(3)
            make.centerX.equalTo(heartButton)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(heartButton.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(likeCountLabel)
        }
    }
}

final class JoinButton: BaseButton {
    override func configureButton() {
        self.tintColor = .white
        self.backgroundColor = .black
        self.setTitle("참여 신청하기", for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }

}
