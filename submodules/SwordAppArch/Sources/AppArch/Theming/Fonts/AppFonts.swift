//
//  AppFonts.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import UIKit

public protocol AppFonts {
    func regular(ofSize size: CGFloat, family: FontFamily) -> UIFont
    func medium(ofSize size: CGFloat, family: FontFamily) -> UIFont
    func bold(ofSize size: CGFloat, family: FontFamily) -> UIFont
    func semibold(ofSize size: CGFloat, family: FontFamily) -> UIFont

    func robotoSemibold(ofSize size: CGFloat) -> UIFont
    func rubikItalic(ofSize size: CGFloat) -> UIFont
    
    func font(style: FontStyle, family: FontFamily, weight: FontWeight) -> UIFont
}

public enum FontStyle {
    case largeTitle1
    case largeTitle2
    case header
    case capture
    case smallCapture
    case body
    case buttonTitle
    case smallButtonTitle
    case smallText
    case placeholder
    
    case sendOrRequestButton
    case customButton
    case channelItem
    case channelItemLastMessageDate
    case homeSegmentsTilte

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
        case .largeTitle1:
            return[28, 36, 44, 44, 44]
        case .largeTitle2:
            return[26, 30, 30, 34, 36]
        case .header:
            return[22, 24, 26, 26, 28]
        case .capture:
            return[18, 20, 22, 24, 28]
        case .smallCapture:
            return [12, 14, 16, 18, 18]
        case .body:
            return [14, 18, 20, 22, 22]
        case .buttonTitle:
            return[15, 19, 19, 19, 19]
        case .smallButtonTitle:
            return[14, 16, 16, 16, 16]
        case .smallText:
            return [12, 14, 14, 16, 18]
        case .placeholder:
            return [14, 16, 18, 18, 20]
        case .sendOrRequestButton:
            return [15.5, 20, 21, 22, 23]
        case .customButton:
            return [15.5, 19.5, 20.5, 21.5, 22.5]
        case .channelItem:
            return [12, 14, 16, 16, 18]
        case .channelItemLastMessageDate:
            return [10, 12, 12, 14, 16]
        case .homeSegmentsTilte:
            return [16, 18, 18, 20, 20]
        }
    }
}
