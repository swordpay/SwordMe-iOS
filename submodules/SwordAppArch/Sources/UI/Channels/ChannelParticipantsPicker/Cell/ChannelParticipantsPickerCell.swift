//
//  ChannelParticipantsPickerCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.12.22.
//

import UIKit
import Combine
import AvatarNode

private let avatarFont = avatarPlaceholderFont(size: 14.0)

final class ChannelParticipantsPickerCell: SetupableTableViewCell {
 
    // MARK: - IBOutlets
    
    @IBOutlet private weak var participantPhotoHolderView: UIView!
    @IBOutlet private weak var participantNameLabel: UILabel!
    @IBOutlet private weak var participantUsernameLabel: UILabel!
    @IBOutlet private weak var selectedCheckmarkImageView: UIImageView!
    
    // MARK: - Properties
    
    private var model: ChannelParticipantsPickerCellModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellables = []
    }

    // MARK: - Setup UI
    
    func setup(with model: ChannelParticipantsPickerCellModel) {
        self.model = model
        
        selectedCheckmarkImageView.setCornerRadius(selectedCheckmarkImageView.frame.height / 2)
        participantNameLabel.text = model.participent.enginePeer.indexName.stringRepresentation(lastNameFirst: false, separator: " ")
        let userName: String? = {
            guard case let .user(telegramUser) = model.participent.enginePeer else {
                return nil
            }
            
            return telegramUser.username
        }()
        
        if let userName {
            participantUsernameLabel.text = "@\(userName)"
            participantUsernameLabel.isHidden = false
        } else {
            participantUsernameLabel.isHidden = true
        }

        setupParticipantImageView()

        bindToSelection()
    }
    
    private func setupParticipantImageView() {
        
        let avatarNode: AvatarNode = AvatarNode(font: avatarFont)
        let height = participantPhotoHolderView.frame.height
        
        avatarNode.setPeer(context: model.participent.context,
                           account: model.participent.account,
                           theme: model.participent.theme,
                           peer: model.participent.enginePeer,
                           displayDimensions: .init(width: height,
                                                    height: height))

        avatarNode.updateSize(size: .init(width: height,
                                          height: height))

        avatarNode.view.translatesAutoresizingMaskIntoConstraints = false
        participantPhotoHolderView.addSubview(avatarNode.view)
        
        avatarNode.view.addBorderConstraints(constraintSides: .all)
    }
    
    private func updateUI(isSelected: Bool) {
        updateLabelsUI(isSelected: isSelected)
        updateImage(isSelected: isSelected)
    }
    
    private func updateLabelsUI(isSelected: Bool) {
//        participantNameLabel.textColor = isSelected ? theme.colors.textBlue : theme.colors.textColor
//        participantUsernameLabel.textColor = isSelected ? theme.colors.textBlue : theme.colors.mainGray4
    }
    
    private func updateImage(isSelected: Bool) {
        let imageName = isSelected ? "checkmark.circle.fill" : "circle"
        let tintColor = isSelected ? theme.colors.gradientDarkBlue : theme.colors.lightGray4
        
        selectedCheckmarkImageView.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        selectedCheckmarkImageView.tintColor = tintColor
    }

    // MARK: - Binding
    
    private func bindToSelection() {
        model.isSelected
            .sink { [ weak self ] isSelected in
                guard let self else { return }

                self.updateUI(isSelected: isSelected)
            }
            .store(in: &cancellables)
    }
}
