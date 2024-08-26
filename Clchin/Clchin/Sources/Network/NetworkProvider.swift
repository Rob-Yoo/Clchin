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

final class NetworkProvider {
    static let shared = NetworkProvider()
    
    private init() {}
    
    func requestAPI<Target: TargetType, Response: Decodable>(_ target: Target, responseType: Response.Type) -> Single<Result<Response, NetworkError>> {
        let session = Session(interceptor: AccessTokenRetrier())
        let provider = MoyaProvider<Target>(session: session)
        
        return Single.create { observer in

            provider.request(target) { result in
                switch result {
                case .success(let response):
                    
                    if responseType == EmptyResponse.self {
                        return
                    }
                    
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
