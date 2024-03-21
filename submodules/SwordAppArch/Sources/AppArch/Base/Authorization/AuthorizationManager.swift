//
//  AuthorizationManager.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 22.08.23.
//

import UIKit
import Combine
import PresentationDataUtils

public final class AuthorizationManager: LogoutManagable {
    private let getUserWebService = GetUserMockService(dataFetchManager: DataFetchManagerProvider.mock)
    private var cancellables: Set<AnyCancellable> = []
    private var authenticationCancellable: AnyCancellable?

    public var isLoading: CurrentValueSubject<Bool, Never> = .init(false)
    var timeInterval: Int32?
    
    private var meRequestsCount = 0
    public static let global: AuthorizationManager = {
        struct SingletonWrapper {
            static let singleton = AuthorizationManager()
        }

        return SingletonWrapper.singleton
    }()
    
    private init() {
        
    }
    
    public func getUserData(withLoading: Bool = false) {
        guard meRequestsCount < 3 else {
            DispatchQueue.main.async {
                self.showMeRequestFailingAlert()
                self.isLoading.send(false)
            }

            return
        }
        
        let route = GetUserParams()
        
        if withLoading {
            self.isLoading.send(true)
        }

        getUserWebService.fetch(route: route)
            .receive(on: RunLoop.main)
            .sink { [ weak self ] completion in
                guard let self else { return }
                if case let .failure(error) = completion {
                    if let dataFetchingError = error as? DataFetchingError {
                        if withLoading {
                            self.isLoading.send(false)
                        }

                        if case let .appAccessBlocked(message) = dataFetchingError {
                            self.showInactiveUserAlert(message: message)
                        
                            return
                        } else if case .olderAppVersion = dataFetchingError {
                            self.showAppUpdateAlert()
                            
                            return
                        } else if case .refreshingFailed = dataFetchingError {
                            if withLoading {
                                self.isLoading.send(false)
                            }

                            return
                        }
                    }
                    
                    if withLoading {
                        self.isLoading.send(false)
                    }

                    self.meRequestsCount += 1
                    DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                        self.getUserData(withLoading: self.meRequestsCount == 1)
                    }
                    print("failed to fetch user info \(error.localizedDescription)")
                }
            } receiveValue: { [ weak self ] response in
                self?.meRequestsCount = 0
                if withLoading {
                    self?.isLoading.send(false)
                }

                AppData.currentUserInfo = response.data.user
                CryptoCacher.global.prepareCryptosInfo()
            }
            .store(in: &cancellables)
    }

    private func showMeRequestFailingAlert() {
        let alert = UIAlertController(title: "Something went wrong. Please check your internet connection", message: nil, preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
    }

    private func showInactiveUserAlert(message: String) {
        let alert = UIAlertController(title: "Account blocked!", message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok", style: .default) { [ weak self ] _ in
            self?.logout()
        })
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
    }

    private func showAppUpdateAlert() {
        let alert = UIAlertController(title: Constants.Localization.NetworkError.olderAppVersion, message: nil, preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok", style: .default) { [ weak self ] _ in
            if UIApplication.shared.canOpenURL(Constants.AppURL.appStoreURL) {
                self?.logout()
                UIApplication.shared.open(Constants.AppURL.appStoreURL)
            }
        })
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
    }

    private func bindToAuthenticationCodePublisher() {
//        authenticationCancellable = NotificationCenter.default.publisher(for: .authenticationCodeDidReceived)
//            .receive(on: RunLoop.main)
//            .sink { [ weak self ] notification in
//                guard let self,
//                      self.isCheckingVerification,
//                      let timeInterval,
//                      let userInfo = notification.userInfo,
//                      let code = userInfo["code"] as? String,
//                      let codeTimeInterval = userInfo["date"] as? Int32, codeTimeInterval > timeInterval else {
//                    return
//                }
//
//                self.isCheckingVerification = false
//                self.verifyTFACode(code)
//            }
    }

    private func resetCancellables() {
        cancellables = []
    }
}
