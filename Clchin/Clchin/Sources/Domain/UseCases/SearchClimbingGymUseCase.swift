//
//  SearchClimbingGymUseCase.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/16/24.
//

import GooglePlaces
import RxSwift
import CoreLocation

protocol SearchClimbingGymUseCase {
    func execute(textQuery: String, userCoordinate: CLLocationCoordinate2D) -> Single<Result<[ClimbingGym], Error>>
}

final class DefaultSearchClimbingGymUseCase: SearchClimbingGymUseCase {

    private let climbingRepository: ClimbingGymRepository
    private let placeProperties: [GMSPlaceProperty] = [.placeID, .name, .coordinate, .formattedAddress, .rating, .userRatingsTotal, .openingHours, .photos, .website, .phoneNumber]
    
    init(climbingRepository: ClimbingGymRepository) {
        self.climbingRepository = climbingRepository
    }
    
    func execute(textQuery: String, userCoordinate: CLLocationCoordinate2D) -> Single<Result<[ClimbingGym], Error>> {
        return Single.create { [weak self] observer in
            guard let self else { return Disposables.create() }

            let request = GMSPlaceSearchByTextRequest(textQuery: textQuery + " 클라이밍장", placeProperties: self.placeProperties.map { $0.rawValue })
            
            request.isOpenNow = false
            self.climbingRepository.fetchClimbingGymList(request: request) { result in
                switch result {
                case .success(let placeList):
                    let climbingGymList = self.toDomain(placeList: placeList, userCoordinate: userCoordinate)
                    observer(.success(.success(climbingGymList)))
                case .failure(let error):
                    observer(.success(.failure(error)))
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func toDomain(placeList: [GMSPlace], userCoordinate: CLLocationCoordinate2D) -> [ClimbingGym] {
        var list = [ClimbingGym]()

        for place in placeList {
            let address = (place.formattedAddress ?? "").replacingOccurrences(of: "대한민국 ", with: "")
            let openingHourPerWeekday = place.openingHours?.weekdayText ?? []
            let currentOpeningHour = getCurrentOpeningHour(openingHourPerWeekday: openingHourPerWeekday)
            let isOpen = isClimbingGymOpen(openingHourPerWeekday: openingHourPerWeekday)
            
            let climbingGym = ClimbingGym(
                id: place.placeID ?? "",
                name: place.name ?? "",
                address: address,
                photos: place.photos ?? [],
                lat: place.coordinate.latitude,
                lng: place.coordinate.longitude,
                distance: place.coordinate.distance(from: userCoordinate),
                rate: place.rating,
                userRatingCount: Int(place.userRatingsTotal),
                openingHours: openingHourPerWeekday,
                currentOpeningHour: currentOpeningHour,
                isOpen: isOpen,
                phoneNumber: place.phoneNumber ?? "",
                website: place.website
            )
            
            list.append(climbingGym)
        }
        
        return list
    }
}

//MARK: - Business Logic
extension DefaultSearchClimbingGymUseCase {
    private func isClimbingGymOpen(openingHourPerWeekday: [String]) -> Bool {
        let currentOpeningHour = getCurrentOpeningHour(openingHourPerWeekday: openingHourPerWeekday)
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        
        guard let hour = components.hour,
              let minute = components.minute,
              // "토요일: 휴무일" 인 경우
              let _ = currentOpeningHour.first(where: {$0.isNumber}),
              !currentOpeningHour.isEmpty else {
            return false
        }
        
        let currentTime = hour * 60 + minute
        let (openTime, closeTime) = getOpenAndCloseTime(currentOpeningHour: currentOpeningHour)
        
        return openTime <= currentTime && currentTime < closeTime
    }
    
    private func getOpenAndCloseTime(currentOpeningHour: String) -> (openTime: Int, closeTime: Int) {
        let components = currentOpeningHour.components(separatedBy: ": ")
        let times = components[1].components(separatedBy: "~")
        let openTimes = times[0]
        let closeTimes = times[1].trimmingCharacters(in: .whitespaces).first!.isLetter ? times[1] : "오후 " + times[1]

        let open = DateFormatManger.shared.convertTimeFormat(inputFormat: "a hh:mm", outputFormat: "HH:mm", from: openTimes).components(separatedBy: ":")
        let close = DateFormatManger.shared.convertTimeFormat(inputFormat: "a hh:mm", outputFormat: "HH:mm", from: closeTimes).components(separatedBy: ":")
        
        let (openHour, openMin) = (Int(open[0])!, Int(open[1])!)
        let (closeHour, closeMin) = (Int(close[0])!, Int(close[1])!)

        return (openTime: openHour * 60 + openMin, closeTime: closeHour * 60 + closeMin)
    }
    
    private func getCurrentOpeningHour(openingHourPerWeekday: [String]) -> String {
        
        // 월 0, 화 1, ... 일 6
        guard !openingHourPerWeekday.isEmpty else { return "" }
        
        let components = Calendar.current.dateComponents([.weekday], from: Date.now)
        
        // 일 1, 월 2, ...
        guard let weekday = components.weekday else { return "" }
        
        let currentOpeningHourIdx = (weekday - 2) >= 0 ? (weekday - 2) : 6
        return openingHourPerWeekday[currentOpeningHourIdx]
    }
}

