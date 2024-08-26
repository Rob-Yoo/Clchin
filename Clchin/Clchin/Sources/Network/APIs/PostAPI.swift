//
//  PostAPI.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation
import Moya

enum PostAPI {
    case getPosts(next: String?)
    case uploadPost(UploadPostBodyDTO)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.sesacBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getPosts, .uploadPost:
            return "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        case .uploadPost:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPosts(let next):
            let parameters = ["next": next ?? "", "limit": "10", "product_id": "climbing"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadPost(let body):
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPosts:
            return [
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .uploadPost:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        }
    }
}

extension PostAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}
