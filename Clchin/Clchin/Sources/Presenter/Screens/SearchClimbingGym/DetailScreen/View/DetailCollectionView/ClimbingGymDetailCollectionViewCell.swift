//
//  ClimbingGymDetailCollectionViewCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/28/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SafariServices

final class ClimbingGymDetailCollectionViewCell: BaseCollectionViewCell {
    
    var viewModel: ClimbingGymDetailCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    let detailContentView = DetailContentView()
    
    let disposeBag = DisposeBag()

    override func configureHierarchy() {
        self.contentView.addSubview(detailContentView)
    }
    
    override func configureLayout() {
        detailContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        let input = ClimbingGymDetailCellViewModel.Input(
            locationPinButtonTapped: detailContentView.contentOptionButtonStackView.locationPinButton.rx.tapGesture(),
            instaButtonTapped: detailContentView.contentOptionButtonStackView.instaButton.rx.tapGesture()
        )
        let output = viewModel.transform(input: input)
        
        output.gymDetail
            .bind(to: detailContentView.rx.binder, detailContentView.locationInfoView.rx.binder)
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
//                owner.present(safariVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
