//
//  Constants+Localizations.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import Foundation
// MARK: - SwordChange // add .string file
public extension Constants {
    enum Localization {

    }
}

// Common
public extension Constants.Localization {
    enum Common {
        public static let appName = "common.appName".localized
        public static let `continue` = "common.continue".localized
        public static let ok = "common.ok".localized
        public static let cancel = "common.cancel".localized
        public static let minute = "common.minute".localized
        public static let second = "common.second".localized
        public static let done = "common.done".localized
        public static let close = "common.close".localized
        public static let save = "common.save".localized
        public static let gallery = "common.gallery".localized
        public static let camera = "common.camera".localized
        public static let upload = "common.upload".localized
        public static let remove = "common.remove".localized
        public static let call = "common.call".localized
        public static let contacts = "common.contacts".localized
        public static let phoneNumber = "common.phoneNumber".localized
        public static let phone = "common.phone".localized
        public static let website = "common.website".localized
        public static let date = "common.date".localized
        public static let time = "common.time".localized
        public static let search = "common.search".localized
        public static let loading = "common.loading".localized
        public static let yes = "common.yes".localized
        public static let no = "common.no".localized
        public static let delete = "common.delete".localized
        public static let placeholder = "common.placeholder".localized
        public static let change = "common.change".localized
        public static let edit = "common.edit".localized
        public static let apply = "common.apply".localized
        public static let message = "common.message".localized
        public static let show = "common.show".localized
        public static let email = "common.email".localized
        public static let password = "common.password".localized
        public static let firstName = "common.firstName".localized
        public static let lastName = "common.lastName".localized
        public static let fullName = "common.fullName".localized
        public static let venue = "common.venue".localized
        public static let send = "common.send".localized
        public static let create = "common.create".localized
        public static let confirm = "common.confirm".localized
        public static let congratulations = "common.congratulations".localized
        public static let information = "common.information".localized
        public static let code = "common.code".localized
        public static let attention = "common.attention".localized
        public static let enable = "common.enable".localized
        public static let disable = "common.disable".localized
        public static let unableToHandleAction = "common.unableToHandleAction".localized
        public static let verification = "common.verification".localized
        public static let versoin = "common.version".localized
        public static let required = "common.required".localized
        public static let answer = "common.answer".localized
        public static let other = "common.other".localized
        public static let submit = "common.submit".localized
        public static let quiz = "common.quiz".localized
        public static let next = "common.next".localized
        public static let start = "common.start".localized
        public static let scan = "common.scan".localized
        public static let payOrRequest = "common.payOrRequest".localized
        public static let today = "common.today".localized
        public static let pay = "common.pay".localized
        public static let request = "common.request".localized
        public static let cash = "common.cash".localized
        public static let crypto = "common.crypto".localized
        public static let details = "common.details".localized
        public static let addCard = "common.addCard".localized
        public static let country = "common.country".localized
        public static let login = "common.login".localized
        public static let verify = "common.verify".localized
        public static let share = "common.share".localized
        public static let faceID = "common.faceID".localized
        public static let touchID = "common.touchID".localized
        public static let cardNumber = "common.cardNumber".localized
        public static let expiryDate = "common.expiryDate".localized
        public static let cvv = "common.cvv".localized
        public static let refresh = "common.refresh".localized
        public static let buy = "common.buy".localized
        public static let sell = "common.sell".localized
        public static let converter = "common.converter".localized
        public static let convert = "common.convert".localized
        public static let allowAccess = "common.allowAccess".localized
        public static let exchange = "common.exchange".localized
        public static let recents = "common.recents".localized
        public static let print = "common.print".localized
        public static let accept = "common.accept".localized
        public static let decline = "common.decline".localized
        public static let fiat = "common.fiat".localized
        public static let you = "common.you".localized
        public static let your = "common.your".localized
        public static let reject = "common.reject".localized
        public static let users = "common.users".localized
        public static let warning = "common.warning".localized
        public static let feed = "common.feed".localized
        public static let activity = "common.activity".localized
        public static let scanCode = "common.scanCode".localized
        public static let swordMe = "common.swordMe".localized
        public static let transfer = "common.transfer".localized
        public static let rejected = "common.rejected".localized
        public static let requested = "common.requested".localized
        public static let sent = "common.sent".localized
        public static let received = "common.received".localized
        public static let completed = "common.completed".localized
        public static let from = "common.from".localized
        public static let to = "common.to".localized
        public static let deposit = "common.deposit".localized
        public static let exTransfer = "common.exTransfer".localized
        public static let connecting = "common.connecting".localized
        public static let connectionLost = "common.connectionLost".localized
        public static let amount = "common.amount".localized
        public static let name = "common.name".localized
        public static let skip = "common.skip".localized
        public static let network = "common.network".localized
        public static let saveAsImage = "common.saveAsImage".localized
        public static let shareAddress = "common.shareAddress".localized
        public static let withdrawal = "common.withdrawal".localized
        public static let errorMessage = "common.errorMessage".localized

