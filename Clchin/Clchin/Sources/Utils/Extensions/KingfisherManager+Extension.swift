//
//  KingfisherManager+Extension.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/23/24.
//

import Foundation
import Kingfisher

extension KingfisherManager {
    func setHeaders() {
        let modifier = AnyModifier { request in
            var req = request
            req.setValue(UserDefaultsStorage.accessToken ?? "", forHTTPHeaderField: Header.authoriztion.rawValue)
            req.setValue(APIKey.sesacKey, forHTTPHeaderField: Header.sesacKey.rawValue)
            return req
        }

        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier)
        ]
    }
}
