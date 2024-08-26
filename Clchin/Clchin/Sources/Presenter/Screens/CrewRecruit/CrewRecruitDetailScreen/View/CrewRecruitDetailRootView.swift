//
//  CrewRecruitDetailRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import UIKit
import SnapKit
import Then

final class CrewRecruitDetailRootView: BaseView {
    
    let footerActionView = FooterActionView()
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(footerActionView)
    }
    
    override func configureLayout() {
        footerActionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(110)
        }
    }
}