        public static let uploadPhoto = "common.uploadPhoto".localized
        public static let uploadPhotoType = "common.uploadPhotoType".localized
        public static let photoEditOptionAlertTitle = "common.photoEditOption.alert.title".localized
        public static let photoEditOptionAlertMessage = "common.photoEditOption.alert.message".localized
        public static let moneyAmount = "common.moneyAmount".localized
    }
}

// Onboarding
public extension Constants.Localization {
    enum Onboarding {
        static func tutorialTitle(for index: Int) -> String { return "onboarding.tutorial.title\(index)".localized }
        static func tutorialDescription(for index: Int) -> String { return "onboarding.tutorial.description\(index)".localized }
        static let skipToSignIn = "onboarding.tutorial.skipToSignIn".localized
    }
}

// Authentication
public extension Constants.Localization {
    enum Authentication {
        static let phoneNumberRegDescription = "authentication.phoneNumber.reg.description".localized
        static let userExistsInfo = "authentication.login.userExistsInfo".localized
        static let loginDescription = "authentication.login.description".localized
        static let nameInfo = "authentication.createAccount.nameInfo".localized
        static let usernameErrorTitle = "authentication.createAccount.usernameError.title".localized
        static let usernameErrorMessage = "authentication.createAccount.usernameError.message".localized
        static let emailErrorTitle = "authentication.userCredentials.emailError.title".localized
        static let emailErrorMessage = "authentication.userCredentials.emailError.message".localized
        static let accountTypeTitle = "authentication.accountType.title".localized
        static let accountTypePickerTitle = "authentication.accountType.pickerTitle".localized
        static let accountTypePersonal = "authentication.accountType.personal".localized
        static let accountTypeBusiness = "authentication.accountType.business".localized
        static let accountTypeCreator = "authentication.accountType.creator".localized
        static let accountTypeGetStarted = "authentication.accountType.getStarted".localized
        static let login = "authentication.login".localized
        static let logOut = "authentication.logOut".localized
        static let phoneNumberPlaceholder = "authentication.phoneNumber.placeholder".localized
        static let phoneOrEmailPlaceholder = "authentication.login.phoneOrEmail.placeholder".localized
        static let firstNamePlaceholder = "authentication.firstName.placeholder".localized
        static let lastNamePlaceholder = "authentication.lastName.placeholder".localized
        static let userNamePlaceholder = "authentication.userName.placeholder".localized
        static let createAccountTypeHere = "authentication.createAccount.typeHere".localized
        static let passwordPlaceholder = "authentication.password.placeholder".localized
        static let emailPlaceholder = "authentication.email.placeholder".localized
        static let sendCode = "authentication.phoneNumber.sendCode".localized
        static let phoneNumberTitle = "authentication.phoneNumber.title".localized
        static let phoneNumberInfo = "authentication.phoneNumber.info".localized
        static let phoneNumberDescription = "authentication.phoneNumber.description".localized
        static let phoneNumberTwoFactorAuthTitle = "authentication.phoneNumber.twoFactorAuthentication.title".localized
        static let phoneNumberTwoFactorAuthDescription = "authentication.phoneNumber.twoFactorAuthentication.description".localized
        
        static let countryTitle = "authentication.country.title".localized
        static let countryDescription = "authentication.country.description".localized
        static let countryPickerEmptyStateTitle = "authentication.countryPicker.emptyState.title".localized
        static let countryPickerEmptyStateDescription = "authentication.countryPicker.emptyState.description".localized
        static let verifyPhoneNumberTitle = "authentication.verifyPhoneNumber.title".localized
        static let verifyPhoneNumberTwoFactorAuthTitle = "authentication.verifyPhoneNumber.twoFactorAuthentication.title".localized
        static let verifyPhoneNumberMainTitle = "authentication.verifyPhoneNumber.mainTitle"
        static let verifyPhoneNumberDescription = "authentication.verifyPhoneNumber.description"
        static let verifyPhoneNumberResendCode = "authentication.verifyPhoneNumber.resendCode".localized
        static let firsName = "authentication.firstName".localized
        static let lastName = "authentication.lastName".localized
        static let userName = "authentication.userName".localized
        static let createAccountTitle = "authentication.createAccount.title".localized
        static let userCredentialsTitle = "authentication.userCredentials.title".localized
        static let signInToYourAccount = "authentication.signInToYourAccount".localized
        static let forgotPassword = "authentication.forgotPassword".localized
        static let resetAccount = "authentication.resetAccount".localized
        static let signIn = "authentication.signIn".localized
        static let signUp = "authentication.signUp".localized
        static let signOut = "authentication.signOut".localized
        static let dontHaveAnAccount = "authentication.dontHaveAnAccount".localized
        static let alreadyHaveAnAccount = "authentication.alreadyHaveAnAccount".localized
        static let goToLogin = "authentication.goToLogin".localized
        static let createAccount = "authentication.createAccount".localized
        static let confirmPassword = "authentication.confirmPassword".localized
        static let currentPassword = "authentication.currentPassword".localized
        static let newPassword = "authentication.newPassword".localized
        static let retypeNewPassword = "authentication.retypeNewPassword".localized
        static let resetPassword = "authentication.resetPassword".localized
        static let repeatPassword = "authentication.repeatPassword".localized
        static let updatePassword = "authentication.updatePassword".localized
        static let createYourAccount = "authentication.createYourAccount".localized
        static let backToSignIn = "authentication.backToSignIn".localized
        static let termsAndConditions = "authentication.termsAndConditions".localized
        static let terms = "authentication.terms".localized
        static let privacyPolicy = "authentication.privacyPolicy".localized
        static let intergiroTermsAndConditions = "authentication.intergiro.termsAndConditions".localized
        static let intergiroTerms = "authentication.intergiro.terms".localized
        static let intergiroPrivacyPolicy = "authentication.intergiro.privacyPolicy".localized
        static let forgotPasswordTilte = "authentication.forgotPassword.title".localized
        static let forgotPasswordDescription = "authentication.forgotPassword.description".localized
        static let forgotPasswordEmailDescription = "authentication.forgotPassword.emailDescription".localized
        static let forgotPasswordAlertMessage = "authentication.forgotPassword.alert.message".localized
        static let confirmNewPassword = "authentication.resetPassword.confirmNewPassword".localized
        static let passwordHasBeenChanged = "authentication.resetPassword.passwordHasBeenChanged".localized
        static let resetPasswordTitle = "authentication.resetPassword.resetPasswordTitle".localized
        static let resetPasswordDescription = "authentication.resetPassword.resetPasswordDescription".localized
        static let accountCreationSuccessMessage = "authentication.accountCreation.success.message".localized
        static let userActivationAlertMessage = "authentication.userActivation.alert.message".localized
        
