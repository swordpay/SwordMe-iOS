//
//  Constants+API.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.12.22.
//

import Foundation

// MARK: - AuthenticationAPI

extension Constants {
    public enum AuthenticationAPI: APIRepresentable {
        case registerUser
        case login
        case phoneNumber
        case verifPhoneNumber
        case twoFactorAuth
        case userExistanceCheck
        case resendVerificationCode
        case usernameCheck
        case emailCheck
        case verifyEmail
        case verifyEmailToken
        case refreshAccessToken
        case additionalLogin
        case additionalTFA
        case authorizationCheck
        case testMisdirect

        public var path: String {
            switch self {
            case .registerUser:
                return "auth/register"
            case .login:
                return "auth/login"
            case .phoneNumber:
                return "phoneNumber"
            case .verifPhoneNumber:
                return "auth/phone/verify"
            case .twoFactorAuth:
                return "auth/2fa"
            case .userExistanceCheck:
                return "auth/check"
            case .resendVerificationCode:
                return "auth/code/resend"
            case .usernameCheck:
                return "auth/username/check"
            case .emailCheck:
                return "auth/email/check"
            case .verifyEmail:
                return "auth/email/send"
            case .verifyEmailToken:
                return "auth/email/verify"
            case .refreshAccessToken:
                return "auth/refresh"
            case .additionalLogin:
                return "auth/2fa"
            case .additionalTFA:
                return "auth/2fa/login"
            case .authorizationCheck:
                return "auth/check"
            case .testMisdirect:
                return "auth/test/misdirected"
            }
        }
        
        public var fileName: String {
            switch self {
            case .registerUser:
                return "RegisterUser"
            case .login:
                return "LoginService"
            case .phoneNumber:
                return "PhoneNumberService"
            case .verifPhoneNumber:
                return "VerifyPhoneNumberService"
            case .twoFactorAuth:
                return "TwoFactorAuthentication"
            case .userExistanceCheck:
                return "UserExistanceCheck"
            case .resendVerificationCode:
                return "ResendVerificationCode"
            case .usernameCheck:
                return "UsernameCheck"
            case .emailCheck:
                return "EmailCheck"
            case .verifyEmail:
                return "VerifyEmail"
            case .verifyEmailToken:
                return "VerifyEmailToken"
            case .refreshAccessToken:
                return "RefreshAccessToken"
            case .additionalLogin:
                return "AdditionalLogin"
            case .additionalTFA:
                return "AdditionalTFA"
            case .authorizationCheck:
                return "AuthorizationCheck"
            case .testMisdirect:
                return "TestMisdirect"
            }
        }
    }
}

// MARK: - Password

extension Constants {
    public enum PasswordAPI: APIRepresentable {
        case forgot
        case reset
        case change
        case verifyPhoneForPassword
        
        public var path: String {
            switch self {
            case .forgot:
                return "auth/password/check"
            case .verifyPhoneForPassword:
                return "auth/password/verify/phone"
            case .reset:
                return "auth/password/reset"
            case .change:
                return "auth/password"
            }
        }

        public var fileName: String {
            switch self {
            case .forgot:
                return "ForgotPassword"
            case .verifyPhoneForPassword:
                return "VerifyPhoneForPassword"
            case .reset:
                return "ResetPassword"
            case .change:
                return "Change Password"
            }
        }
    }
}

// MARK: - CommonAPI

extension Constants {
    public enum CommonAPI: APIRepresentable {
        case getCountries
        case getAppMode
        case accountsBalance
        case getUserByUsername(username: String)
        
        public var path: String {
            switch self {
            case .getCountries:
                return "countries"
            case .getAppMode:
                return "mode"
            case .accountsBalance:
                return "accounts/balance"
            case .getUserByUsername(let username):
                return "users/\(username)"
            }
        }
        
        public var fileName: String {
            switch self {
            case .getCountries:
                return "GetCountries"
            case .getAppMode:
                return "GetAppMode"
            case .accountsBalance:
                return "AccountsBalance"
            case .getUserByUsername:
                return "GetUserByUsername"
            }
        }
    }
}

// MARK: - UserAPI

extension Constants {
    public enum UserAPI: APIRepresentable {
        case getUser
        case getAllUser
        case avatar
        case deactivate
        
        public var path: String {
            switch self {
            case .getUser:
                return "users/me"
            case .getAllUser:
                return "users"
            case .avatar:
                return "media/avatar"
            case .deactivate:
                return "users/deactivate"
            }
        }

        public var fileName: String {
            switch self {
            case .getUser:
                return "GetUser"
            case .getAllUser:
                return "GetAllUsers"
            case .avatar:
                return "UserAvatar"
            case .deactivate:
                return "DeactivateUser"
            }
        }
    }
}


