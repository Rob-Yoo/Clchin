//
//  AddFeedRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class AddFeedRootView: BaseView {
    
    let addPostBarButton = UIBarButtonItem(title: "올리기", style: .plain, target: nil, action: nil).then {
        $0.tintColor = .lightGray
    }
    
    let placeIconImageView = UIImageView().then {
        $0.image = .locationPinFillIcon.withTintColor(.lightGray.withAlphaComponent(0.7))
        $0.contentMode = .scaleAspectFit
    }
    let gymNameTextField = UITextField().then {
        $0.placeholder = "암장 이름"
        $0.textColor = .black
        $0.borderStyle = .none
    }
    let lineView1 = UIView().then { $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }

    let contentWritingView = ContentWrtitingView()
    let lineView2 = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    
    let solvedTagView = TagView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    let solvedLevelColorTextField = UITextField().then {
        $0.placeholder = "난이도 색상"
        $0.borderStyle = .none
    }
    let lineView3 = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.7)
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(placeIconImageView)
        self.addSubview(gymNameTextField)
        self.addSubview(lineView1)
        self.addSubview(contentWritingView)
        self.addSubview(lineView2)
        self.addSubview(solvedTagView)
        self.addSubview(solvedLevelColorTextField)
        self.addSubview(lineView3)
    }
    
    override func configureLayout() {
        
        placeIconImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(25)
        }
        
        gymNameTextField.snp.makeConstraints { make in
            make.top.equalTo(placeIconImageView)
            make.leading.equalTo(placeIconImageView.snp.trailing).offset(10)
            make.height.equalTo(placeIconImageView)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(placeIconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
        contentWritingView.snp.makeConstraints { make in
            make.top.equalTo(lineView1.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(contentWritingView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
        solvedTagView.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(solvedTagView.titleLabel.intrinsicContentSize.width + 24)
            make.height.equalTo(24)
        }
        
        solvedLevelColorTextField.snp.makeConstraints { make in
            make.top.equalTo(solvedTagView)
            make.leading.equalTo(solvedTagView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(solvedTagView)
        }
        
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(solvedLevelColorTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
}
