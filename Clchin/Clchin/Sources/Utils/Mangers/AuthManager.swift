//
//  AuthManager.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation
import RxSwift

final class AuthManager {
    static let shared = AuthManager()
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func login(_ query: LoginBodyDTO) {
        NetworkProvider.shared.requestAPI(AuthAPI.login(query), responseType: LoginResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    UserDefaultsStorage.accessToken = response.accessToken
                    UserDefaultsStorage.refreshToken = response.refreshToken
                    UserDefaultsStorage.isAuthorized = true
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func refreshAccessToken(completionHandler: @escaping () -> Void) {
        NetworkProvider.shared.requestAPI(AuthAPI.refresh, responseType: RefreshResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("저장 전")
                    UserDefaultsStorage.accessToken = response.accessToken
                    print("저장 후")
                    completionHandler()
                case .failure(let error):
                    switch error {
                    case .expiredRefreshToken:
                        print("리프레시 토큰 만료됨")
                        UserDefaultsStorage.isAuthorized = false
                    default:
                        return
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
