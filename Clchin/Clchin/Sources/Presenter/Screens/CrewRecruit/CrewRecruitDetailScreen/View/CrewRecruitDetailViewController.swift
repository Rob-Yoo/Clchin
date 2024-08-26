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
        let input = CrewRecruitDetailViewModel.Input(crewRecruitDetailRequestTrigger: BehaviorRelay(value: ()))
        let output = viewModel.transform(input: input)
        
        
    }
}
