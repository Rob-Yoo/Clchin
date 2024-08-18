//
//  LocationInfoView.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/19/24.
//

import UIKit
import SnapKit
import NMapsMap
import RxSwift
import Then

final class LocationInfoView: BaseView {
    private let titleLabel = UILabel().then {
        $0.text = "위치 정보"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    
    private let mapView = NMFMapView().then {
        $0.isIndoorMapEnabled = true
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let marker = NMFMarker().then {
        $0.captionRequestedWidth = 100
    }
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(mapView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate func bind(lat: Double, lng: Double, markerCaption: String) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))

        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.captionText = markerCaption
        marker.mapView = mapView
        mapView.moveCamera(cameraUpdate)
        
        print(mapView.cameraPosition.target)
        print(lat, lng)
    }
}

extension Reactive where Base: LocationInfoView {
    var binder: Binder<ClimbingGym> {
        return Binder(base) { base, gym in
            base.bind(lat: gym.coordinate.latitude, lng: gym.coordinate.longitude, markerCaption: gym.name)
        }
    }
}
