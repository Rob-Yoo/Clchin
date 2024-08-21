//
//  MoyaResponse+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/22/24.
//

import Moya

extension Response {
    func mapResult<T: Decodable>(_ type: T.Type) -> Result<T, Error> {
        do {
            let result = try self.map(T.self)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
