//
//  ClimbingGymRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/16/24.
//

import RxSwift
import GooglePlaces

protocol ClimbingGymRepository {
    func fetchClimbingGymList(
        request: GMSPlaceSearchByTextRequest,
        completion: @escaping (Result<[GMSPlace], Error>) -> Void
    )
}
