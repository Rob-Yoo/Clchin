//
//  NetworkProvider.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Foundation
import Moya
import Alamofire
import RxSwift

final class AccessTokenRetrier: RequestInterceptor {
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

final class NetworkProvider {
    static let shared = NetworkProvider()
//    private let session = Session(interceptor: AccessTokenRetrier())
    
    private init() {}
    
    func requestAPI<Target: TargetType, Response: Decodable>(_ target: Target, responseType: Response.Type) -> Single<Result<Response, NetworkError>> {
        let session = Session(interceptor: AccessTokenRetrier())
        let provider = MoyaProvider<Target>(session: session)
        
        return Single.create { observer in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    print(response.statusCode)

                    let result = response.mapResult(Response.self)
                    
                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            return Disposables.create()
        }
    }
}
