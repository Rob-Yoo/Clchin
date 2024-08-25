//
//  DateFormatManger.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/16/24.
//

import Foundation
import Then

final class DateFormatManger {
    static let shared = DateFormatManger()
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(abbreviation: "KST")
    }
    private let isoDateFormatter = ISO8601DateFormatter().then {
        $0.timeZone = TimeZone(abbreviation: "KST")
        $0.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
    }

    private init() {}
    
    func convertTimeFormat(inputFormat: String, outputFormat: String, from target: String) -> String {
        dateFormatter.dateFormat = inputFormat
        
        guard let date = dateFormatter.date(from: target) else { return "0:0" }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
    
    func convertToString(format: String, target: Date) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: target)
    }
    
    func convertToISOFormatDate(target: String) -> Date {
        guard let date = isoDateFormatter.date(from: target) else {
            return .now
        }

        return date
    }
    
    func convertToDate(target: String) -> Date {
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"

        guard let date = dateFormatter.date(from: target) else {
            return .now
        }
        
        return date
    }
}
