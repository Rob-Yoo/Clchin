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
        $0.backgroundColor = .lightGray
    }
    
    let joinButton = JoinButton()
    
    override func configureView() {
        self.backgroundColor = .customGray
    }
    
    override func configureHierarchy() {
        self.addSubview(lineView)
        self.addSubview(joinButton)
    }
    
    override func configureLayout() {
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.1)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(47)
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
