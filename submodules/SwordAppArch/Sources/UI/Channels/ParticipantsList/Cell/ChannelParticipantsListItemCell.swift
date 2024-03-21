//
//  ChannelParticipantsListItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import UIKit
import AvatarNode

private let avatarFont = avatarPlaceholderFont(size: 15.0)

final class ChannelParticipantsListItemCell: SetupableTableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var avatarHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: ChannelParticipantsListItemCellModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelParticipantsListItemCellModel) {
        self.model = model
        
        let userName: String? = {
            guard case let .user(telegramUser) = model.user.enginePeer else {
                return nil
            }
            
            return telegramUser.username
        }()

        self.nameLabel.text = model.user.enginePeer.indexName.stringRepresentation(lastNameFirst: false, separator: " ")
        self.userNameLabel.text = userName
        
        setupUserImage()
    }
    
    private func setupUserImage() {
        let avatarNode: AvatarNode = AvatarNode(font: avatarFont)
        let height = avatarHolderView.frame.height
        
        avatarNode.setPeer(context: model.user.context,
                           account: model.user.account,
                           theme: model.user.theme,
                           peer: model.user.enginePeer,
                           displayDimensions: .init(width: height,
                                                    height: height))

        avatarNode.updateSize(size: .init(width: height,
                                          height: height))

        avatarNode.view.translatesAutoresizingMaskIntoConstraints = false
        avatarHolderView.addSubview(avatarNode.view)
        
        avatarNode.view.addBorderConstraints(constraintSides: .all)
    }
}
