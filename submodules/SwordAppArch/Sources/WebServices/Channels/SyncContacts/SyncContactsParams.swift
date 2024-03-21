//
//  SyncContactsParams.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import Foundation

struct SyncContactsParams: Routing {
    let contactsPhoneNumbers: [String]

    var key: APIRepresentable {
        return Constants.ChannelsAPI.syncContacts
    }
    
    var params: [String : Any] {
        return ["phoneNumbers": contactsPhoneNumbers]
    }
}
