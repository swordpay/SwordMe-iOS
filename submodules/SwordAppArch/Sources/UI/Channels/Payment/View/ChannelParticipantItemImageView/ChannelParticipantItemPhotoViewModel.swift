//
//  ChannelParticipantItemPhotoViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import Combine
import Foundation
import Kingfisher

final class ChannelParticipantItemPhotoViewModel {
    private var cancellables: Set<AnyCancellable> = []
    private var avatarURL: URL? {
        guard let avatar = member.avatar,
              let iconURL = URL(string: avatar) else { return nil }

        return iconURL
    }

    let member: ChannelUserModel
    
    let memberPhotoDataPublisher: CurrentValueSubject<Data?, Never> = CurrentValueSubject(nil)

    lazy var textPlaceholderedImageViewSetupModel: TextPlaceholderedImageViewModel = {
        return .init(imageData: nil,
                     title: member.fullName,
                     fontSize: 20,
                     cornerRadius: 30)
    }()

    init(member: ChannelUserModel) {
        self.member = member
    }
    
    func prepareMemberPhotoData() {
        
        guard let avatarURL else {
            textPlaceholderedImageViewSetupModel.imageData.send(nil)
            
            return
        }

        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))

        KingfisherManager.shared.retrieveImage(with: avatarURL, options: [.processor(processor),
                                                                                .fromMemoryCacheOrRefresh]) { [ weak self ] result in
            switch result {
            case .success(let value):
                self?.textPlaceholderedImageViewSetupModel.imageData.send(value.data())
            case .failure(let error):
                self?.textPlaceholderedImageViewSetupModel.imageData.send(nil)
                print("Sender avatar fetching failed: \(error)")
            }
        }
    }
}
