//
//  Int+Addition.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 15.02.24.
//

import Foundation

extension Int {
    var formattedSeconds: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let remainingSeconds = self % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%02d:%02d", minutes, remainingSeconds)
        }
    }
}
