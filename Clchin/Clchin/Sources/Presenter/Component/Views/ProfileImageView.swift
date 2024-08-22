//
//  ProfileImageView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
}
