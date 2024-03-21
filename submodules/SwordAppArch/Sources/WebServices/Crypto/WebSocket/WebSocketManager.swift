//
//  WebSocketManager.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 13.03.23.
//

import Combine
import Starscream
import Foundation

final class WebSocketManager {
    static let global: WebSocketManager = {
        struct SingletonWrapper {
            static let singleton = WebSocketManager()
        }
        return SingletonWrapper.singleton
    }()
    
    private init() {
        
    }
    
    lazy var socket: WebSocket = {
        var request = URLRequest(url: URL(string: "wss://stream.binance.com:9443/stream")!)
        request.timeoutInterval = 5
        let socket = WebSocket(request: request)
        socket.delegate = self
        
        return socket
    }()

    var isConnected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var didSocketDisconected: PassthroughSubject<UInt16, Never> = PassthroughSubject()
    private(set) var subscribers: [WebSocketStream: PassthroughSubject<Any, Never>] = [:]
    
    func connect() {
        guard !isConnected.value else { return }

        socket.connect()
    }
    
    func disconect() {
        guard isConnected.value else { return }

        socket.disconnect()
    }
    
    func addSubscriber(_ subscriber: PassthroughSubject<Any, Never>, for stream: WebSocketStream) {
        subscribers[stream] = subscriber
    }
    
    func removeSubscriber(of stream: WebSocketStream) {
        subscribers[stream] = nil
    }

    func sendData(_ model: [String: Any], completion: ((Bool) -> ())? = nil) {
        let data = try? JSONSerialization.data(withJSONObject: model)
        
        guard let data else {
            completion?(false)

            return
        }
        
        socket.write(stringData: data) {
            completion?(true)
        }
    }

    func sendData() {
        let dict: [String: Any] = [ "method": "SUBSCRIBE",
                                    "params": [
                                        "bnbbtc@aggTrade",
                                    ],
                                    "id": 5]
        let data = try? JSONSerialization.data(withJSONObject: dict)
        
        guard let data else { return }
        
        print("Data sent")
        socket.write(stringData: data, completion: nil)
    }
    
    func sendCandleStick() {
        let dict: [String: Any] = [ "method": "SUBSCRIBE",
                                    "params": [
                                        "ethbusd@miniTicker"
                                    ]]
        let data = try? JSONSerialization.data(withJSONObject: dict)
        
        guard let data else { return }
        
        print("Data sent")
        socket.write(stringData: data, completion: nil)
    }
}

extension WebSocketManager: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            isConnected.send(true)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected.send(false)
            print("websocket is disconnected: \(reason) with code: \(code)")
            
            didSocketDisconected.send(code)
        case .text(let string):
            if let data = string.data(using: .utf8) {
                do {
                    let info = try JSONDecoder().decode(WebSocketBaseModel.self, from: data)
                    handleRecievedInfo(info)
                } catch {
//                    print("error is ---- \(error)")
                }
            }

//            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .cancelled:
            isConnected.send(false)
        case .reconnectSuggested(let isSuggested):
            if isSuggested {
                socket.connect()
            }
        case .error(let error):
            if let error {
                print("Web Socket Error Event Occurred \(error.localizedDescription)")
            }

            isConnected.send(false)
        default:
            return
        }
    }
        
    func handleRecievedInfo(_ info: WebSocketBaseModel) {
        subscribers[info.stream]?.send(info.data)
    }
}

struct WebSocketBaseModel: Decodable {
    let stream: WebSocketStream
    let data: Any
    
    enum CodingKeys: String, CodingKey {
        case stream
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let streamValue = try container.decode(String.self, forKey: .stream)
        
        guard let streamTypeValue = streamValue.components(separatedBy: "@").last,
              let stream = WebSocketStream(value: streamTypeValue) else {
            throw WebSocketError.parseError(message: "Failed to convert stream type")
        }
        
        self.stream = stream
        
        switch stream {
        case .miniTicker:
            self.data = try container.decode(MiniTickerSocketResponse.self, forKey: .data)
        case .trade:
            self.data = try container.decode(TradeSocketResponse.self, forKey: .data)
        case .kline:
            self.data = try container.decode(KLineSocketResponse.self, forKey: .data)
        }
    }
}

enum WebSocketError: Error {
    case parseError(message: String)
}

enum WebSocketStream: String, Codable, Hashable {
    case trade = "aggTrade"
    case miniTicker = "ticker"
    case kline = "kline"
    
    init?(value: String) {
        if let correctCase = WebSocketStream(rawValue: value) {
            self = correctCase
        } else if value.contains("kline") {
            self = .kline
        } else {
            return nil
        }
    }
}

struct TradeSocketResponse: Decodable {
    let price: String
    let symbols: String
    
    enum CodingKeys: String, CodingKey {
        case price = "p"
        case symbols = "s"
    }
}

struct MiniTickerSocketResponse: Decodable {
    let symbol: String
    let openPrice: String
    let closePrice: String
    let lowPrice: String
    let highPrice: String
    let priceChange: String
    let priceChangePercent: String

    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case openPrice = "o"
        case closePrice = "c"
        case lowPrice = "l"
        case highPrice = "h"
        case priceChange = "p"
        case priceChangePercent = "P"
    }
}

struct KLineSocketResponse: Decodable {
    let symbol: String
    let data: Model
    
    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case data = "k"
    }
}

extension KLineSocketResponse {
    struct Model: Decodable {
        let interval: String
        let startTime: Double
        let price: String
        
        enum CodingKeys: String, CodingKey {
            case interval = "i"
            case startTime = "t"
            case price = "c"
        }
    }
}
