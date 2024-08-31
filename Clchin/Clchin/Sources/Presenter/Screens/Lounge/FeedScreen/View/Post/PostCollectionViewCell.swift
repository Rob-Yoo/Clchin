//
//  PostCollectionViewCell.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

//extension Reactive where Base: UIImageView {
//    var binder: Binder<[String]> {
//        return Binder(base) { base, images in
//            base.bind(creator: postItem.creator, climbingGymName: postItem.climbingGymName, elapsedTime: postItem.elapsedTime)
//        }
//    }


final class PostCollectionViewCell: BaseCollectionViewCell {
    let creatorInfoView = CreatorInfoView()
    lazy var postImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(PostImageCollectionViewCell.self, forCellWithReuseIdentifier: PostImageCollectionViewCell.identifier)
    }
    
    let contentTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    
    
    let solvedTagView = TagView()
    
    let solvedLevelColorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    let likeButton = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let likeCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    let commentButton = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .commentIcon
    }
    
    let commentCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    let userProfileImageView = ProfileImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let commentActionLabel = UILabel().then {
        $0.text = "댓글 달기..."
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 13)
        $0.isUserInteractionEnabled = true
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        likeCountLabel.text = nil
        commentCountLabel.text = nil
        contentTextLabel.text = nil
    }
    
    func createLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            
            let itemCount = postImageCollectionView.numberOfItems(inSection: sectionIndex)
            
            if (itemCount == 0) {
                return nil
            }
            
            let section: NSCollectionLayoutSection
            
            switch itemCount {
            case 1:
                section = createOneImageSection()
            case 2:
                section = createTwoImageSection()
            case 3:
                section = createThreeImageSection()
            case 5:
                section = createFiveImageSection()
            default:
                return nil
            }

            return section
        }
        
        return layout
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(creatorInfoView)
        self.addSubview(postImageCollectionView)
        self.addSubview(solvedTagView)
        self.addSubview(solvedLevelColorLabel)
        self.addSubview(contentTextLabel)
        self.addSubview(likeButton)
        self.addSubview(likeCountLabel)
        self.addSubview(commentButton)
        self.addSubview(commentCountLabel)
        self.addSubview(userProfileImageView)
        self.addSubview(commentActionLabel)
    }
    
    override func configureLayout() {
        creatorInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(45)
        }
        
        postImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(creatorInfoView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(postImageCollectionView.snp.width).multipliedBy(0.6)
        }
        
        solvedTagView.snp.makeConstraints { make in
            make.top.equalTo(postImageCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(13)
            make.width.equalTo(solvedTagView.titleLabel.intrinsicContentSize.width + 24)
            make.height.equalTo(24)
        }
        
        solvedLevelColorLabel.snp.makeConstraints { make in
            make.leading.equalTo(solvedTagView.snp.trailing).offset(10)
            make.centerY.equalTo(solvedTagView)
        }
        
        contentTextLabel.snp.makeConstraints { make in
            make.top.equalTo(solvedTagView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(13)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(13)
            make.size.equalTo(28)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing).offset(4)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton)
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(10)
            make.size.equalTo(likeButton)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commentButton)
            make.leading.equalTo(commentButton.snp.trailing).offset(4)
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(13)
            make.size.equalTo(25)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        commentActionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageView)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(6)
        }
    }
    
    func bind(post: PostItem) {
        let heartIcon = post.isLike ? UIImage.heartFillIcon : UIImage.heartIcon
        
        Observable.just(post.postImages)
            .bind(to: postImageCollectionView.rx.items(cellIdentifier: PostImageCollectionViewCell.identifier, cellType: PostImageCollectionViewCell.self)) { item, element, cell in
                cell.bind(imageURL: element)
            }
            .disposed(by: disposeBag)

        solvedLevelColorLabel.text = post.levelColors.joined(separator: " ")
        contentTextLabel.text = post.contentText
        likeButton.image = heartIcon
        likeCountLabel.text = post.likeCount.formatted()
        commentCountLabel.text = post.commentCount.formatted()
        
        self.userProfileImageView.kf.setImage(with: URL(string: UserDefaultsStorage.userProfileImage)) { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.userProfileImageView.image = .emptyProfileIcon
                }
            }
        }
    }
}

extension PostCollectionViewCell {
    func createOneImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        return NSCollectionLayoutSection(group: group)
    }
    
    func createTwoImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let item1 = NSCollectionLayoutItem(layoutSize: itemSize)
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item1, item2])

        return NSCollectionLayoutSection(group: group)
    }
    
    func createThreeImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let verticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let verticalItem1 = NSCollectionLayoutItem(layoutSize: verticalItemSize)
        let verticalItem2 = NSCollectionLayoutItem(layoutSize: verticalItemSize)

        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [verticalItem1, verticalItem2])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, verticalGroup])

        return NSCollectionLayoutSection(group: group)
    }
    
    func createFiveImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // =========
        // Horziontal Group
        let horizontalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let horizontalItem = NSCollectionLayoutItem(layoutSize: horizontalItemSize)
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let horizontalGroup: NSCollectionLayoutGroup
        
        if #available(iOS 16.0, *) {
            horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, repeatingSubitem: horizontalItem, count: 2)
        } else {
            horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitem: horizontalItem, count: 2)
        }
        horizontalGroup.interItemSpacing = .fixed(2)
        
        // Vertical Group
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let verticalGroup: NSCollectionLayoutGroup
        
        if #available(iOS 16.0, *) {
            verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, repeatingSubitem: horizontalGroup, count: 2)
        } else {
            verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: horizontalGroup, count: 2)
        }
        
        verticalGroup.interItemSpacing = .fixed(2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, verticalGroup])
        group.interItemSpacing = .fixed(2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

final class TagView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "Solved"
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .white
    }
    
    override func configureView() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 12
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