        static let signUpSecurely = "authentication.country.signUpSecurely".localized
        static let countryPrivacy = "authentication.country.privacy".localized
        static let countryPrivacyHere = "authentication.country.privacy.here".localized
        
        static let birthDateTitle = "authentication.birthDate.title".localized
        static let birthDateDescription = "authentication.birthDate.description".localized
        static let birthDatePlaceholder = "authentication.birthDate.placeholder".localized
        static let resetPasswordSuccessMessage = "authentication.resetPassword.successMessage".localized
        static let resetPasswordFailMessage = "authentication.resetPassword.failMessage".localized
        static let registrationCompletionTitle = "authentication.registrationCompletion.title".localized
        static let registrationCompletionDescription = "authentication.registrationCompletion.description".localized
        static let tfaPasswordTitle = "authentication.twaPassword.title".localized
        static let tfaPasswordDescription = "authentication.twaPassword.description".localized
        static let recoveryEmailTitle = "authentication.emailRecovery.title".localized
        static let recoveryEmailResendCodeTitle = "authentication.emailRecovery.resendCodeTitle".localized
        static let cantAccessEmailTilte = "authentication.emailRecovery.cantAccessEmailTilte".localized
        
        static func recoveryEmailDescription(email: String) -> String {
            return "authentication.emailRecovery.description".localized(with: [email])
        }
    }
}

// MultiActionedInfo
public extension Constants.Localization {
    enum MultiActionedInfo {
    }
}

public extension Constants.Localization.MultiActionedInfo {
    enum NotificationAccess {
        static let title = "multiActionedInfo.notification.title".localized
        static let description = "multiActionedInfo.notification.description".localized
        static let enableNotificationsTilte = "multiActionedInfo.notification.enableNotificationsButton.title".localized
        static let maybeLaterTitle = "multiActionedInfo.notification.maybeLaterButton.title".localized
    }
}

public extension Constants.Localization.MultiActionedInfo {
    enum AddCard {
        static let title = "multiActionedInfo.addCard.title".localized
        static let description = "multiActionedInfo.addCard.description".localized
        static let attachCardButtonTitle = "multiActionedInfo.addCard.attachCardButton.title".localized
        static let skipToPlatformButtonTitle = "multiActionedInfo.addCard.skipToPlatformButton.title".localized
    }
}


public extension Constants.Localization.MultiActionedInfo {
    enum AddCardCompletion {
        static let title = "multiActionedInfo.addCardCompletion.title".localized
        static let topDescription = "multiActionedInfo.addCardCompletion.topDescription".localized
        static let bottomDescription = "multiActionedInfo.addCardCompletion.bottomDescription".localized
    }
}

// AddCard
public extension Constants.Localization {
    enum AddCard {
        static let screenTitle = "addCard.screenTitle".localized
        static let screenDescription = "addCard.screenDescription".localized
        static let nameOnCardTitle = "addCard.title.nameOnCard".localized
        static let cardNumberTitle = "addCard.title.cardNumber".localized
        static let cardExpirationDateTitle = "addCard.title.cardExpirationDate".localized
        static let cardCVVTitle = "addCard.title.cardCVV".localized

        static let nameOnCardPlaceholder = "addCard.placeholder.nameOnCard".localized
        static let cardNumberPlaceholder = "addCard.placeholder.cardNumber".localized
        static let cardExpirationDatePlaceholder = "addCard.placeholder.cardExpirationDate".localized
        static let cardCVVPlaceholder = "addCard.placeholder.cardCVV".localized
        static let addAnotherCard = "addCard.addAnotherCard.button.title".localized
    }
}

