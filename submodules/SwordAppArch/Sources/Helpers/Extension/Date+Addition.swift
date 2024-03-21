//
//  Date+Addition.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 14.07.22.
//

import Foundation

extension Date {
    func formatted(by format: String = Constants.DateFormat.ddMM_slashed) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US")

        return dateFormatter.string(from: self)
    }

    var removeTimeStamp: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)

        guard let date = Calendar.current.date(from: components) else {
            return self
        }

        return date
    }
    
    func keepComponents(_ components: Set<Calendar.Component>) -> Date {
        let components = Calendar.current.dateComponents(components, from: self)
        
        guard let date = Calendar.current.date(from: components) else {
            return self
        }

        return date
    }
    
    func formatedDateWithoutTimeZone(by format: String = Constants.DateFormat.ddMM_slashed) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        return dateFormatter.string(from: self)
    }

    static var currentDateTimeInterval: Int {
        return Int(Date().timeIntervalSince1970) * 1000
    }
}
