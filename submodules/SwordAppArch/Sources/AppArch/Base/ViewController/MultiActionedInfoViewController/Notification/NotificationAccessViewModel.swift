//
//  NotificationAccessViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.01.23.
//

import Combine
import Foundation

final class NotificationAccessViewModel: MultiActionedInfoViewModel<Void> {
    let maybeLaterHandler: PassthroughSubject<Void, Never> = PassthroughSubject()

    override var title: String {
        return Constants.Localization.MultiActionedInfo.NotificationAccess.title
    }
    
    override var stackSetupModel: MultiActionedInfoStackViewModel.SetupModel {
        return .init(mainIconName: Constants.AssetName.MultiActionedInfo.mainIconNotification,
                     topDescription: nil,
                     bottomDescription: Constants.Localization.MultiActionedInfo.NotificationAccess.description,
                     bottomDescriptionFontSize: 16,
                     primaryButtonTitle: Constants.Localization.MultiActionedInfo.NotificationAccess.enableNotificationsTilte,
                     secondaryButtonTitle: Constants.Localization.MultiActionedInfo.NotificationAccess.maybeLaterTitle)
    }
        
    // MARK: - Binding
    
    override func setupBindings() {
        bindToPrimaryButtonAction()
        bindToSecondaryButtonAction()
    }

    private func bindToPrimaryButtonAction() {
        setupModel.value?.primaryButtonActionHandler
            .sink {
                NotificationManagerProvider.native.registerForPushNotifications()
            }
            .store(in: &cancellables)
    }
    
    private func bindToSecondaryButtonAction() {
        setupModel.value?.secondaryButtonActionHandler
            .sink { [ weak self ] in
                self?.maybeLaterHandler.send(())
            }
            .store(in: &cancellables)
    }
}
