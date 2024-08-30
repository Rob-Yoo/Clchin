//
//  CrewRecruitDetailViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CrewRecruitDetailViewController: BaseViewController<CrewRecruitDetailRootView> {
    private let viewModel: CrewRecruitDetailViewModel
    private var postId: String!

    init(viewModel: CrewRecruitDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func bindViewModel() {
        let input = CrewRecruitDetailViewModel.Input(
            crewRecruitDetailRequestTrigger: Observable.just(()),
            joinButtonTapped: contentView.footerActionView.joinButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.crewRecruitDetail
            .bind(with: self) { owner, detail in
                owner.postId = detail.postId
            }
            .disposed(by: disposeBag)
        
        output.payment
            .bind(with: self) { owner, payment in
                let nextVC = PaymentWebViewController()
                nextVC.payment = payment
                nextVC.postId = owner.postId
                nextVC.completionHandler = {
                    print("결제 및 참여자 성공")
                }
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
