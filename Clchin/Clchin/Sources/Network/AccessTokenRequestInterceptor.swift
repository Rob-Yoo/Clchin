//
//  AccessTokenRequestInterceptor.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/26/24.
//

import Foundation
import Alamofire

final class AccessTokenRetrier: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.setValue(UserDefaultsStorage.accessToken, forHTTPHeaderField: Header.authoriztion.rawValue)
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetry)
            return
        }
        print("retry")
        AuthManager.shared.refreshAccessToken {
            completion(.retry)
        }
    }
}
