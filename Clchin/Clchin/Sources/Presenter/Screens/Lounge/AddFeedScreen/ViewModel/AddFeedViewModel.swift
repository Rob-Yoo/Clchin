//
//  AddFeedViewModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddFeedViewModel: ViewModelType {
    struct Input {
        let selectedPhotos: BehaviorRelay<[UIImage]>
        let gymNameText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let solvedLevelColor: ControlProperty<String>
        let addPostButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let selectedPhotos: Driver<[UIImage]>
        let isValidate: BehaviorRelay<Bool>
        let popViewControllerTrigger: PublishRelay<Void>
    }
    
    private let disposeBag = DisposeBag()
    private let uploadPostBodyBuilder = UploadPostBodyDTOBuilder()
    private var photos = [Data]()
    private let postUseCase: PostServiceUseCase
    
    init(postUseCase: PostServiceUseCase) {
        self.postUseCase = postUseCase
    }
    
    func transform(input: Input) -> Output {
        let selectedPhotos = BehaviorRelay(value: [UIImage]())
        let isValidate = BehaviorRelay(value: false)
        let popViewControllerTrigger = PublishRelay<Void>()

        input.selectedPhotos
            .bind(with: self) { owner, photos in
                owner.photos = photos.map { $0.jpegData(compressionQuality: 0.5)! }
                selectedPhotos.accept(photos)
            }
            .disposed(by: disposeBag)
        
        input.gymNameText
            .bind(with: self) { owner, text in
                owner.uploadPostBodyBuilder.climbingGymName(text)
            }
            .disposed(by: disposeBag)
        
        input.contentText
            .bind(with: self) { owner, text in
                owner.uploadPostBodyBuilder.contentText(text)
            }
            .disposed(by: disposeBag)
        
        input.solvedLevelColor
            .bind(with: self) { owner, color in
                let filteredColor = color.filter { !$0.isWhitespace }.map { String($0) }
                
                owner.uploadPostBodyBuilder.levelColors(filteredColor)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(input.gymNameText, input.selectedPhotos, input.solvedLevelColor, input.contentText)
            .map { gymName, photos, colors, contentText in
                return !gymName.isEmpty && !photos.isEmpty && !colors.isEmpty && !contentText.isEmpty
            }
            .bind(with: self) { owner, validation in
                isValidate.accept(validation)
            }
            .disposed(by: disposeBag)
        
        input.addPostButtonTapped
            .flatMap { [weak self] _ in
                guard let self else { return Single<Result<PostImages, PostImageUploadError>>.never() }
                return self.postUseCase.uploadPostImages(images: photos)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let res):
                    owner.uploadPostBodyBuilder.images(res.files)
                    let bodyDTO = owner.uploadPostBodyBuilder.build()
                    owner.postUseCase.uploadPost(post: bodyDTO)
                    popViewControllerTrigger.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

        return Output(selectedPhotos: selectedPhotos.asDriver(onErrorJustReturn: []), isValidate: isValidate, popViewControllerTrigger: popViewControllerTrigger)
    }
}
