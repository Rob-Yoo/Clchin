//
//  DefaultClimbingGymRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/16/24.
//

import RxSwift
import GooglePlaces

final class DefaultClimbingGymRepository: ClimbingGymRepository {
    
    private let client = GMSPlacesClient.shared()
    
    func fetchClimbingGymList(request: GMSPlaceSearchByTextRequest, completion: @escaping (Result<[GMSPlace], Error>) -> Void) {

        let callback: GMSPlaceSearchByTextResultCallback = { results, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            if let results {
                completion(.success(results))
            } else {
                print("Results가 nil임")
            }
        }
        
        GMSPlacesClient.shared().searchByText(with: request, callback: callback)
    }
    
}
