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
    static let emptyProfileIcon = UIImage.emptyProfile.withTintColor(.lightGray.withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
    static let addPostIcon = UIImage.addPost.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let calenderIcon = UIImage(systemName: "calendar")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    static let peopleIcon = UIImage(systemName: "person.2.fill")?.withTintColor(.lightGray.withAlphaComponent(0.8), renderingMode: .alwaysOriginal)
    static let phoneIcon = UIImage(systemName: "phone")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let instaIcon = UIImage.insta.withTintColor(#colorLiteral(red: 1, green: 0, blue: 0.6556545496, alpha: 1), renderingMode: .alwaysOriginal)
    static let locationPinIcon = UIImage.locationPin.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    static let locationPinFillIcon = UIImage.locationPinFill.withTintColor(.gray, renderingMode: .alwaysOriginal)
    
    static let loungeTabIcon = UIImage(systemName: "doc.plaintext")
    static let loungeFillTabIcon = UIImage(systemName: "doc.plaintext.fill")
    static let crewTabIcon = UIImage(systemName: "figure.climbing")
    static let myPageTabIcon = UIImage(systemName: "person")
    static let myPageFillTabIcon = UIImage(systemName: "person.fill")
    
    static let heartIcon = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let heartFillIcon = UIImage(systemName: "heart.fill")?.withTintColor(#colorLiteral(red: 1, green: 0, blue: 0.1242800429, alpha: 1), renderingMode: .alwaysOriginal)
    static let commentIcon = UIImage(systemName: "message")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let bookmarkIcon = UIImage(systemName: "bookmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    static let bookmarkFillIcon = UIImage(systemName: "bookmark.fill")?.withTintColor(#colorLiteral(red: 1, green: 0, blue: 0.1242800429, alpha: 1), renderingMode: .alwaysOriginal)
    
    func resizeImage(size: CGSize) -> UIImage {
      let originalSize = self.size
      let ratio: CGFloat = {
          return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                            1 / (size.height / originalSize.height)
      }()

      return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}
