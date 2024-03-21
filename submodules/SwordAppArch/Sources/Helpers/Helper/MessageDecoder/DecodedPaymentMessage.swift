//
//  DecodedPaymentMessage.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 25.08.23.
//

import Foundation

public class DecodableMessage: Codable {
    var amount: String
    var currency: String
    
    public var peerId: Int?
    public var extraPeerId: Int?

    init(amount: String, currency: String, peerId: Int?, extraPeerId: Int?) {
        self.amount = amount
        self.currency = currency
        self.peerId = peerId
        self.extraPeerId = extraPeerId
    }
}

public final class DecodedPaymentMessage: DecodableMessage {
    public let paymentType: PaymentActionType
    public let users: [String]
    public let note: String?
    public let url: String

    public init?(text: String) {
        var components = text.split(separator: "\n")
                             .map( { String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
        
        guard !components.isEmpty else { return nil }
        let url = components.removeLast()
        self.url = url
        
        var amountAndCurrency: (String, String)? {
            let amountComponent = components.filter({ $0.contains("🪙") || $0.contains("💸") }).first
            
            guard let amountComponent else { return nil }
            var amountAndCurrency = amountComponent.split(separator: " ")
            
            amountAndCurrency.removeFirst()
            
            guard amountAndCurrency.count == 2 else { return nil }
            
            return (String(amountAndCurrency[0]), String(amountAndCurrency[1]))
        }
        
        var users: [String] {
            guard let users = components.filter({ $0.contains("👥")}).first else { return [] }
            
            var splitedUsers = users.split(separator: " ")
            splitedUsers.removeFirst()
            
            return splitedUsers.map { String($0) }
        }

        var note: String? {
            guard let result = components.filter({ $0.contains("🗒") }).first else { return nil }
            
            let emojiesSet: [String] = ["🪙", "💸", "👥", "🗒"]

            var note = result.split(separator: " ")
            note.removeFirst()
            
            let noteCandidate = note.joined(separator: " ")
            
            var mutableComponents = components.filter { element in !emojiesSet.contains(String(element.first!)) }
            
            if mutableComponents.count >= 2 {
                mutableComponents.removeFirst()
                mutableComponents.insert(noteCandidate, at: 0)
                return mutableComponents.joined(separator: "\n")
            } else {
                return noteCandidate
            }
        }

        guard let paymentInfo = components.compactMap({ PaymentActionType(rawValue: $0) }).first else { return nil }
        guard let amountAndCurrency else { return nil }
        
        var peerInfo: (Int, Int)? {
            guard let paymentURL = URL(string: url),
                  let components = URLComponents(url: paymentURL, resolvingAgainstBaseURL: true),
                  let stringedId = components.queryItems?.first(where: { $0.name == "peer_id" })?.value as? String,
                  let stringedExtraPeerId = components.queryItems?.first(where: { $0.name == "extra_peer_id" })?.value as? String else { return nil }
            
            guard let peerId = Int(stringedId), let extraPeerId = Int(stringedExtraPeerId) else { return nil }
            
            return (peerId, extraPeerId)
        }

        self.paymentType = paymentInfo
        self.users = users
        self.note = note
        
        super.init(amount: amountAndCurrency.0,
                   currency: amountAndCurrency.1,
                   peerId: peerInfo?.0,
                   extraPeerId: peerInfo?.1)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

public enum PaymentActionType: String, Codable {
    case send = "New Payment!"
    case request = "New Request!"
    case accept = "Payment Accepted!"
    case reject = "Payment Rejected!"
}