// Tab Bar
public extension Constants.Localization {
    enum TabBar {
        static let home = "tabbar.home.title".localized
        static let fiat = "tabbar.fiat.title".localized
        static let crypto = "tabbar.crypto.title".localized
        static let me = "tabbar.me.title".localized
    }
}

// Channels

public extension Constants.Localization {
    enum Channels {
        public static let title = "channels.title".localized
        public static let createChannel = "channels.createChannel".localized
        public static let emptyStateTitle = "channels.emptyState.title".localized
        public static let emptyStateDescription = "channels.emptyState.description".localized
        public static let inviteFriendsTitle = "channels.emptyState.inviteFriendsTitle".localized
        public static let syncContacts = "channels.emptyState.syncContacts.title".localized
        public static let inviteFriends = "channels.emptyState.inviteFriends.title".localized
        public static let publicChannel = "channels.publicChannel".localized
        public static let createNewChannel = "channels.createNewChannel".localized
        public static let directMessage = "channels.directMessage".localized
        public static let groupChannel = "channels.groupChannel".localized
        public static let newDM = "channels.newDM".localized
        public static let newGroup = "channels.newGroup".localized
        public static let searchPlaceholder = "channels.searchPlaceholder".localized
        public static let channelName = "channels.channelName".localized
        public static let newGroupTitle = "channels.newGroup.title".localized
        public static let securityDescription = "channels.chat.securityDescription".localized
        public static let chatDescription = "channels.chat.chatDescription".localized
        public static let messagePlaceholder = "channels.chat.messagePlaceholder".localized
        public static let cashPlaceholder = "channels.payment.cash.placeholder".localized
        public static let cryptoPlaceholder = "channels.payment.crypto.placeholder".localized
        public static let notesPlaceholder = "channels.payment.notes.placeholder".localized
        public static let requestFrom = "channels.payment.requestFrom".localized
        public static let everyoneInGroup = "channels.payment.everyoneInGroup".localized
        public static let requestDetails = "channels.reqeustDetails.title".localized
        public static let paymentDetails = "channels.paymentDetails.title".localized
        public static let closeRequest = "channels.requestDetails.closeRequest".localized
        public static let noPayment = "channels.reqeustDetails.noPayment".localized
        public static let sendReminder = "channels.reqeustDetails.sendReminder".localized
        public static let closedRequest = "channels.requestDetails.closedRequest".localized
        public static let friends = "channels.requestDetails.friends".localized
        public static let goToSettings = "channels.inviteFriends.contactAccess.goToSettings".localized
        public static let emptyLastMessageDescription = "channels.emptyLastMessage.description".localized
        public static let selectedUsers = "channels.selectedUsers".localized
        public static let pickerEmptyStateTitle = "channels.pickerEmptyStateTitle".localized
        public static let sendOrReqeust = "channels.sendOrReqeust".localized
        public static let groupName = "channels.groupName".localized
        public static let groupPhoto = "channels.groupPhoto".localized
        public static let topUpTitle = "channels.topUpTilte".localized
        public static let unknownUser = "channels.unknownUser".localized
        
        public static func receivedFrom(reciever: String, sender: String) -> String {
            return "channels.chat.payment.receivedFrom".localized(with: [reciever, sender])
        }
        
        public static func rejectedRequest(who: String, whose: String) -> String {
            return "channels.chat.payment.rejectedRequest".localized(with: [who, whose])
        }
        
        public static func sentARequest(sender: String) -> String {
            return "channels.chat.payment.sentARequest".localized(with: [sender])
        }
        
        public static func paymentFrom(sender: String) -> String {
            return "channels.chat.payment.paymentFrom".localized(with: [sender])
        }
        
        public static func channelItemPaid(amountInfo: String) -> String {
            return "channels.channelItem.payment.paid".localized(with: [amountInfo])
        }
        
        public static func channelItemRequested(amountInfo: String) -> String {
            return "channels.channelItem.payment.requested".localized(with: [amountInfo])
        }
        
        public static func channelItemRejected(sender: String) -> String {
            return "channels.channelItem.payment.rejected".localized(with: [sender])
        }
    }
}

// FiatAccount

