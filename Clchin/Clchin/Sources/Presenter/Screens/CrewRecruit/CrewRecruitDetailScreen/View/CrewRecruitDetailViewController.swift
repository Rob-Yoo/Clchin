//
//  CrewRecruitDetailViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CrewRecruitDetailViewController: BaseViewController<CrewRecruitDetailRootView> {
    private let viewModel: CrewRecruitDetailViewModel

    init(viewModel: CrewRecruitDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bindViewModel() {
        let input = CrewRecruitDetailViewModel.Input(
            crewRecruitDetailRequestTrigger: Observable.just(()),
            joinButtonTapped: contentView.footerActionView.joinButton.rx.tap)
        let output = viewModel.transform(input: input)
        let dataSource = RxCollectionViewSectionedReloadDataSource<RecruitDetailSectionModel> { dataSource, collectionView, indexPath, sectionType in
            switch sectionType {
            case .header(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrewRecruitHeaderCell.identifier, for: indexPath) as? CrewRecruitHeaderCell else { return UICollectionViewCell() }
                
                cell.bind(model: model)
                return cell
            case .body(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrewRecruitBodyCell.identifier, for: indexPath) as? CrewRecruitBodyCell else { return UICollectionViewCell() }
                
                cell.bind(model: model)
                return cell
            case .footer(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrewRecruitFooterCell.identifier, for: indexPath) as? CrewRecruitFooterCell else { return UICollectionViewCell() }
                
                cell.bind(model: model)
                return cell
            }
        }
        
        output.detailSections
            .bind(to: contentView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.payment
            .bind(with: self) { owner, payment in
                let nextVC = PaymentWebViewController()
                nextVC.payment = payment.iamportPayment
                nextVC.postId = payment.postId
                nextVC.completionHandler = {
                    print("결제 및 참여자 성공")
                }
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
