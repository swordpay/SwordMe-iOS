//
//  CreateGroupChannelParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import UIKit

struct CreateGroupChannelParams: CreateChannelRouting {
    let channelName: String
    let membersIds: [String]
    let channelImageData: Data?
    
    let boundary = "Boundary-\(UUID().uuidString)"

    var key: APIRepresentable {
        return Constants.ChannelsAPI.createGroupChannel
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
                "x-os": "ios"
        ]
    }

    var acceptableStatusCodes: Set<Int> {
        return [ 201 ]
    }
    
    private func prepareRequestBody() -> Data? {        
        var channelInfo: [String: Any] = [
            "channelName": channelName
        ]
        
        membersIds.enumerated().forEach {
            let key = "members[\($0.offset)]"
            channelInfo[key] = $0.element
        }

        var mutableData = Data()
        let mimeType = "image/jpg"

        for (key, value) in channelInfo {
            mutableData.append("--\(boundary)\r\n".data(using: .utf8)!)
            mutableData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            mutableData.append("\(value)\r\n".data(using: .utf8)!)
        }
            
        if let channelImageData {
            mutableData.append("--\(boundary)\r\n".data(using: .utf8)!)
            mutableData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            mutableData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            mutableData.append(channelImageData)
            mutableData.append("\r\n".data(using: .utf8)!)
        }

        mutableData.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return mutableData
    }
}
