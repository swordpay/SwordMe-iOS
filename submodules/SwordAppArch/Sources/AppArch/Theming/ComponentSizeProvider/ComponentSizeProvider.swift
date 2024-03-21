//
//  ComponentSizeProvider.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 07.06.23.
//

import UIKit

public enum ScreenSize {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
    
    public static var currentScrennSize: ScreenSize {
        let screenSize = UIScreen.main.bounds.size

        if screenSize.width <= 320 {
            return .extraSmall
        } else if screenSize.width <= 375 {
            return .small
        } else if screenSize.width <= 393 {
            return .medium
        } else if screenSize.width <= 414 {
            return .large
        } else {
            return .extraLarge
        }
    }
}

public enum ComponentSizeProvider {
    case sendOrReqeustButtonHeight
    case recentRoomsItemHeight
    case homeSearchBarHeight
    case channelItemImageHeight
    
    public var size: CGFloat {
        switch ScreenSize.currentScrennSize {
        case .extraSmall:
            return sizes[0]
        case .small:
            return sizes[1]
        case .medium:
            return sizes[2]
        case .large:
            return sizes[3]
        case .extraLarge:
            return sizes[4]
        }
    }

    private var sizes: [ CGFloat ] {
        switch self {
        case .sendOrReqeustButtonHeight:
            return[38.4, 45, 46.8, 49.54, 51.32]
        case .recentRoomsItemHeight:
            return[50, 52, 54, 60, 64]
        case .homeSearchBarHeight:
            return [40, 46, 48, 50, 54]
        case .channelItemImageHeight:
            return [44.57, 52, 54.48, 56.95, 61.9]
        }
    }
}