public extension Constants.Localization {
    enum FiatAccount {
        static let emptyStateErrorTitle = "fiatAccount.emptyState.error.title".localized
        static let emptyStateErrorDescription = "fiatAccount.emptyState.error.description".localized
        static let emptyStateNotSupportedCountryTitle = "fiatAccount.emptyState.notSupportedCountry.title".localized
        static let emptyStateNotSupportedCountryDescription = "fiatAccount.emptyState.notSupportedCountry.description".localized
        static let emptyStateEmptyCardsTitle = "fiatAccount.emptyState.emptyCards.title".localized
        static let emptyStateEmptyCardsDescription = "fiatAccount.emptyState.emptyCards.description".localized
        static let emptyStateEmptyTransactionsTitle = "fiatAccount.emptyState.emptyTransactions.title".localized
        static let title = "fiatAccount.title".localized
        static let expiresOn = "fiatAccount.expiresOn".localized
        static let beneficiary = "fiatAccount.beneficiary".localized
        static let IBAN = "fiatAccount.IBAN".localized
        static let BIC = "fiatAccount.BIC".localized
        static let euro = "fiatAccount.euro".localized
        static let addCard = "fiatAccount.addCard".localized
        static let details = "fiatAccount.details".localized
        static let seeMore = "fiatAccount.seeMore".localized
        static let hideDetails = "fiatAccount.hideDetails".localized
        static let showDetails = "fiatAccount.showDetails".localized
        static let resetPin = "fiatAccount.resetPin".localized
        static let unfreeze = "fiatAccount.unfreeze".localized
        static let cardSettings = "fiatAccount.cardSettings".localized
        static let freeze = "fiatAccount.freeze".localized
        static let block = "fiatAccount.block".localized
        static let stole = "fiatAccount.stole".localized
        static let lost = "fiatAccount.lost".localized
        static let activate = "fiatAccount.activate".localized
        static let reportIssue = "fiatAccount.reportIssue".localized
        static let physicalCardTitle = "fiatAccount.newCard.physicalCard.title".localized
        static let virtualCardTitle = "fiatAccount.newCard.virtualCard.title".localized
        static let physical = "fiatAccount.physical".localized
        static let virtual = "fiatAccount.virtual".localized
        static let physicalCardDescription = "fiatAccount.newCard.physicalCard.description".localized
        static let deactivateStateDescription = "fiatAccount.newCard.physicalCard.deactivateStateDescription".localized
        static let virtualCardDescription = "fiatAccount.newCard.virtualCard.description".localized
        static let cardInfo = "fiatAccount.newCard.cardInfo".localized
        static let deliveryAddressTitle = "fiatAccount.deliveryAddress.title".localized
        static let selectCountry = "fiatAccount.deliveryAddress.selectCountry".localized
        static let streetPlaceholder = "fiatAccount.deliveryAddress.streetPlaceholder".localized
        static let cityPlaceholder = "fiatAccount.deliveryAddress.cityPlaceholder".localized
        static let regionPlaceholder = "fiatAccount.deliveryAddress.regionPlaceholder".localized
        static let postalCodePlaceholder = "fiatAccount.deliveryAddress.postalCodePlaceholder".localized
        static let city = "fiatAccount.deliveryAddress.city".localized
        static let region = "fiatAccount.deliveryAddress.region".localized
        static let postalCode = "fiatAccount.deliveryAddress.postalCode".localized
        static let emptyCardsTitle = "fiatAccount.emptyCards.title".localized
        static let outdatedAccountInfoTitle = "fiatAccount.outdatedAccountInfo.title".localized
        static let outdatedTransactionsTitle = "fiatAccount.outdatedTransactions.title".localized
        static let externalTransferTitle = "fiatAccount.externalTransfer.title".localized
        static let receiverName = "fiatAccount.externalTransfer.receiverName".localized
        static let externalTransferAmount = "fiatAccount.externalTransfer.amount".localized
        static let requestAmount = "fiatAccount.requestAmount".localized
        static let externalTransferAmountPlaceholder = "fiatAccount.externalTransfer.amountPlaceholder".localized
        static let physicalCardAdditinalFee = "fiatAccount.physicalCard.additinalFee".localized
        static let paymentRequired = "fiatAccount.physicalCard.paymentRequired".localized
        static let freezeCardAlertMessage = "fiatAccount.freezeCard.alertMessage".localized
        static let lastTransactions = "fiatAccount.cards.lastTransactions".localized
        static let addFunds = "fiatAccount.addFunds".localized
        static let topUpAmount = "fiatAccount.topUpAmount".localized
        static let topUp = "fiatAccount.topUp".localized
        static let actionBlocked = "fiatAccount.cards.actionBlocked".localized
        static let pendingCardDescription = "fiatAccount.cards.pendingCardDescription".localized
        static let intergiroTermsAndConditions = "fiatAccount.intergiro.termsAndConditions".localized
        
        static let cardFrozenSuccess = "fiatAccount.cardStatus.frozen.success".localized
        static let cardFrozenFailed = "fiatAccount.cardStatus.frozen.failed".localized
        
        static let cardBlockedSuccess = "fiatAccount.cardStatus.blocked.success".localized
        static let cardBlockedFailed = "fiatAccount.cardStatus.blocked.failed".localized

        static let cardStolenSuccess = "fiatAccount.cardStatus.stolen.success".localized
        static let cardStolenFailed = "fiatAccount.cardStatus.stolen.failed".localized

        static let cardLostSuccess = "fiatAccount.cardStatus.lost.success".localized
        static let cardLostFailed = "fiatAccount.cardStatus.lost.failed".localized

        static func street(_ index: Int) -> String { return "fiatAccount.deliveryAddress.street".localized(with: [index]) }
    }
}

// Pay Or Request

