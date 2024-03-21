//
//  ChannelPaymentParticipantsView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import UIKit
import Combine
import AvatarNode

private let avatarFont = avatarPlaceholderFont(size: 16.0)

final class ChannelPaymentParticipantsView: SetupableView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainHolderView: UIStackView!
    @IBOutlet private weak var membersImagesHolderView: UIStackView!
    @IBOutlet private weak var moreButton: UIButton!
    
    // MARK: - Properties
    
    private var model: ChannelPaymentParticipantsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelPaymentParticipantsViewModel) {
        self.model = model
        
        bindToParticipants()
    }
    
    private func setupTitle(participants: [ChannelsHeaderViewModel.Info]) {
        
        var firstThreeUsers = participants.prefix(3).map { $0.enginePeer.indexName.stringRepresentation(lastNameFirst: false, separator: " ") }.joined(separator: ", ")
        
        let remainingUsersCount = participants.count - 3
        
        if remainingUsersCount > 0 {
            let suffix = remainingUsersCount == 1 ? "" : "s"
            firstThreeUsers.append(" and \(remainingUsersCount) more participant\(suffix)")
        }

        titleLabel.text = firstThreeUsers
    }

    private func setupImages(participants: [ChannelsHeaderViewModel.Info]) {
        let members = participants.prefix(3)
        let nodes = members.map {
            let avatarNode: AvatarNode = AvatarNode(font: avatarFont)
                        
            avatarNode.setPeer(context: $0.context,
                               account: $0.account,
                               theme: $0.theme,
                               peer: $0.enginePeer,
                               displayDimensions: .init(width: 52,
                                                        height: 52))

            avatarNode.updateSize(size: .init(width: 52,
                                              height: 52))

            return avatarNode
        }
        
        nodes.enumerated().forEach({ item in
            item.element.view.translatesAutoresizingMaskIntoConstraints = false

            membersImagesHolderView.subviews[item.offset].addSubview(item.element.view)
            
            item.element.view.addBorderConstraints(constraintSides: .all)
        })
        
        membersImagesHolderView.subviews.enumerated().forEach { $0.element.isHidden = $0.offset >= members.count }
    }
    
    // MARK: - Binding
    
    private func bindToParticipants() {
        model.participants
            .receive(on: RunLoop.main)
            .sink { [ weak self ] participants in
                guard let self else { return }
                
                self.mainHolderView.spacing = participants.count > 3 ? -10 : 10
                self.moreButton.isHidden = participants.count <= 3

                self.setupImages(participants: participants)
                self.setupTitle(participants: participants)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func moreUserButtonTouchUp(_ sender: UIButton) {
        model.moreButtonTapHandler.send(())
    }
    
}
