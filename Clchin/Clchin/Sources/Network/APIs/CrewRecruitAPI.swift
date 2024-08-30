//
//  CrewRecruitAPI.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/24/24.
//

import Foundation
import Moya

enum CrewRecruitAPI {
    case getRecruits(next: String?)
    case uploadRecruit(UploadCrewRecruitBodyDTO)
    case validatePayment(PaymentValidationBodyDTO)
    case addNewParticipant(postId: String, _ body: AddParticipantBodyDTO)
}

extension CrewRecruitAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.sesacBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getRecruits, .uploadRecruit:
            return "/posts"
        case .validatePayment:
            return "/payments/validation"
        case .addNewParticipant(let postId, _):
            return "/posts/\(postId)/like-2"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecruits:
            return .get
        case .uploadRecruit, .validatePayment, .addNewParticipant:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecruits(let next):
            let parameters = ["next": next ?? "", "limit": "10", "product_id": "crew_recruit"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadRecruit(let body):
            return .requestJSONEncodable(body)
        case .validatePayment(let body):
            return .requestJSONEncodable(body)
        case .addNewParticipant(_, let body):
            return .requestJSONEncodable(body)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getRecruits:
            return [
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        case .uploadRecruit:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
            
        case .validatePayment:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
            
        case .addNewParticipant:
            return [
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: APIKey.sesacKey
            ]
        }
    }
}

extension CrewRecruitAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}