extension Constants.Localization {
    enum PayOrRequest {
        static let emptyStateDescription = "payOrRequest.emptyStateView.description".localized
        static let unavailableBalanceTitle = "payOrRequest.unavailableBalance.title".localized
        static let unavailableBalanceDescription = "payOrRequest.unavailableBalance.description".localized
        static let exploreCrypto = "payOrRequest.exploreCryptoButton.title".localized
        static let requestFrom = "payOrRequest.requestInfo.requestFrom".localized
    }
}

extension Constants.Localization {
    enum AcceptPaymentValidation {
        static let validationFailed = "validationMessage.acceptPayemnt.validationFailed".localized
        static let insufficientFunds = "validationMessage.acceptPayemnt.insufficientFunds".localized
        static let requestAmountInvalidRange = "validationMessage.acceptPayemnt.requestAmountInvalidRange".localized
        static let paymentAmountFiatInvalidRange = "validationMessage.acceptPayemnt.paymentAmountFiatInvalidRange".localized
        static let paymentAmountGreaterThanMax = "validationMessage.acceptPayemnt.paymentAmountGreaterThanMax".localized
        static let insufficientFundsForMinValue = "validationMessage.acceptPayemnt.insufficientFundsForMinValue".localized
        
        static func useMinimumAmount(_ amount: Double) -> String { return "validationMessage.acceptPayemnt.useMinimumAmount".localized(with: [amount.bringToPresentableFormat()]) }

        static func participantsMinAmount(participantsCount: Int, minValue: Double) -> String { return "validationMessage.acceptPayemnt.participantsMinAmount".localized(with: [participantsCount, minValue]) }
    }
}


// CryptoAccount

extension Constants.Localization {
    enum CryptoAccount {
        static let title = "cryptoAccount.title".localized
        static let yourCryptoBalance = "cryptoAccount.yourCryptoBalance".localized
        static let totalReturn = "cryptoAccount.totalReturn".localized
        static let topCryptos = "cryptoAccount.topCryptos".localized
        static let exploreMoreCrypto = "cryptoAccount.exploreMoreCrypto".localized
        static let emptyStateDescription = "cryptoAccount.emptyState.description".localized
        static let goToMarket = "cryptoAccount.goToMarket".localized
        static let market = "cryptoAccount.market".localized
        static let past24Hours = "cryptoAccount.past24Hours".localized
        static let your = "cryptoAccount.your".localized
        static let euroValue = "cryptoAccount.euroValue".localized
        static let searchPlaceholder = "cryptoAccount.search.placeholder".localized
        static let depositAddress = "cryptoAccount.depositAddress".localized
        static let minAmount = "cryptoAccount.minAmount".localized
        static let maxAmount = "cryptoAccount.maxAmount".localized
        static let totalReturnInfo = "cryptoAccount.totalReturnInfo".localized
        static let availableAmount = "cryptoAccount.availableAmount".localized
        static let convertingRangeTitle = "cryptoAccount.convertingRange.title".localized
        static let externalTransfer = "cryptoAccount.externalTransfer".localized
        static let userCryptoBalance = "cryptoAccount.userCryptoBalance".localized
        static let userCashBalance = "cryptoAccount.userCashBalance".localized
        static let withdrawAddressEmptyStateTitle = "cryptoAccount.withdrawAddress.emptyStateTitle".localized
        static let amountToSend = "cryptoAccount.withdrawAddress.amountToSend".localized
        static let externalWalletAddress = "cryptoAccount.withdrawAddress.externalWalletAddress".localized
        static let externalWalletAddressName = "cryptoAccount.withdrawAddress.externalWalletAddressName".localized
        static let youCanSend = "cryptoAccount.withdrawAddress.youCanSend".localized
        static let started = "cryptoAccount.withdrawAddress.started".localized
        static let upTo = "cryptoAccount.withdrawAddress.upTo".localized
        static let additionalFee = "cryptoAccount.withdrawAddress.additionalFee".localized
        static let memo = "cryptoAccount.withdrawAddress.memo".localized
        static let provideMemo = "cryptoAccount.withdrawAddress.memo.provideMemo".localized
        static let invalidMemo = "cryptoAccount.withdrawAddress.memo.invalidMemo".localized
        static let invalidMemoMessage = "cryptoAccount.withdrawAddress.memo.invalidMemoMessage".localized
        
        static let convertedAmount = "cryptoAccount.convertedAmount".localized
        static let cryptoExchangeSuccessMessage = "cryptoAccount.cryptoExchange.successMessage".localized
        static let cryptoExchangeFailMessage = "cryptoAccount.cryptoExchange.failMessage".localized
        static let invalidAmount = "cryptoAccount.buyOrSell.invalidAmount".localized
        static let invalidRange = "cryptoAccount.buyOrSell.invalidRange".localized
        static let moreThanCurrentBalance = "cryptoAccount.buyOrSell.moreThanCurrentBalance".localized
        static let cryptoRanges = "cryptoAccount.buyOrSell.cryptoRanges".localized
        static let emptyStateTitle = "cryptoAccount.emptyStateTitle".localized
        static let saveAddress = "cryptoAccount.withdraw.address.saveAddress".localized
        static let provideAddressName = "cryptoAccount.withdraw.address.provideAddressName".localized
        static let invalidAddressName = "cryptoAccount.withdraw.address.invalidAddressName".localized
        
