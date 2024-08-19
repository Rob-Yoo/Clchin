//
//  ClimbingGymDetailRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/18/24.
//

import UIKit
import SnapKit
import Then

final class ClimbingGymDetailRootView: BaseView {
    private let gymImageView = UIImageView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.4)
        $0.contentMode = .scaleAspectFill
    }
    
    let detailContentView = DetailContentView()
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(gymImageView)
        self.addSubview(detailContentView)
    }
    
    override func configureLayout() {
        gymImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        detailContentView.snp.makeConstraints { make in
            make.top.equalTo(gymImageView.snp.bottom).offset(-20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
