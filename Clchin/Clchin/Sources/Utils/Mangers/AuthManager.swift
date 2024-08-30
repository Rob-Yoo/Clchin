//
//  AuthManager.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation
import Moya
import Kingfisher
import RxSwift

final class AuthManager {
    static let shared = AuthManager()
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func login(_ query: LoginBodyDTO) {
        let provider = MoyaProvider<AuthAPI>()
        
        provider.request(.login(query)) { result in
            switch result {
            case .success(let response):
                let result = response.mapResult(LoginResponseDTO.self)
                
                switch result {
                case .success(let res):
                    UserDefaultsStorage.accessToken = res.accessToken
                    UserDefaultsStorage.refreshToken = res.refreshToken
                    UserDefaultsStorage.isAuthorized = true
                    UserDefaultsStorage.userId = res.userId
                    UserDefaultsStorage.userProfileImage = APIKey.sesacBaseURL + "/" + (res.profileImageURL ?? "")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshAccessToken(completionHandler: @escaping () -> Void) {
        NetworkProvider.shared.requestAPI(AuthAPI.refresh, responseType: RefreshResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    UserDefaultsStorage.accessToken = response.accessToken
                    KingfisherManager.shared.setHeaders()
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