        static let chooseNetwork = "cryptoAccount.chooseNetwork".localized
        static let chooseNetworkInfo = "cryptoAccount.chooseNetwork.info".localized
        static let chooseNetworkWithdrawInfo = "cryptoAccount.chooseNetwork.withdrawInfo".localized
        
        static func depositAddressInfo(coin: String) -> String { return "cryptoAccount.depositAddress.info".localized(with: [coin]) }
    }
}

// Validation
extension Constants.Localization {
    enum ValidationMessage {
        static let invalidCredential = "validationMessage.invalidCredential".localized
        static let emptyText = "validationMessage.emptyText".localized
        static let invalidTextLenght = "validationMessage.invalidTextLenght".localized
        static let emptyFirstName = "validationMessage.emptyFirstName".localized
        static let emptyLastName = "validationMessage.emptyLastName".localized
        static let emptyUserName = "validationMessage.emptyUserName".localized
        static let invalidUsername = "validationMessage.invalidUsername".localized
        static let invalidName = "validationMessage.invalidName".localized
        static let userNameCharectersLenght = "validationMessage.charectersLenght".localized
        static let userNamesLenght = "validationMessage.userNamesLenght".localized
        static let emptyEmail = "validationMessage.emptyEmail".localized
        static let invalidEmail = "validationMessage.invalidEmail".localized
        static let emptyPhoneNumber = "validationMessage.emptyPhoneNumbaer".localized
        static let invalidPhoneNumber = "validationMessage.invalidPhoneNumber".localized
        static let emptyPassword = "validationMessage.emptyPassword".localized
        static let invalidPassword = "validationMessage.invalidPassword".localized
        static let invalidPasswordLenght = "validationMessage.invalidPasswordLenght".localized
        static let mainPasswordIsEmpty = "validationMessage.mainPasswordIsEmpty".localized
        static let passwordsAreDifferent = "validationMessage.passwordsAreDifferent".localized
        static let requiredField = "validationMessage.requiredField".localized
        static let emptyCardHolderName = "validationMessage.emptyCardHolderName".localized
        static let invalidCardHolderName = "validationMessage.invalidCardHolderName".localized
        static let emptyCardNumber = "validationMessage.emptyCardNumber".localized
        static let invalidCardNumber = "validationMessage.invalidCardNumber".localized
        static let emptyCardExpirationDate = "validationMessage.emptyCardExpirationDate".localized
        static let invalidCardExpirationDate = "validationMessage.invalidCardExpirationDate".localized
        static let emptyCVV = "validationMessage.emptyCVV".localized
        
        static let birthDateInvalidDate = "validationMessage.birthDate.invalidDate".localized
        static let birthDateNotAnAdult = "validationMessage.birthDate.notAnAdult".localized

        static let invalidWithdrawAddress = "validationMessage.withdrawAddress.invalidAddress".localized
        
        static let externalTransferInvalidAmount = "validationMessage.externalTransfer.invalidAmount".localized
        static let invalidIntergiroAmount = "validationMessage.externalTransfer.invalidIntergiroAmount".localized
        static let externalTransferReceiverNameLenght = "validationMessage.externalTransfer.receiverName.lenght".localized
        static let externalTransferReceiverNameInvalidSymbols = "validationMessage.externalTransfer.receiverName.invalidSymbols".localized
        
        static func externalTransferInvalidMinAmount(_ amount: String) -> String { return "validationMessage.externalTransfer.invalidAmount.min".localized(with: [amount]) }
        static func externalTransferInvalidMaxAmount(_ amount: String) -> String { return "validationMessage.externalTransfer.invalidAmount.max".localized(with: [amount]) }
        
        static func requiredFieldRange(minLenght: Int, maxLenght: Int) -> String {
            return "validationMessage.requiredField.range".localized(with: [minLenght, maxLenght])
        }
    }
}

// Error
extension Constants.Localization {
    enum GenericError {
        static let title = "error.generic.title".localized
        static let message = "error.generic.message".localized
    }
    
    enum NetworkError {
        static let title = "error.network.title".localized
        static let unacceptableStatusCode = "error.network.message.unacceptableStatusCode".localized
        static let internalServerError = "error.network.message.internalServerError".localized
        static let authorizationExpired = "error.network.message.authorizationExpired".localized
        static let errorParsingFailed = "error.network.message.errorParsingFailed".localized
        static let invalidResponse = "error.network.message.invalidResponse".localized
        static let olderAppVersion = "error.network.message.olderAppVersion".localized
        static let unknown = "error.network.message.unknown".localized
    }
    
    enum ParsingError {
        static let title = "error.parsing.title".localized
        static let message = "error.parsing.message".localized
    }
    
    enum BiometricError {
        static let title = "error.biometric.title".localized
        static let permissionFailMessage = "error.biometric.permission.evaluation.fail.message".localized
        static let authenticationFail = "error.biometric.authentication.failed".localized
        static let authenticationCanceled = "error.biometric.authentication.canceled".localized
    }
}

