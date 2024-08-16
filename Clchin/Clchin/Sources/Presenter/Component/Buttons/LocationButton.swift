//
//  LocationButton.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit


final class LocationButton: BaseButton {
    override var isSelected: Bool {
        didSet {
            let iconTintColor: UIColor = isSelected ? .white : .black
            let backgroundColor: UIColor = isSelected ? .black : .white
            
            self.tintColor = iconTintColor
            self.backgroundColor = backgroundColor
        }
    }
    
    override func configureButton() {
        self.setImage(UIImage.locationIcon, for: .normal)
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
}
