//
//  DeeplinkDestination.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.
//

import Foundation

public protocol DeeplinkDestinationing {
    
}

enum AccountTypeDeeplinkDestination: DeeplinkDestinationing {
    case changePassword
}

enum ChannelsDeeplinkDestination: DeeplinkDestinationing {
    case verifyEmail(token: String)
    case payOrReqeust(username: String)
    case chat(channelItem: ChannelItemModel)
    case payOrRequest(stateInfo: PayOrRequestStateInfoModel)
}

enum CryptoAccountDeeplinkDestination: DeeplinkDestinationing {
    case account(queryItems: [URLQueryItem])
    case cryptoDetails(queryItems: [URLQueryItem])
    case buyCrypto(queryItems: [URLQueryItem])
}

public enum TabBarDeeplinkDestination: Int, DeeplinkDestinationing {
    case channels = 0
    case cryptoAccount
    case profile
}

// TODO: - Update these paths

public final class DeeplinkSegmentsProvider {
    private static let knownPaths = [
        "/s/w/2.0/crypto",
        "/s/w/2.0/coins",
        "/s/w/2.0/crypto/buy/account-consent"
     ]
    
    public static func isKnownPath(_ path: String) -> Bool { return knownPaths.contains(path) }

    public static func tabIndex(for path: String) -> Int? {
        switch path {
        case "/s/w/2.0/payment":
            return 0
        case "/s/w/2.0/crypto", "/s/w/2.0/coins", "/s/w/2.0/crypto/buy/account-consent":
            return 2
        default :
            return nil
        }
    }
    
    public static func segments(from path: String, queryItems: [URLQueryItem]) -> [DeeplinkDestinationing] {
        switch path {
        case "/s/w/2.0/crypto", "/s/w/2.0/coins":
            return [CryptoAccountDeeplinkDestination.account(queryItems: queryItems)]
        case "/s/w/2.0/crypto/buy/account-consent":
            return [CryptoAccountDeeplinkDestination.cryptoDetails(queryItems: queryItems),
                    CryptoAccountDeeplinkDestination.buyCrypto(queryItems: queryItems)]
        default:
            return []
        }
    }
}
