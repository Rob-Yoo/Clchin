//
//  BaseView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
        self.configureHierarchy()
        self.configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {}
    func configureHierarchy() {}
    func configureLayout() {}
}
