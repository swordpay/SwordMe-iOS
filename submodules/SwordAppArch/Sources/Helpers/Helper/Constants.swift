//
//  Constants.swift
//  sword-ios
//
//  Created by Scylla IOS on 03.06.22.
//

import UIKit
import Postbox
import TelegramCore
import UniformTypeIdentifiers

private final class BundleHelper: NSObject {
}

public enum Constants {}

extension Constants {
    public static let fileMaxAllowedSize: Int64 = 100
    public static let oneMBinBytes: Int64 = 1048576
    
    public static var mainFiat: String {
        return "eur"
    }

    public static var paymentItemWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.6
    }
    
    static var defaultButtonHeight: CGFloat {
        return UIScreen.hasSmallScreen ? 50 : 60
    }
    
    public static var maximumDigitsOfDouble: Int {
        return 12
    }
    
    public static var cryptoDefaultPrecision: Int {
        return 8
    }
    
    public static var fiatDefaultPrecision: Int {
        return 2
    }
    
    public static var swordMeDomain: String {
        return "t.me"
    }
    
    public static var mainBundle: Bundle {
        let mainBundle = Bundle(for: BundleHelper.self)
        guard let path = mainBundle.path(forResource: "SwordAppArchBundle", ofType: "bundle") else {
            fatalError("Cant get bundle")
        }
        guard let bundle = Bundle(path: path) else {
            fatalError("Cant get bundle")
        }

        return bundle
    }
    
    public static var sword: String {
        return "Sword"
    }
    
    static var euro: String {
        return "€"
    }

    static var infinity: String {
        return "\u{221E}"
    }

    // MARK: - App URLs

    public enum AppURL {
        static let appStoreURL = URL(string: "")!
        static let networkingProdMainURL: URL = URL(string: "")!
        static let networkingStagingMainURL: URL = URL(string: "")!
        static var networkingBaseURL: URL {
            return AppEnvironment.isStaging ? networkingStagingMainURL
            : networkingProdMainURL
        }
        
        public static var associatedDomain: String {
            return ""
        }

        public static var sendOrRequestMessagePath: String {
            return ""
        }
        
        public static var deeplinkingBasePath: String {
            return ""
        }

        static var messagingBaseURL: URL {
            return AppEnvironment.isStaging ? messagingStagingURL
                                            : messagingProdURL
        }

        static let messagingProdURL = URL(string: "")!
        static let messagingStagingURL = URL(string: "")!
        static let networkingBinanceMainURL: URL = URL(string: "https://api.binance.com/")!
        public static let termsAndConditions = ""
        public static let privacyPolicy = ""
        static let aboutUs = ""
        
        static let instruction = ""
        static let assetsBaseURL = ""
        static let supportEmail = ""
        static let inviteFriendURL = ""
        static func cryptoIconURL(coin: String) -> URL? {
            return URL(string: "\(assetsBaseURL)crypto/\(coin).png")
        }
    }
}

// MARK: - App Lables

extension Constants {
    enum AppLabel {
        static let cacherIdentifier: String = "com.sword-ios_Data_Cacher"
        static let dataDownloaderIdentifier: String = "com.sword-ios_Data_Downloading"
        static let themeIdentifier: String = "com.sword-ios_Theme_Provider_Queue"
    }
}

// MARK: - File Types

extension Constants {
    enum FileType: String {
        case json
        case mp4 = "MP4"
    }
}

// MARK: - Typealiases

extension Constants {
    public enum Typealias {
        public typealias VoidHandler = () -> Void
        public typealias CompletioHandler<T> = (T) -> Void
        public typealias MediaSelectionHandler = (MediaType) -> Void
        public typealias TextValidationResult = (TextValidationResultState, String?)
        public typealias ScreenPresentationCompletion = () -> Void
        public typealias SystemServiceRequestCompletionHandler = () -> Void
        public typealias PeerExtendedInfo = ChannelsHeaderViewModel.Info
    }
}

// MARK: - Date Format

extension Constants {
    struct DateFormat {
        static let ddmmyyyy_dotted = "dd.MM.yyyy"
        static let mmddyy_slashed = "MM/dd/yy"
        static let hhmm = "HH:mm"
        static let mmmdyyyy_commaed = "MMM d, yyyy"
        static let dMMMhmma_commaed = "d MMM , h:mm a"
        static let yyyymmdd_dashed = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let EMMMd = "E, MMM d"
        static let MMyy_slashed = "MM/yy"
        static let ddMM_slashed = "dd/MM"
        static let MMddYYYY_slashed = "MM/dd/YYYY"
        static let yyyymmdd_dashed_withoutTimezone = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    }
}

// MARK: - Resource Name

extension Constants {
    struct Resource {
        static let enrollmentAnimation = "enrollment-animation"
        static let enrollmentCompletionAnimation = "enrollment-completion-animation"
        static let buyTicketAnimation = "buy-ticket-completion-animation"
        static let donateTicketAnimation = "donate-ticket-completion-animation"
        static let getTicketAnimation = "get-ticket-completion-animation"
    }
}

// TODO: - Should be deleted
extension Constants {
    static var dummyText: String {
        let text = "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries"
        let endIndex = Int.random(in: 10..<text.count)
        let index = text.index(text.startIndex, offsetBy: endIndex)
        let substring = text.prefix(upTo: index)
        
        return String(substring)
    }
}
public func prepareTransactionMessageText(from message: String, media: Media?, engineMessage: Message) -> String {
    let prefix: String
    let status: String
    if message.contains(Constants.AppURL.sendOrRequestMessagePath) {
        guard let decodedMessage = DecodedPaymentMessage(text: message) else { return message }
        
        prefix = "Money "
        
        switch decodedMessage.paymentType {
        case .send:
            status = "Sent 💰"
        case .request:
            status = "Requested 💰"
        case .accept:
            let prefix = decodedMessage.peerId == nil && decodedMessage.extraPeerId == nil ? "RECEIVED!" : "Sent"
            status = "\(prefix) 💰"
        case .reject:
            status = "Rejected"
        }
    } else { return message }
    
    return prefix + status
}
