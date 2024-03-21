//
//  ChannelsHeaderItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Kingfisher
import AvatarNode

private let avatarFont = avatarPlaceholderFont(size: 16.0)

final class ChannelsHeaderItemCell: SetupableCollectionCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageNodeHolderView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var presenceIndicatorView: UIView!
    @IBOutlet private weak var presenceIndicatorBackgroundView: UIView!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    private let avatarNode: AvatarNode = AvatarNode(font: avatarFont)

    // MARK: - Peropertis
    
    private var model: ChannelsHeaderItemCellModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelsHeaderItemCellModel) {
        self.model = model
        
        imageViewHeightConstraint.constant = ComponentSizeProvider.recentRoomsItemHeight.size
//        setupProfileImageView()
        presenceIndicatorView.backgroundColor = model.channelItem.peerPresenceState == .online ? theme.colors.mainGreen : theme.colors.mainYellow
        presenceIndicatorView.setCornerRadius(6.5)
        presenceIndicatorBackgroundView.setCornerRadius(9)
        
        setupImageNode()
    }
    
    private func setupImageNode() {
        avatarNode.view.translatesAutoresizingMaskIntoConstraints = false
        
        imageNodeHolderView.addSubview(avatarNode.view)
        
        avatarNode.view.addBorderConstraints(constraintSides: .all)
        avatarNode.setPeer(context: model.channelItem.context,
                           account: model.channelItem.account,
                           theme: model.channelItem.theme,
                           peer: model.channelItem.enginePeer,
                           displayDimensions: .init(width: ComponentSizeProvider.recentRoomsItemHeight.size,
                                                    height: ComponentSizeProvider.recentRoomsItemHeight.size))
        
        avatarNode.updateSize(size: .init(width: ComponentSizeProvider.recentRoomsItemHeight.size,
                                          height: ComponentSizeProvider.recentRoomsItemHeight.size))
    }
    
//    private func setupProfileImageView() {
//        let placeholderImage = UIImage(imageName: Constants.AssetName.Channels.channelIconPlaceholder)
//        guard let flagUrl = model.channelImageURL else {
//            imageView.image = placeholderImage
//
//            return
//        }
//
//        let size = ComponentSizeProvider.recentRoomsItemHeight.size * 2
//        let processor = ResizingImageProcessor(referenceSize: CGSize(width: size, height: size))
//
//        imageView.isHidden = false
//        imageView.setCornerRadius(ComponentSizeProvider.recentRoomsItemHeight.size / 2)
//        imageView.contentMode = .scaleAspectFit
//        imageView.kf.setImage(with: flagUrl, placeholder: placeholderImage, options: [.processor(processor)])
//    }
}