// MARK: - Device

extension Constants {
    public enum DeviceAPI: APIRepresentable {
        case createDevice
        case deleteDevice(token: String)
        
        public var path: String {
            switch self {
            case .createDevice:
                return "devices"
            case .deleteDevice(let token):
                return "devices/\(token)"
            }
        }

        public var fileName: String {
            switch self {
            case .createDevice:
                return "CreateDevice"
            case .deleteDevice:
                return "DeleteDevice"
            }
        }
    }
}

// MARK: - Channels

extension Constants {
    public enum ChannelsAPI: APIRepresentable {
        case syncContacts
        case getChannels
        case createDMChannel
        case createGroupChannel
        case getChannelMessages(channelId: Int)
        case sendMessage(channelId: Int)
        case getUsers(channelId: Int)
        case deleteChannel(channelId: Int)

        public var path: String {
            switch self {
            case .syncContacts:
                return "contacts/sync"
            case .getChannels:
                return "chat/rooms"
            case .createDMChannel:
                return "chat/rooms/dm"
            case .createGroupChannel:
                return "chat/rooms/group"
            case .getChannelMessages(let channelId):
                return "chat/rooms/\(channelId)/messages"
            case .sendMessage(let channelId):
                return "chat/rooms/\(channelId)/messages"
            case .getUsers(let channelId):
                return "chat/rooms/\(channelId)/users"
            case .deleteChannel(let channelId):
                return "chat/rooms/\(channelId)"
            }
        }
        
        public var fileName: String {
            switch self {
            case .syncContacts:
                return "SyncContacts"
            case .getChannels:
                return "GetChannels"
            case .createDMChannel:
                return "CreateDMChannel"
            case .createGroupChannel:
                return "CreateGroupChannel"
            case .getChannelMessages:
                return "GetChannelMessages"
            case .sendMessage:
                return "SendMessage"
            case .getUsers:
                return "GetChannelUsers"
            case .deleteChannel:
                return "DeleteChannel"
            }
        }
    }
}

// MARK: - Payments

extension Constants {
    public enum PaymentsAPI: APIRepresentable {
        case makePayment
        case acceptPayment(paymentId: String)
        case declinePayment(paymentId: String)
        case latest
        case getPaymentInfo(paymentId: String)

        public var path: String {
            switch self {
            case .makePayment:
                return "payments"
            case .acceptPayment(let paymentId):
                return "payments/\(paymentId)/accept"
            case .declinePayment(let paymentId):
                return "payments/\(paymentId)/reject"
            case .latest:
                return "payments/latest"
            case .getPaymentInfo(let paymentId):
                return "payments/\(paymentId)"
            }
        }
        
        public var fileName: String {
            switch self {
            case .makePayment:
                return "MakePayment"
            case .acceptPayment:
                return "AcceptPayment"
            case .declinePayment:
                return "DeclinePayment"
            case .latest:
                return "LatestPayments"
            case .getPaymentInfo:
                return "GetPaymnetInfo"
            }
        }
    }
}
// MARK: - Accounts

extension Constants {
    public enum AccountsAPI: APIRepresentable {
        case fiatList
        case details
        case topUp
        case withdraw
        case updateDefaultPaymentMethod(String)

        public var path: String {
            switch self {
            case .fiatList:
                return "accounts/fiat"
            case .details:
                return "accounts/details"
            case .topUp:
                return "accounts/fiat/top-up"
            case .withdraw:
                return "accounts/fiat/withdraw"
            case .updateDefaultPaymentMethod(let id):
                return "accounts/fiat/\(id)/payment-method"
            }
        }

        public var fileName: String {
            switch self {
            case .fiatList:
                return "FiatAccountsList"
            case .details:
                return "AccountDetails"
            case .topUp:
                return "FiatAccountTopUp"
            case .withdraw:
                return "AccountWithdraw"
            case .updateDefaultPaymentMethod:
                return "UpdateDefaultPaymentMethod"
            }
        }
    }
}

// MARK: - Cards

extension Constants {
    public enum CardsAPI: APIRepresentable {
        case list
        case details(cardId: Int)
        case order
        case activate(cardId: Int)
        case freeze(cardId: Int)
        case block(cardId: Int)
        case stole(cardId: Int)
        case lost(cardId: Int)
        case resetPin(cardId: Int)

