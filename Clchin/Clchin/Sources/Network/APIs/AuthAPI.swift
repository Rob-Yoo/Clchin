//
//  AuthAPI.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation
import Moya

enum AuthAPI {
    case login(LoginBodyDTO)
    case refresh
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.sesacBaseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        case .refresh:
            return "/v1/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let query):
            return .requestJSONEncodable(query)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .refresh:
            return [
                Header.authoriztion.rawValue: UserDefaultsStorage.accessToken ?? "",
                Header.sesacKey.rawValue: APIKey.sesacKey,
                Header.refresh.rawValue: UserDefaultsStorage.refreshToken ?? ""
            ]
        }
    }
}
