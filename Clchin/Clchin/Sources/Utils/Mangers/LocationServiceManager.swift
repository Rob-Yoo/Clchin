//
//  LocationServiceManager.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/18/24.
//

import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation
import Then

final class LocationServiceManager: NSObject {
    static let shared = LocationServiceManager()

    private lazy var locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.delegate = self
    }
    private let disposeBag = DisposeBag()
    
    enum LocationServiceError: Error {
        case authorizationDenied
    }
  
    private override init() {
        super.init()
    }

    func requestLocation() -> Observable<Result<CLLocationCoordinate2D, LocationServiceError>> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            self.locationManager.rx.didChangeAuthorization
                .map { $0.status }
                .bind { status in
                    switch status {
                    case .notDetermined:
                        self.locationManager.requestWhenInUseAuthorization()
                    case .denied, .restricted:
                        observer.onNext(.failure(LocationServiceError.authorizationDenied))
                        return
                    case .authorizedWhenInUse:
                        self.locationManager.requestLocation()
                    default:
                        return
                    }
                }
                .disposed(by: self.disposeBag)
            
            locationManager.rx.location
                .compactMap { $0?.coordinate }
                .bind { coord in
                    observer.onNext(.success(coord))
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
        
}

extension LocationServiceManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        return
    }
}
