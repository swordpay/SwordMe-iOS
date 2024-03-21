//
//  AppData.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import Foundation

public struct AppData {
    @Storage(key: .currentUserInfo, defaultValue: nil)
    public static var currentUserInfo: UserModel?
    
    @Storage(key: .onboardingUser, defaultValue: nil)
    public static var onboardingUser: OnboardingUserModel?
    
    @Storage(key: .isBiometricAuthenticationEnabled, defaultValue: nil)
    public static var isBiometricAuthenticationEnabled: Bool?
        
    @Storage(key: .isFirstLaunch, defaultValue: nil)
    public static var isFirstLaunch: Bool?
    
    @Storage(key: .appVersion, defaultValue: nil)
    public static var appVersion: String?
    
    @Storage(key: .pushNotificationUserInfo, defaultValue: nil)
    public static var pushNotificationUserInfo: Data?
    
    @Storage(key: .deepLinkURL, defaultValue: nil)
    public static var deepLinkURL: URL?
    
    @Storage(key: .isRegistredUserExists, defaultValue: false)
    public static var isRegistredUserExists: Bool
    
    @Storage(key: .payOrRequestStateInfo, defaultValue: nil)
    public static var payOrRequestStateInfo: PayOrRequestStateInfoModel?
    
    @Storage(key: .needIntergiroPrivicyPolicy, defaultValue: nil)
    public static var needIntergiroPrivicyPolicy: Bool?
    
    @Storage(key: .wasOnboardinScreenPresented, defaultValue: false)
    public static var wasOnboardinScreenPresented: Bool
    
    @Storage(key: .userAvatarData, defaultValue: nil)
    public static var userAvatarData: Data?
    
    @Storage(key: .userPhoneNumber, defaultValue: nil)
    public static var userPhoneNumber: String?
    
    @Storage(key: .userTelegramPeerId, defaultValue: nil)
    public static var userTelegramPeerId: Int64?

    @Storage(key: .userTelegramExtraPeerId, defaultValue: nil)
    public static var userTelegramExtraPeerId: Int64?

    @Storage(key: .telegramUserUsername, defaultValue: nil)
    public static var telegramUserUsername: String?

    @Storage(key: .isTFAEnabled, defaultValue: false)
    public static var isTFAEnabled: Bool
    
    @Storage(key: .hasChatFolders, defaultValue: false)
    public static var hasChatFolders: Bool
    
    @Storage(key: .isChannelAdmin, defaultValue: false)
    public static var isChannelAdmin: Bool
    
    
    @Storage(key: .isAppAcitve, defaultValue: true)
    public static var isAppAcitve: Bool
    
    
    @Storage(key: .accessToken, defaultValue: nil)
    public static var accessToken: String?

}

@propertyWrapper
public struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults

    init(key: Constants.AppDataKey, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: T {
        get {
            guard let data = storage.object(forKey: key) as? Data else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)

            storage.set(data, forKey: key)
        }
    }
}
