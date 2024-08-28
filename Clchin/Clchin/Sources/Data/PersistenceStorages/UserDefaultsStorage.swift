//
//  UserDefaultsStorage.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

enum UserDefaultsStorage {
    
    enum Keys: String, CaseIterable {
        case accessToken
        case refreshToken
        case isAuthorized
        case userId
        case userProfileImage
    }

    @UserDefault(key: Keys.accessToken.rawValue, defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: Keys.refreshToken.rawValue, defaultValue: nil)
    static var refreshToken: String?
    
    @UserDefault(key: Keys.isAuthorized.rawValue, defaultValue: false)
    static var isAuthorized: Bool
    
    @UserDefault(key: Keys.userId.rawValue, defaultValue: "")
    static var userId: String
    
    @UserDefault(key: Keys.userProfileImage.rawValue, defaultValue: "")
    static var userProfileImage: String
    
    static func deleteAll() {
        Keys.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
