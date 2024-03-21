//
//  ChartDataInterval.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 24.03.23.
//

import Foundation

enum ChartDataInterval: String, CaseIterable {
    case oneDay = "24h"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case threeMonth = "3m"
    case sixMonth = "6m"
    case oneYear = "1y"
    
    var startTime: Int? {
        let component: Calendar.Component
        let amount: Int
        
        switch self {
        case .oneDay:
            component = .day
            amount = -1
        case .oneWeek:
            component = .day
            amount = -7
        case .oneMonth:
            component = .month
            amount = -1
        case .threeMonth:
            component = .month
            amount = -3
        case .sixMonth:
            component = .month
            amount = -6
        case .oneYear:
            component = .year
            amount = -1
        }
        
        guard let startDate = Calendar.current.date(byAdding: component, value: amount, to: Date()) else { return nil }
        
        return Int(startDate.timeIntervalSince1970)
    }
    
    var streamInterval: String {
        switch self {
        case .oneDay:
            return "15m"
        case .oneWeek:
            return "1h"
        case .oneMonth:
            return "4h"
        case .threeMonth, .sixMonth, .oneYear:
            return "1d"
        }
    }
}
