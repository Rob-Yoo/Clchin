//
//  ClimbingGymCollectionViewCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import SnapKit
import GooglePlaces

final class ClimbingGymCollectionViewCell: BaseCollectionViewCell {
    let cardView = ClimbingGymCardView()
    
    override func configureHierarchy() {
        self.contentView.addSubview(cardView)
    }
    
    override func configureLayout() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cardView.gymImageView.image = nil
        self.cardView.openingHourStackView.isOpenLabel.text = nil
    }
    
    func bind(gym: ClimbingGym) {
        self.cardView.nameLabel.text = gym.name
        self.cardView.addressLabel.text = gym.address
        self.cardView.ratingStackView.ratingLabel.text = String(format: "%.1f", gym.rate)
        self.cardView.ratingStackView.ratingView.rating = Double(gym.rate)
        self.cardView.ratingStackView.userRatingCountLabel.text = "(" + String(gym.userRatingCount) + ")"
        
        if (gym.currentOpeningHour.isEmpty) {
            self.cardView.openingHourStackView.openingHourLabel.text = "(영업 시간 정보 없음)"
            self.cardView.openingHourStackView.spacing = 0
        } else {
            self.cardView.openingHourStackView.spacing = 5
            self.cardView.openingHourStackView.openingHourLabel.text = gym.currentOpeningHour
            self.cardView.openingHourStackView.isOpenLabel.text = gym.isOpen ? "영업 중" : "영업 종료"
            self.cardView.openingHourStackView.isOpenLabel.textColor = gym.isOpen ? .systemGreen : .systemRed
            self.loadImage(photos: gym.photos)
        }
    }
    
    private func loadImage(photos: [GMSPlacePhotoMetadata]) {
        guard !photos.isEmpty else { return }
        
        let photo = photos[0]
        let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photo, maxSize: CGSizeMake(500, 500))

        GMSPlacesClient.shared().fetchPhoto(with: fetchPhotoRequest) { [weak self] image, error in
            guard let image, error == nil else {
                print(error?.localizedDescription)
              return }
            self?.cardView.gymImageView.image = image
        }
    }
}

//extension Reactive where Base: ClimbingGymCollectionViewCell {
//    var binder: Binder<ClimbingGym> {
//        return Binder(base) { base, gym in
//            base.bind(gym: gym)
//        }
//    }
//}
