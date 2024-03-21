//
//  DataFetchManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.04.22.
//

import UIKit
import Combine

public final class DataFetchManager: DataFetchManaging, LogoutManagable {
    private var refreshingFetcher: AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error>?
    private var refreshingManager: AuthManager?
    private var refreshTokenService: RefreshAccessTokenWebService?

    public var fetcher: DataFetching
    public var validator: DataFetchValidating
    public var parser: DataParsing

    public init(fetcher: DataFetching, validator: DataFetchValidating, parser: DataParsing) {
        self.fetcher = fetcher
        self.validator = validator
        self.parser = parser
    }

    public func fetch<T>(route: Routing) -> AnyPublisher<T, Error> where T: Decodable {
        self.refreshTokenService = nil
        self.refreshingManager = nil
        self.refreshingFetcher = nil

        return fetcher.fetch(from: route)
                    .flatMap(validator.validate(result:))
                    .tryCatch({ [ weak self ] error in
                        guard let self else {
                            throw DataFetchingError.internalError(error.localizedDescription)
                        }
                        
                        guard route.isAppActive else {
                            throw DataFetchingError.backgroundRequestError
                        }

                        guard route.key.path != Constants.AuthenticationAPI.refreshAccessToken.path else {
                            DispatchQueue.main.async {
                                self.showSessionExpiredAlert()
                            }
                            
                            throw DataFetchingError.refreshingFailed
                        }
                        
                        guard let authError = error as? DataFetchingError,
                              case .authorizationExpired = authError else {
                            throw error
                        }

                        let service = RefreshAccessTokenWebService(dataFetchManager: DataFetchManagerProvider.web)
                        let refreshingManager = AuthManager(refreshAccessTokenService: service)
                        let refreshingFetcher = refreshingManager.refreshToken()
                        
                        self.refreshTokenService = service
                        self.refreshingManager = refreshingManager
                        self.refreshingFetcher = refreshingFetcher

                        return refreshingFetcher
                            .flatMap { response in
                                print("Access token refreshed")
                                AppData.accessToken = response.data.accessToken

                                return self.fetcher.fetch(from: route)
                                    .flatMap(self.validator.validate(result:))
                            }
                    })
                    .flatMap(parser.parse)
                    .eraseToAnyPublisher()
    }
    
    public func fetchWithEmptyResult(route: Routing) -> AnyPublisher<Void, Error> {
        return fetcher.fetch(from: route)
                    .flatMap(validator.validate(result:))
                    .map({ _ in return () })
                    .eraseToAnyPublisher()
    }
    
    private func showSessionExpiredAlert() {
        if let topController = UIApplication.shared.topMostViewController() as? UIAlertController,
           topController.title == "Your session has been expired!" {
            return
        }
        
        let alert = UIAlertController(title: "Your session has been expired!", message: nil, preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok", style: .default) { [ weak self ] _ in
            self?.logout()
        })
        
        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
    }
    
    deinit {
        print("DataFetchManager deinited \(self)")
    }
}

public final class AuthManager {
    public var pendingRequest: AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error>?
    public var refreshAccessTokenService: RefreshAccessTokenServicing

    public init(refreshAccessTokenService: RefreshAccessTokenServicing) {
        self.refreshAccessTokenService = refreshAccessTokenService
    }

    public func refreshToken() -> AnyPublisher<SingleItemBaseResponse<RefreshAccessTokenResponse>, Error> {
        if let pendingRequest {
            return pendingRequest
        }
        
        let request = refreshAccessTokenService.fetch(route: .init())
                        .eraseToAnyPublisher()

        pendingRequest = request

        return request
    }
}
