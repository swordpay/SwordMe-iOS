//
//  ChannelItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 20.12.22.
//

import UIKit
import Combine
import Kingfisher

final class ChannelItemCell: SetupableTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var channelImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    @IBOutlet private weak var lastMessageDateLabel: UILabel!
    
    @IBOutlet private weak var channelImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    private var model: ChannelItemCellModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellables = []
    }
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelItemCellModel) {
        self.model = model
        
        separatorHeightConstraint.constant = 0.5
        channelImageViewHeightConstraint.constant = ComponentSizeProvider.channelItemImageHeight.size
        nameLabel.text = model.channel.value.presentableName
        lastMessageDateLabel.text = model.formattedDate
        
        setupLabelsUI()
        setupLabelNumberOfLines()
        setupChannelImageView()
        setupLastMessageLabel()
        setupChannelImageView()
        
        bindToChannelInfoUpdate()
    }
    
    private func setupLabelsUI() {
        nameLabel.font = theme.fonts.font(style: .channelItem, family: .poppins, weight: .semibold)
        senderLabel.font = theme.fonts.font(style: .channelItem, family: .poppins, weight: .regular)
        lastMessageLabel.font = theme.fonts.font(style: .channelItem, family: .poppins, weight: .regular)
        lastMessageDateLabel.font = theme.fonts.font(style: .channelItemLastMessageDate, family: .poppins, weight: .regular)
    }
    
    private func setupLastMessageLabel() {
        lastMessageLabel.text = model.lastMessage ?? Constants.Localization.Channels.emptyLastMessageDescription
    }
    
    private func setupSenderLabel() {
        guard let sender = model.lastMessageSender else {
            senderLabel.isHidden = true
            
            return
        }
        
        senderLabel.isHidden = !model.channel.value.isGroupChat
        senderLabel.text = sender
    }
    
    private func setupLabelNumberOfLines() {
        let isGroupChat = model.channel.value.isGroupChat
        nameLabel.numberOfLines = isGroupChat ? 1 : 2
        senderLabel.numberOfLines = 1
        lastMessageLabel.numberOfLines = isGroupChat ? 1 : 2
    }

    private func setupChannelImageView() {
        let placeholderImage = UIImage(imageName: Constants.AssetName.Channels.channelIconPlaceholder)

        guard let channelImageURL = model.channelImageURL else {
            channelImageView.image = placeholderImage

            return
        }
        let scale = UIScreen.main.scale
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: scale * 60, height: scale * 60))

        channelImageView.isHidden = false
        channelImageView.setCornerRadius(channelImageView.frame.height / 2)
        channelImageView.kf.setImage(with: channelImageURL,
                                     placeholder: placeholderImage,
                                     options: [.processor(processor)])
        channelImageView.contentMode = .scaleAspectFit
    }

    // MARK: - Binding

    private func bindToChannelInfoUpdate() {
        model.channel
            .sink { [ weak self ] _ in
                self?.setupLastMessageLabel()
                self?.setupSenderLabel()
            }
            .store(in: &cancellables)
    }
}
