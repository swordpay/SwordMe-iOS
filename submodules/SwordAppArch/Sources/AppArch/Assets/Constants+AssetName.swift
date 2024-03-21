//
//  Constants+AssetName.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.06.22.
//

import Foundation

extension Constants {
    enum AssetName {

    }
}

// MARK: - Common

extension Constants.AssetName {
    enum Common {
        static let appLogo = "app-logo-icon"
        static let titleSwordLogo = "tilte-sword-logo"
        static let back = "back-icon"
        static let success = "success-icon"
        static let error = "error-icon"
        static let phone = "phone.fill"
        static let key = "key"
        static let faceId = "faceid"
        static let touchId = "touchid"
        static let noInternet = "no-internet-icon"
        static let delete = "trash.circle"
        static let check = "checkmark"
        static let copy = "doc.on.doc"
        static let termsSelectedCheckmark = "terms-selected-checkbox-icon"
        static let checkmarkSelected = "checkmark-selected-icon"
        static let termsUnselectedCheckmark = "terms-unselected-checkbox-icon"
        static let checkmarkUnselected = "checkmark-unselected-icon"
        static let addPhoto = "add-photo-icon"
        static let visaCard = "visaCard-icon"
        static let visaCardWhite = "visaCard-white-icon"
        static let masterCard = "masterCard-icon"
        static let lock = "lock-icon"
        static let backgroundedTrash = "backgrounded-trash-icon"
        static let plus = "plus-icon"
        static let radioSelected = "radio-selected-icon"
        static let radioUnselected = "radio-unselected-icon"
        static let close = "close-icon"
        static let cash = "cash-icon"
        static let crypto = "crypto-icon"
        static let bottomArrow = "bottom-arrow-icon"
        static let greenCheck = "check-icon"
        static let warning = "warning-icon"
        static let phoneIcon = "phone_icon"
        static let emailIcon = "email_icon"
        static let euroImage = "european-union-icon"
        static let swordHugeWhite = "sword-huge-white-icon"
        static let swordSmallWhite = "sword-small-white-icon"
        static let swordHugeBlue = "sword-huge-blue-icon"
        static let swordHorizontal = "sword-horizontal-icon"
        static let search = "search-icon"
        static let infoIcon = "Info-icon"
        static let infoIconBlue = "info-icon-blue"
        static let disabledCard = "disabled-card-icon"
        static let disabledVisaCard = "visa-disabled-icon"
        static let settings = "settings-icon"
        static let dropDown = "drop-down-icon"
        static let registrationCompletion = "registration-completion-banner"
        static let registrationCompletionSmall = "registration-completion-banner-small"
        
        static let cameraAccess = "camera-access-icon"
        static let contactsAccess = "contacts-access-icon"
        static let emptyResult = "empty-result-icon"
        static let noInternetConnection = "no-internet-connection-icon"
        static let infinity = "infinity-icon"
        static let timer = "timer-icon"
    }
}

extension Constants.AssetName {
    enum Onboarding: Int {
        case sendOrReqeust
        case anytime

        var name: String {
            switch self {
            case .sendOrReqeust:
                return "onboarding-send-or-request-icon"
            case .anytime:
                return "onboarding-anytime-icon"
            }
        }
    }
}

// MARK: - Tabbar

extension Constants.AssetName {
    enum TabBar {
        static let channels = "tabbar-channels-icon"
        static let fiatAccount = "tabbar-fiatAccount-icon"
        static let cryptoAccount = "tabbar-cryptoAccount-icon"
        static let profile = "tabbar-profile-icon"
    }
}

// MARK: - SystemIcon

