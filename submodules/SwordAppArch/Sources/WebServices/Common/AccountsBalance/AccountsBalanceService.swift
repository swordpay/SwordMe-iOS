//
//  AccountsBalanceService.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.03.23.
//

import Combine
import Swinject
import Foundation

public protocol AccountsBalanceServicing {
    func fetch(route: AccountsBalanceParams) -> AnyPublisher<SingleItemBaseResponse<AccountsBalanceResponse>, Error>
}

public final class AccountsBalanceWebService: Service, AccountsBalanceServicing {
    public func fetch(route: AccountsBalanceParams) -> AnyPublisher<SingleItemBaseResponse<AccountsBalanceResponse>, Error> {
        return call(route: route)
    }
}

public final class AccountsBalanceMockService: Service, AccountsBalanceServicing {
    public func fetch(route: AccountsBalanceParams) -> AnyPublisher<SingleItemBaseResponse<AccountsBalanceResponse>, Error> {
        return call(route: route)
    }
}

public final class AccountsBalanceServiceAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(AccountsBalanceServicing.self) { _ in
            if AppEnvironment.current == .mock {
                return AccountsBalanceMockService(dataFetchManager: DataFetchManagerProvider.mock)
            } else {
                return AccountsBalanceWebService(dataFetchManager: DataFetchManagerProvider.web)
            }
        }
    }
}
