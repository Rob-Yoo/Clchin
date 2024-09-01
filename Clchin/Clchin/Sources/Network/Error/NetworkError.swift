//
//  NetworkError.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation

protocol ErrorMapping {
    static func map(statusCode: Int) -> Self
}

enum CommonError: Error, ErrorMapping {
    case serviceRestriction
    case excessiveRequests
    case invalidURL
    case serverError
    case none
    
    static func map(statusCode: Int) -> Self {
        switch statusCode {
        case 420:
            return .serviceRestriction
        case 429:
            return .excessiveRequests
        case 444:
            return .invalidURL
        case 500:
            return .serverError
        default:
            return .none
        }
    }
}

enum LoginError: Error, ErrorMapping {
    case uncompletedRequestBody
    case invalidAccount
    case none
    
    static func map(statusCode: Int) -> Self {
        switch statusCode {
        case 400:
            return .uncompletedRequestBody
        case 401:
            return .invalidAccount
        default:
            return .none
        }
    }
}

enum RefreshTokenError: Error, ErrorMapping {
    case invalidToken
    case forbidden
    case expiredRefreshToken
    case none
    
    static func map(statusCode: Int) -> Self {
        switch statusCode {
        case 401:
            return .invalidToken
        case 403:
            return .forbidden
        case 418:
            return .expiredRefreshToken
        default:
            return .none
        }
    }
}

enum PostImageUploadError: Error, ErrorMapping {
    case invalidRequest
    case invalidAccessToken
    case forbidden
    case expiredAccessToken
    case none
    
    static func map(statusCode: Int) -> Self {
        switch statusCode {
        case 400: return .invalidRequest
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 419: return .expiredAccessToken
        default: return .none
        }
    }
}

enum PostUploadError: Error, ErrorMapping {
    case invalidDataType
    case invalidAccessToken
    case forbidden
    case postSaveFailure
    case expiredAccessToken
    case none
    
    static func map(statusCode: Int) -> PostUploadError {
        switch statusCode {
        case 400: return .invalidDataType
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 410: return .postSaveFailure
        case 419: return .expiredAccessToken
        default: return .none
        }
    }
}

enum PostReadError: Error, ErrorMapping {
    case invalidRequest
    case invalidAccessToken
    case forbidden
    case expiredAccessToken
    case none
    
    static func map(statusCode: Int) -> PostReadError {
        switch statusCode {
        case 400: return .invalidRequest
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 419: return .expiredAccessToken
        default: return .none
        }
    }
}

enum PostDeleteError: Error, ErrorMapping {
    case invalidAccessToken
    case forbidden
    case notFound
    case expiredAccessToken
    case invalidPermission
    case none
    
    static func map(statusCode: Int) -> PostDeleteError {
        switch statusCode {
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 410: return .notFound
        case 419: return .expiredAccessToken
        case 445: return .invalidPermission
        default: return .none
        }
    }
}

enum LikeError: Error, ErrorMapping {
    case invalidRequest
    case invalidAccessToken
    case forbidden
    case notFound
    case expiredAccessToken
    case none
    
    static func map(statusCode: Int) -> LikeError {
        switch statusCode {
        case 400: return .invalidRequest
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 410: return .notFound
        case 419: return .expiredAccessToken
        default: return .none
        }
    }
}

enum PaymentValidationError: Error, ErrorMapping {
    case invalidPayment
    case invalidAccessToken
    case forbidden
    case completedPayment
    case notFound
    case expiredAccessToken
    case none
    
    static func map(statusCode: Int) -> PaymentValidationError {
        switch statusCode {
        case 400: return .invalidPayment
        case 401: return .invalidAccessToken
        case 403: return .forbidden
        case 409: return .completedPayment
        case 410: return .notFound
        case 419: return .expiredAccessToken
        default: return .none
        }
    }
}
