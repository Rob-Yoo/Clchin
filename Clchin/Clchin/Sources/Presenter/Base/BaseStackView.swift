//
//  BaseStackView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit

class BaseStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView() {
        
    }
}
