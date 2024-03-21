//
//  DataFetchValidator.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.06.22.

import Combine
import Swinject
import Foundation

public final class DataFetchValidator: DataFetchValidating {
    public func validate(result: DataFetchResult) -> AnyPublisher<Data, Error> {
        guard let httpResponse = result.response as? HTTPURLResponse else {
            return Fail(error:  DataFetchingError.internalServerError(Constants.Localization.NetworkError.invalidResponse))
                .eraseToAnyPublisher()
        }

        guard !result.route.acceptableStatusCodes.contains(httpResponse.statusCode) else {
            return Just(result.data).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        guard !result.route.isBinanceReqeust else {
            return Fail(error: DataFetchingError.binanceError).eraseToAnyPublisher()
        }

        do {
            let errorModel = try parseErrorModel(from: result.data)

            let errorType: DataFetchingError

            switch httpResponse.statusCode {
            case 401:
                errorType = .authorizationExpired
            case 406:
                errorType = .olderAppVersion
            case 421:
                errorType = .needExtraLogin
            case 422:
                errorType = .multipleErrors(errorModel.errors ?? [])
            case 424:
                errorType = .appAccessBlocked(errorModel.message ?? "App access has been blocked")
            default:
                errorType = .internalServerError(errorModel.message)
            }

            return Fail(error: errorType).eraseToAnyPublisher()
        } catch {
            return Fail(error: DataFetchingError.errorParsingFailed)
                .eraseToAnyPublisher()
        }
    }

    private func parseErrorModel(from data: Data) throws -> NetworkingErrorModel {
        let jsonDecoder = JSONDecoder()
        let errorModel = try jsonDecoder.decode(NetworkingErrorModel.self, from: data)

        return errorModel
    }
}

final class DataFetchValidatorAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(DataFetchValidating.self) { _ in
            return DataFetchValidator()
        }
    }
}
