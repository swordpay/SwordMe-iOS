//
//  BaseViewModel.swift
//  sword-ios
//
//  Created by Scylla IOS on 20.05.22.
//

import UIKit
import Combine

open class BaseViewModel<Inputs>: NSObject, ViewModeling, LogoutManagable {
    public var cancellables: Set<AnyCancellable> = []
    public var error: PassthroughSubject<Error?, Never> = PassthroughSubject()

    public var isLoading: CurrentValueSubject<Bool?, Never> = CurrentValueSubject(nil)
    public var isEmptyState: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    public var inputs: Inputs

    public var shouldBindToAuthorizationManagerLoading: Bool {
        return false
    }

    public init(inputs: Inputs) {
        self.inputs = inputs
        
        super.init()
        
        bindToAuthorizationManagerLoading()
    }
    
    public func errorViewModel(for error: Error) -> ErrorViewModel {
        if let networkginError = error as? DataFetchingError {
            return networkErrorViewModel(networkginError)
        }

        if let parseError = error as? DataParsingError {
            return parseErrorViewModel(parseError)
        }
        
        if let biometricError = error as? BiometricAuthenticationError {
            return prepareErrorViewModelForBiometricError(biometricError)
        }

        return ErrorViewModel(title: Constants.Localization.GenericError.title,
                              message: Constants.Localization.GenericError.message,
                              action: {})
    }

    private func networkErrorViewModel(_ error: DataFetchingError) -> ErrorViewModel {
        if case let .appAccessBlocked(message) = error {
            return ErrorViewModel(title: "Account blocked!",
                                  message: message,
                                  action: { [ weak self ] in
                self?.logout()
            })
        }
        if case .authorizationExpired = error {
            return ErrorViewModel(title: Constants.Localization.NetworkError.title,
                                  message: Constants.Localization.NetworkError.authorizationExpired,
                                  action: { [ weak self ] in
                self?.logout()
            })
        }
        
        if case .olderAppVersion = error {
            return ErrorViewModel(title: Constants.Localization.NetworkError.olderAppVersion, message: nil) { [ weak self ] in
                if UIApplication.shared.canOpenURL(Constants.AppURL.appStoreURL) {
                    self?.logout()
                    UIApplication.shared.open(Constants.AppURL.appStoreURL)
                    AppData.appVersion = UIApplication.shared.appVersion
                }
            }
        }

        if case .needExtraLogin = error {
            return ErrorViewModel(title: "Session Expired", message: "Your session has been expired. \nPlease enter code which you get in telegram account to refresh session") {
            }
        }
        
        let errorMessage: String
        
        switch error {
        case .internalServerError(let message):
            #if PROD
            errorMessage = message ?? "Error message is missing"
            #else
            errorMessage = message?.localized ?? Constants.Localization.NetworkError.internalServerError
            #endif
        case .authorizationExpired:
            errorMessage = Constants.Localization.NetworkError.authorizationExpired
        case .errorParsingFailed:
            errorMessage = Constants.Localization.NetworkError.errorParsingFailed
        case .unacceptableStatusCode(_, _):
            errorMessage = Constants.Localization.NetworkError.unacceptableStatusCode
        case .multipleErrors(let infos):
            errorMessage = infos.map { $0.message.localized }.joined(separator: "\n")
        case .missingJSON(let jsonName):
            errorMessage = "Json file with name \(jsonName) is missing"
        case .inaccessibleData(_, _):
            errorMessage = "Can`t read data from json file"
        case .internalError(let message):
            errorMessage = "Internal error has been occurred. \n\(message)"
        case .binanceError:
            errorMessage = "Binance services are temporarily unavailable"
        default:
            errorMessage = Constants.Localization.NetworkError.unknown
        }
        
        return ErrorViewModel(title: errorMessage,
                              message: nil,
                              action: {})
    }
    
    private func parseErrorViewModel(_ error: DataParsingError) -> ErrorViewModel {
        return ErrorViewModel(title: Constants.Localization.ParsingError.message,
                              message: nil,
                              action: {})
    }
    
    func prepareErrorViewModelForBiometricError(_ error: BiometricAuthenticationError) -> ErrorViewModel {
        switch error {
        case .evaluationFail:
            return ErrorViewModel(title: Constants.Localization.BiometricError.title,
                                  message: Constants.Localization.BiometricError.permissionFailMessage,
                                  action: {})
        case .authenticationFailed(let isCanceled):
            let messagee = isCanceled ? Constants.Localization.BiometricError.authenticationCanceled
                                      : Constants.Localization.BiometricError.authenticationFail
            let action = isCanceled ? {}
                                    : { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }

            return ErrorViewModel(title: Constants.Localization.BiometricError.title,
                                  message: messagee,
                                  action: action)
        }
    }
    
    private func bindToAuthorizationManagerLoading() {
        guard shouldBindToAuthorizationManagerLoading else { return }
        
        AuthorizationManager.global.isLoading
            .sink { [ weak self ] isLoading in
                self?.isLoading.send(isLoading)
            }
            .store(in: &cancellables)
    }
}
