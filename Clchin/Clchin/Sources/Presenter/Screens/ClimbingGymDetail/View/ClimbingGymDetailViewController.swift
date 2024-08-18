//
//  ClimbingGymDetailViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

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
        let input = ClimbingGymDetailViewModel.Input(viewDidLoad: self.rx.viewDidLoad)
        let output = viewModel.transform(input: input)
        
        output.gymDetail
            .bind(to: contentView.detailContentView.rx.binder, contentView.detailContentView.locationInfoView.rx.binder)
            .disposed(by: disposeBag)
            
    }
}