extension Constants.Localization {
    enum ScreenEmptyState {
        static let `default` = "screen.empty.state.default".localized
        static let events = "screen.empty.state.events".localized
        static let tickets = "screen.empty.state.tickets".localized
        static let notifications = "screen.empty.state.notifications".localized
    }
}

extension Constants.Localization {
    enum SystemService {
        static let cameraTitle = "system.services.camera.title".localized
        static let cameraDescription = "system.services.camera.description".localized
        static let actionTitle = "system.services.action.title".localized
        static let internetDescription = "system.services.internet.description".localized
        static let contactAccessTitle = "channels.inviteFriends.contactAccess.title".localized
        static let contactAccessDescription = "channels.inviteFriends.contactAccess.description".localized
    }
}

// Profile
public extension Constants.Localization {
    enum Profile {
        public static let title = "profile.title".localized
        public static let accountAndSettings = "profile.accountAndSettings".localized
        public static let transactionsHistory = "profile.main.transactionsHistory".localized
        public static let myCard = "profile.main.myCard".localized
        public static let myAccount = "profile.main.myAccount".localized
        public static let myFriends = "profile.main.myFriends".localized
        public static let settings = "profile.main.settings".localized
        public static let biometricAuthenticationReason = "profile.security.biometricAuthentication.reason".localized
        public static let biometricAuthenticationDescription = "profile.security.biometricAuthentication.description".localized

        public static let editProfile = "profile.editProfile.title".localized
        public static let transactions = "profile.transactionsHistory.transactions".localized
        public static let account = "profile.settings.account".localized
        public static let contactInfo = "profile.settings.contactInfo".localized
        public static let aboutUs = "profile.settings.aboutUs".localized
        public static let contactUs = "profile.settings.contactUs".localized
        public static let passwordAndSecurity = "profile.settings.passwordAndSecurity".localized
        public static let personalInformation = "profile.settings.personalInformation".localized
        public static let personalInformationTitle = "profile.settings.personalInformationTitle".localized
        public static let deleteAccountMessage = "profile.passwordAndSecurity.deleteAccount.message".localized
        public static let deleteAccount = "profile.passwordAndSecurity.deleteAccount".localized
        public static let privacyPolicy = "profile.settings.privacyPolicy".localized
        public static let termsAndConditions = "profile.settings.termsAndConditions".localized
        public static let changePassword = "profile.passwordAndSecurity.changePassword".localized
        public static let twoFactorAuthentication = "profile.passwordAndSecurity.twoFactorAuthentication".localized
        public static let textMessage = "profile.twoFactorAuthentication.textMessage".localized
        public static let authenticationApp = "profile.twoFactorAuthentication.authenticationApp".localized
        public static let authenticationAppTitle = "profile.authenticationApp.title".localized
        public static let authenticationAppDescription = "profile.authenticationApp.description".localized
        public static let setupOnThisDevice = "profile.authenticationApp.setupOnThisDevice".localized
        public static let activationCodeDescription = "profile.authenticationApp.activationCodeDescription".localized
        public static let cardNamePlaceholder = "profile.newCard.cardNamePlaceholder".localized
        public static let createCard = "profile.newCard.createCard".localized
        public static let copyPhoneNumber = "profile.menuAction.copyPhoneNumber".localized
        public static let copyUsername = "profile.menuAction.copyUsername".localized
        public static let copyEmail = "profile.menuAction.copyEmail".localized
        public static let changePasswordSuccessMessage = "profile.changePassword.successMessage".localized
        public static let changePasswordFailMessage = "profile.changePassword.failMessage".localized
        public static let theSamePassword = "profile.changePassword.oldPassword.placeholder".localized
        public static let oldPassword = "profile.changePassword.oldPassword.placeholder".localized
        public static let newPassword = "profile.changePassword.newPassword.placeholder".localized
        public static let repeatNewPassword = "profile.changePassword.repeatNewPassword.placeholder".localized
        public static let accountDeactivationSuccess = "profile.accountDeactivation.success".localized
        public static let accountDeactivationFailed = "profile.accountDeactivation.failed".localized
        public static let verifyEmailSuccessMessage = "profile.verifyEmail.successMessage".localized
        public static let verifyEmailFailMessage = "profile.verifyEmailToken.successMessage".localized
        public static let verifyEmailTokenSuccess = "profile.verifyEmailToken.successMessage".localized
        public static let verifyEmailTokenFail = "profile.verifyEmailToken.failMessage".localized
        public static let emailSubject = "profile.shareQR.emailSubject".localized
        public static let emailBody = "profile.shareQR.emailBody".localized
        public static let inviteFriendsEmptyScreenTitle = "profile.inviteFriends.emptyScreen.title".localized
    }
}

extension Constants.Localization {
    enum LocalNotification {
        static let newMessageTitle = "localNotification.newMessage.title".localized
        static let newChannelTitle = "localNotification.newChannel.title".localized
        static let newChannelSubTitle = "localNotification.newChannel.subTitle".localized
    }
}
