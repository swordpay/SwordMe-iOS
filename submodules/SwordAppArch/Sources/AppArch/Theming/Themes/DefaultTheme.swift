//
//  DefaultTheme.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation

final class DefaultTheme: Theming {
    var colors: AppColors { return DefaultColors() }
    var fonts: AppFonts { return DefaultFonts() }
}
