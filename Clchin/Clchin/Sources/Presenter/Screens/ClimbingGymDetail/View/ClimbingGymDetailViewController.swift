//
//  ClimbingGymDetailViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

final class ClimbingGymDetailViewController: BaseViewController<ClimbingGymDetailRootView> {
    
    private let viewModel: ClimbingGymDetailViewModel
    
    init(viewModel: ClimbingGymDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func bindViewModel() {
        let input = ClimbingGymDetailViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad,
            locationPinButtonTapped: contentView.detailContentView.contentOptionButtonStackView.locationPinButton.rx.tapGesture(),
            instaButtonTapped: contentView.detailContentView.contentOptionButtonStackView.instaButton.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)
        
        output.gymDetail
            .bind(to: contentView.detailContentView.rx.binder, contentView.detailContentView.locationInfoView.rx.binder)
            .disposed(by: disposeBag)
        
        output.name
            .bind(with: self) { owner, address in
                let appName = Bundle.main.bundleIdentifier ?? ""
                let urlString = "nmap://search?query=\(address)&appname=\(appName)"
                guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                print(encodedStr)
                guard let url = URL(string: encodedStr) else { return }
                guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728?mt=8") else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.open(appStoreURL)
                }
            }
            .disposed(by: disposeBag)
        
        output.website
            .bind(with: self) { owner, url in
                guard let url else { return }
                let safariVC = SFSafariViewController(url: url)
                owner.present(safariVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
