//
//  UIImage+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit

extension UIImage {
    static let searchIcon = UIImage(systemName: "magnifyingglass")
    static let keyboardDismissIcon = UIImage(systemName: "keyboard.chevron.compact.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let locationIcon = UIImage(systemName: "dot.scope")
    
    static let phoneIcon = UIImage(systemName: "phone")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let instaIcon = UIImage.insta.withTintColor(#colorLiteral(red: 1, green: 0, blue: 0.6556545496, alpha: 1), renderingMode: .alwaysOriginal)
    static let locationPinIcon = UIImage.locationPin.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    
    static let loungeTabIcon = UIImage(systemName: "doc.plaintext")
    static let loungeFillTabIcon = UIImage(systemName: "doc.plaintext.fill")
    static let crewTabIcon = UIImage(systemName: "figure.climbing")
    static let myPageTabIcon = UIImage(systemName: "person")
    static let myPageFillTabIcon = UIImage(systemName: "person.fill")
}
