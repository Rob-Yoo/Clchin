//
//  PostActionView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

extension Reactive where Base: PostActionStackView {
    var binder: Binder<PostItem> {
        return Binder(base) { base, postItem in
            base.bind(isLike: postItem.isLike, likeCount: postItem.likeCount, commentCount: postItem.commentCount)
        }
    }
}

final class PostActionStackView: BaseStackView {
    let likeActionView = LikeActionView()
    let commentActionView = CommentActionView()
    
    private var arrangedViews: [UIView] {
        return [likeActionView, commentActionView]
    }
    
    override func configureStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = 10
        self.arrangedViews.forEach { self.addArrangedSubview($0) }
    }
    
    fileprivate func bind(isLike: Bool, likeCount: Int, commentCount: Int) {
        likeActionView.bind(isLike: isLike, likeCount: likeCount)
        commentActionView.bind(commentCount: commentCount)
    }
}

final class LikeActionView: BaseView {
    let likeButton = UIButton().then {
        $0.setImage(.heartIcon, for: .normal)
    }
    let likeCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    override func configureHierarchy() {
        self.addSubview(likeButton)
        self.addSubview(likeCountLabel)
    }
    
    override func configureLayout() {
        print()
        likeButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(likeButton.snp.height)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.verticalEdges.equalToSuperview().inset(3)
        }
    }
    
    fileprivate func bind(isLike: Bool, likeCount: Int) {
        let likeImage: UIImage? = isLike ? .heartFillIcon : .heartIcon
        
        likeButton.setImage(likeImage, for: .normal)
        likeCountLabel.text = likeCount.formatted()
        self.snp.updateConstraints { make in
            make.width.equalTo(likeButton.frame.width + likeCountLabel.intrinsicContentSize.width + 5)
        }
    }
}

final class CommentActionView: BaseView {
    let commentButton = UIButton().then {
        $0.setImage(.commentIcon, for: .normal)
    }
    let commentCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .medium)
    }
    
    override func configureHierarchy() {
        self.addSubview(commentButton)
        self.addSubview(commentCountLabel)
    }
    
    override func configureLayout() {
        commentButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(commentButton.snp.height)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentButton.snp.trailing).offset(5)
            make.verticalEdges.equalToSuperview().inset(3)
        }
    }
    
    fileprivate func bind(commentCount: Int) {
        commentCountLabel.text = commentCount.formatted()
        self.snp.updateConstraints { make in
            make.width.equalTo(commentButton.frame.width + commentCountLabel.intrinsicContentSize.width + 5)
        }
    }
}