extension Constants.AssetName {
    enum SystemIcon {
        static let back = "chevron.left"
        static let square = "square"
        static let checkmarkSquare = "checkmark.square"
        static let close = "xmark"
        static let circledClose = "xmark.circle.fill"
        static let circle = "circle"
        static let recordCircle = "record.circle"
        static let share = "arrowshape.turn.up.right.fill"
        static let addCard = "rectangle.badge.plus"
        static let info = "info.circle"
        static let snow = "snow"
        static let resetPin = "lock.rotation.open"
        static let qrCode = "qrcode.viewfinder"
        static let transactions = "arrow.left.arrow.right.square"
        static let security = "shield"
        static let contactUs = "envelope.circle"
        static let privacyPolicy = "lock.shield"
        static let termsAndConditions = "doc.text"
        static let plus = "plus"
        static let edit = "pencil"
        static let warning = "exclamationmark.triangle.fill"
        static let sentTransaction = "arrow.uturn.right.circle"
        static let receivedTransaction = "arrow.uturn.backward.circle"
        static let currencyExchange = "arrow.triangle.2.circlepath.circle"
        static let reportIssue = "gear.badge.questionmark"
        static let externalTransfer = "dollarsign.arrow.circlepath"
        static let printer = "printer.filled.and.paper"
        static let errorIcon = "exclamationmark.circle.fill"
        static let card = "creditcard.fill"
        static let play = "play.fill"
        static let pause = "pause.fill"
    }
}

// MARK: - InputText

extension Constants.AssetName {
    enum InputText {
        static let secureText = "secure-text-icon-visible"
        static let hiddenSecureText = "secure-text-icon-hidden"
        static let clearText = "clear-text-icon"
    }
}

// MARK: - Authentication

extension Constants.AssetName {
    enum Authentication {
        static let selectedCheckmark = "selected-checkmark-icon"
        static let accountTypePersonalSelected = "account-type-personal-selected-icon"
        static let accountTypePersonalUnselected = "account-type-personal-unselected-icon"
        static let accountTypeCreatorSelected = "account-type-creator-selected-icon"
        static let accountTypeCreatorUnselected = "account-type-creator-unselected-icon"
    }
}

// MARK: - MultiActionedInfo

extension Constants.AssetName {
    enum MultiActionedInfo {
        static let mainIconNotification = "notification-icon"
        static let mainIconAddCard = "add-card-onboarding-icon"
        static let addCardCompletion = "add-card-completion-icon"
        static let checkmark = "checkmark-icon"
        static let blueDotImagePlaceholder = "blue-dot-image-placeholder"
    }
}

// MARK: - Channels

extension Constants.AssetName {
    enum Channels {
        static let direcMessage = "directMessage-icon"
        static let groupChannel = "groupChannel-icon"
        static let logo = "small-logo-icon"
        static let scan = "scan-icon"
        static let arrows = "arrows-icon"
        static let channelIconPlaceholder = "channel-icon-placeholder"
        static let completedTrasaction = "completed-transaction-icon"
        static let pendingTrasaction = "pending-transaction-icon"
    }
}

// MARK: - FiatAccount

extension Constants.AssetName {
    enum FiatAccount {
        static let emptyCards = "empty-cards-icon"
        static let mainEmptyScreenError = "account-empty-state-error-icon"
        static let mainEmptyScreenNotSupported = "account-empty-state-country-icon"
        static let copy = "copy-icon"
        static let details = "card-details-icon"
        static let freeze = "card-freeze-icon"
        static let resetPin = "card-reset-pin"
        static let externalTransfer = "external-transfer-icon"
        static let reportIssue = "report-issue-icon"
        static let fiatExternalTransfer = "fiat-external-transfer-icon"
        static let fiatInfo = "fiat-info-icon"
        static let withdrawal = "withdrawal-icon"
        static let skrill = "skrill-icon"
        static let otherPaymentOption = "other-paymnetmethod-icon"
    }
}

// MARK: - cryptoAccount

extension Constants.AssetName {
    enum CryptoAccount {
        static let cryptoIconPlaceholder = "crypto-placeholder-icon"
        static let exchange = "exchange-crypto"
        static let bestPrice = "best-price-icon"
    }
}

// MARK: - Profile

extension Constants.AssetName {
    enum Profile {
        static let physicalCard = "physical-cards"
        static let virtualCard = "virtual-cards"
        static let cardPlaceholder = "card-placeholder-icon"
    }
}

// MARK: - MultiActionedInfo

// MARK: - System Services
extension Constants.AssetName {
    enum SystemServices {
        static let systemServiceInternet = "system_service_internet_icon"
    }
}
