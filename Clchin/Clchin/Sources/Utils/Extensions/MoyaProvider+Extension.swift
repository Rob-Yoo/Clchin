//
//  MoyaProvider+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/21/24.
//

import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
