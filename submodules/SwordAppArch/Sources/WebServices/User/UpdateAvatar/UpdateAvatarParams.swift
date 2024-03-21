//
//  UpdateAvatarParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.04.23.
//

import UIKit

struct UpdateAvatarParams: Routing {
    let avatarData: Data
    
    let boundary = "Boundary-\(UUID().uuidString)"

    var key: APIRepresentable {
        return Constants.UserAPI.avatar
    }
    
    var httpMethod: URLRequestMethod {
        return .put
    }

    var request: URLRequest {
        let url = baseURL.appendingPathComponent(key.path)
        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue
        request.httpBody = prepareRequestBody()

        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        return request
    }
    
    var headers: [String : String] {
        return ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": "Bearer \(AppData.accessToken ?? "")",
                "x-version-name": UIApplication.shared.appVersion,
                "x-os": "ios"]
    }

    private func prepareRequestBody() -> Data? {
        var mutableData = Data()
        let mimeType = "image/jpg"

        mutableData.append("--\(boundary)\r\n".data(using: .utf8)!)
        mutableData.append("Content-Disposition: form-data; name=\"avatar\"\r\n\r\n".data(using: .utf8)!)
        mutableData.append("jpg\r\n".data(using: .utf8)!)

        mutableData.append("--\(boundary)\r\n".data(using: .utf8)!)
        mutableData.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
        mutableData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        mutableData.append(avatarData)
        mutableData.append("\r\n".data(using: .utf8)!)

        mutableData.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return mutableData
    }
}
