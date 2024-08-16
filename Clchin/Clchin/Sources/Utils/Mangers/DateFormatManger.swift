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
    }

    private init() {}
    
    func convertTimeFormat(inputFormat: String, outputFormat: String, from target: String) -> String {
        dateFormatter.dateFormat = inputFormat
        
        guard let date = dateFormatter.date(from: target) else { return "0:0" }
        
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}
