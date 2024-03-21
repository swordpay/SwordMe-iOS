//
//  HomeHeaderViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Combine
import Foundation
import SwordAppArch

final class HomeHeaderViewModel {
    var recentsSetupModel: ChannelsHeaderViewModel
    let searchBarTapHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    let scanQRTapHandler: PassthroughSubject<Void, Never> = PassthroughSubject()
    let selectedTabIndex: PassthroughSubject<Int, Never> = PassthroughSubject()
    let externalSelectedTabIndex: PassthroughSubject<Int, Never> = PassthroughSubject()
    var isInternetQualtyLow: PassthroughSubject<Bool, Never> = PassthroughSubject()
    var networkState: PassthroughSubject<NetworkState, Never> = PassthroughSubject()
    
    var internetQualityViewModel: InternetQualityViewModel = .init()
    var isFeedSelected = true
    
    public init(recentsSetupModel: ChannelsHeaderViewModel) {
        self.recentsSetupModel = recentsSetupModel
    }
}
