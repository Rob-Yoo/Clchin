//
//  File.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/17/24.
//

import UIKit

final class SortButton: BaseButton {
    override var isSelected: Bool {
        didSet {
            let textColor: UIColor = isSelected ? .white : .black
            let backgroundColor: UIColor = isSelected ? .black : .white
            
            self.setTitleColor(textColor, for: .normal)
            self.backgroundColor = backgroundColor
        }
    }
    
    override func configureButton() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        self.layer.cornerRadius = 10
    }
}