        public var path: String {
            switch self {
            case .list:
                return "cards"
            case .details(let cardId):
                return "cards/\(cardId)/details"
            case .order:
                return "cards/order"
            case .activate(let cardId):
                return "cards/\(cardId)/activate"
            case .freeze(let cardId):
                return "cards/\(cardId)/freeze"
            case .block(let cardId):
                return "cards/\(cardId)/block"
            case .stole(let cardId):
                return "cards/\(cardId)/stolen"
            case .lost(let cardId):
                return "cards/\(cardId)/lost"
            case .resetPin(let cardId):
                return "cards/\(cardId)/reset-pin"
            }
        }

        public var fileName: String {
            switch self {
            case .list:
                return "CardsList"
            case .details:
                return "CardDetails"
            case .order:
                return "OrderCard"
            case .activate:
                return "ActivateCard"
            case .freeze:
                return "FreezeCard"
            case .block:
                return "BlockCard"
            case .stole:
                return "StoleCard"
            case .lost:
                return "LostCard"
            case .resetPin:
                return "ResetPin"
            }
        }
    }
}

// MARK: - Cards

extension Constants {
    public enum TransactionsAPI: APIRepresentable {
        case all
        case list
        case cryptoList
        case fiatExternalTransfer
        case buyCryptoStatusCheck(transactionId: Int)
        
        public var path: String {
            switch self {
            case .all:
                return "transactions"
            case .list:
                return "transactions/fiat"
            case .cryptoList:
                return "transactions/crypto"
            case .fiatExternalTransfer:
                return "transactions/fiat/external"
            case .buyCryptoStatusCheck(let transactionId):
                return "transactions/crypto/\(transactionId)"
            }
        }
        
        public var fileName: String {
            switch self {
            case .all:
                return "AllTransactions"
            case .list:
                return "TransactionsList"
            case .cryptoList:
                return "CryptoTransactionsList"
            case .fiatExternalTransfer:
                return "FiatExternalTransfer"
            case .buyCryptoStatusCheck:
                return "BuyCryptoStatusCheck"
            }
        }
    }
}

// MARK: - CryptoAPI

extension Constants {
    public enum CryptoAPI: APIRepresentable {
        case assetsList
        case assetItemInfo(coin: String)
        case balance
        case assetsPricesOnMainCoin
        case assetsPricesChanges
        case depositAddress
        case tradeInfo
        case buyCrypto
        case sellCrypto
        case withdrawTransfer
        case withdrawAddresses
        case convertableCryptosList(coin: String)
        case convertCrypto
        case cryptoChartData(symbol: String, startTime: Int, interval: String)
        case convertableCryptoPrecision
        
        public var path: String {
            switch self {
            case .assetsList:
                return "crypto/assets"
            case .assetItemInfo(let coin):
                return "crypto/assets/\(coin)"
            case .balance:
                return "crypto/balance"
            case .assetsPricesOnMainCoin:
                return "ticker/price?symbols="
            case .assetsPricesChanges:
                return "api/v3/ticker/24hr?symbols="
            case .depositAddress:
                return "crypto/deposit/address"
            case .tradeInfo:
                return "crypto/trade/info"
            case .buyCrypto:
                return "crypto/buy"
            case .sellCrypto:
                return "crypto/sell"
            case .withdrawTransfer:
                return "crypto/withdraw"
            case .withdrawAddresses:
                return "crypto/withdraw/addresses"
            case .convertableCryptosList(let coin):
                return "sapi/v1/convert/exchangeInfo?fromAsset=\(coin)"
            case .convertCrypto:
                return "crypto/convert"
            case .cryptoChartData(let symbols, let startTime, let interval):
                return "api/v3/klines?symbol=\(symbols)&startTime=\(startTime)&interval=\(interval)&limit=150"
            case .convertableCryptoPrecision:
                return "crypto/convert/info"
            }
        }
        
        public var fileName: String {
            switch self {
            case .assetsList:
                return "CryptoAssetsList"
            case .assetItemInfo:
                return "AssetItemInfo"
            case .balance:
                return "CryptoBalance"
            case .assetsPricesOnMainCoin:
                return "AssetsPricesOnBTC"
            case .assetsPricesChanges:
                return "AssetsPricesChanges"
            case .depositAddress:
                return "CryptoDepositAddress"
            case .tradeInfo:
                return "CryptoTradeInfo"
            case .buyCrypto:
                return "BuyCrypto"
            case .sellCrypto:
                return "SellCrypto"
            case .withdrawTransfer:
                return "WithdrawTransfer"
            case .withdrawAddresses:
                return "WithdrawAddresses"
            case .convertableCryptosList:
                return "ConvertableCryptosList"
            case .convertCrypto:
                return "ConvertCrypto"
            case .cryptoChartData:
                return "CryptoChartData"
            case .convertableCryptoPrecision:
                return "ConvertableCryptoPrecision"
            }
        }
    }
}
