//
//  PaymentWebViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/29/24.
//

import UIKit
import RxSwift
import WebKit
import iamport_ios

final class PaymentWebViewController: UIViewController {
    var payment: IamportPayment!
    var postId: String?
    var completionHandler: (() -> Void)?

    private let usecase = DefaultCrewRecruitUseCase(crewRecruitRepository: DefaultCrewRecruitRepository())
    private let webView = WKWebView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        webView.frame = self.view.bounds
        self.navigationItem.title = "결제하기"

        Iamport.shared.paymentWebView(webViewMode: webView, userCode: APIKey.userCode, payment: payment) { [weak self] response in
            guard let response, let self else { return }
            
            usecase.requestPaymentValidation(payment: PaymentValidationBodyDTO(impUID: response.imp_uid ?? "", postId: postId ?? ""))
                .subscribe(onSuccess: { result in
                    switch result {
                    case .success(let isSuccess):
                        if isSuccess {
                            self.navigationController?.popViewController(animated: true)
                            self.completionHandler?()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
