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
    
    func requestAPI<Target: TargetType, R: Decodable, E: ErrorMapping>(_ target: Target, responseType: R.Type, errorType: E.Type) -> Single<Result<R, E>> {
        let session = Session(interceptor: AccessTokenRetrier())
        let provider = MoyaProvider<Target>(session: session)
        
        return Single.create { observer in

            provider.request(target) { result in
                switch result {
                case .success(let response):
                    
                    if responseType == EmptyResponse.self {
                        return
                    }
                    
                    let result = response.mapResult(R.self)

                    switch result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        let commonError = CommonError.map(statusCode: response.statusCode)
                        let errorMapping: E
                        
                        if (commonError == .none) {
                            errorMapping = errorType.map(statusCode: response.statusCode)
                            observer(.success(.failure(errorMapping)))
                        }
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            return Disposables.create()
        }
    }
}
