//
//  IndeterminateProgressViewModel.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 08.02.24.
//

import UIKit
import Combine

public final class IndeterminateProgressViewModel {
    let progress: CurrentValueSubject<Double, Never> = .init(0)
    let progressTintColor: UIColor
    let trackTintColor: UIColor
    
    init(progressTintColor: UIColor = ThemeProvider.currentTheme.colors.textBlue, trackTintColor: UIColor = ThemeProvider.currentTheme.colors.lightBlue2) {
        self.progressTintColor = progressTintColor
        self.trackTintColor = trackTintColor
    }
}
