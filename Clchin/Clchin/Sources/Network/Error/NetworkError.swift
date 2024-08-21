//
//  NetworkError.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation

enum NetworkError: Error {
    case expiredRefreshToken
    case expiredAccessToken
}
//    enum CommonError: Int {
//        case serviceRestriction = 420
//        case excessiveRequests = 429
//        case invalidURL = 444
//        case serverError = 500
//    }
//    
//    enum AuthError {
//        case invalidData = 401
//        case forbiddenAccess = 403
//        case expiredRefreshToken = 418
//    }
//}
