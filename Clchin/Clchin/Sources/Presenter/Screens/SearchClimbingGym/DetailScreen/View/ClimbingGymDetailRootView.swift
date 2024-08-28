//
//  ClimbingGymDetailRootView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/18/24.
//

import UIKit
import SnapKit
import Then

final class ClimbingGymDetailRootView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(ClimbingGymDetailCollectionViewCell.self, forCellWithReuseIdentifier: ClimbingGymDetailCollectionViewCell.identifier)
        $0.register(ClimbingGymPhotosHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClimbingGymPhotosHeaderView.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = StretchyHeaderLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 150)
        return layout
    }
    
    override func configureView() {
        self.backgroundColor = .white
    }
    
    override func configureHierarchy() {
        self.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

fileprivate final class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            
            let layoutAttributes = super.layoutAttributesForElements(in: rect)
            
            guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
                return layoutAttributes
            }
            if offset.y < 0 {
                
                for attributes in stLayoutAttributes {
                    
                    if let elmKind = attributes.representedElementKind, elmKind == UICollectionView.elementKindSectionHeader {
                        
                        let diffValue = abs(offset.y)
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + diffValue)
                        frame.origin.y = frame.minY - diffValue
                        attributes.frame = frame
                    }
                }
            }
            return layoutAttributes
        }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
