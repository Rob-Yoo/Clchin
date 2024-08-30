//
//  AddFeedViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/30/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class AddFeedViewController: BaseViewController<AddFeedRootView> {
    
    private let viewModel: AddFeedViewModel
    private let photos = BehaviorRelay(value: [UIImage]())
    private var photoPicker: PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }
    
    init(viewModel: AddFeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "피드 작성"
        self.navigationItem.rightBarButtonItem = contentView.addPostBarButton
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func bindViewModel() {
        let input = AddFeedViewModel.Input(
            selectedPhotos: photos,
            gymNameText: contentView.gymNameTextField.rx.text.orEmpty,
            contentText: contentView.contentWritingView.contentTextView.rx.text.orEmpty,
            solvedLevelColor: contentView.solvedLevelColorTextField.rx.text.orEmpty,
            addPostButtonTapped: contentView.addPostBarButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        contentView.contentWritingView.photoSelectionButtonView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                let photoPicker = owner.photoPicker
                
                photoPicker.delegate = self
                photoPicker.modalPresentationStyle = .fullScreen
                owner.present(photoPicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.selectedPhotos
            .drive(contentView.contentWritingView.selectedImageCollectionView.rx.items(cellIdentifier: SelectedPhotoCell.identifier, cellType: SelectedPhotoCell.self)) { item, photo, cell in
                cell.bind(photo: photo)
                
                cell.removeButton.rx.tap
                    .map { _ in item }
                    .bind(with: self) { owner, idx in
                        var photos = owner.photos.value
                        
                        photos.remove(at: idx)
                        owner.photos.accept(photos)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.selectedPhotos
            .map { $0.count }
            .drive(contentView.contentWritingView.photoSelectionButtonView.rx.binder)
            .disposed(by: disposeBag)
        
        output.isValidate
            .bind(with: self) { owner, isValidate in
                let color = isValidate ? UIColor.black : UIColor.lightGray
                
                owner.contentView.addPostBarButton.tintColor = color
                owner.contentView.addPostBarButton.isEnabled = isValidate
            }
            .disposed(by: disposeBag)
        
        output.popViewControllerTrigger
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension AddFeedViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let dispatchGroup = DispatchGroup()
        var selectedPhotos = [UIImage]()
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    selectedPhotos.append(image)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.photos.accept(selectedPhotos)
        }
        dismiss(animated: true)
    }
}
