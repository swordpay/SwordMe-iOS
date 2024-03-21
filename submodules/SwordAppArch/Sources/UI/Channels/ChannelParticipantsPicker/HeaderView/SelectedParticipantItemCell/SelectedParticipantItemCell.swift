//
//  SelectedParticipantItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.23.
//

import UIKit
import AvatarNode

private let avatarFont = avatarPlaceholderFont(size: 10.0)

final class SelectedParticipantItemCell: SetupableCollectionCell {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backgroundHolderView: UIView!
    @IBOutlet private weak var imageHolderView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    
    // MARK: - Peropertis
    
    private var model: SelectedParticipantItemCellModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
     
        updateUI(isSelected: false)
    }

    // MARK: - Setup UI
    
    func setup(with model: SelectedParticipantItemCellModel) {
        self.model = model
        
        titleLabel.text = model.participant.enginePeer.indexName.stringRepresentation(lastNameFirst: false, separator: " ")
        
        setupBackgroundView()
        setupProfileImageView()
    }
    
    private func setupBackgroundView() {
        backgroundHolderView.setCornerRadius(backgroundHolderView.frame.height / 2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapHandler))
        
        backgroundHolderView.isUserInteractionEnabled = true
        backgroundHolderView.addGestureRecognizer(tapGesture)
    }
    
    private func setupProfileImageView() {
        let avatarNode: AvatarNode = AvatarNode(font: avatarFont)
        let height = imageHolderView.frame.height

        avatarNode.setPeer(context: model.participant.context,
                           account: model.participant.account,
                           theme: model.participant.theme,
                           peer: model.participant.enginePeer,
                           displayDimensions: .init(width: height,
                                                    height: height))

        avatarNode.updateSize(size: .init(width: height,
                                          height: height))

        avatarNode.view.translatesAutoresizingMaskIntoConstraints = false
        imageHolderView.addSubview(avatarNode.view)
        
        avatarNode.view.addBorderConstraints(constraintSides: .all)
        imageHolderView.setCornerRadius(imageHolderView.frame.height / 2)
    }
        
    private func updateUI(isSelected: Bool) {
        backgroundHolderView.backgroundColor = isSelected ? theme.colors.gradientDarkBlue : theme.colors.lightGray3
        titleLabel.textColor = isSelected ? theme.colors.mainWhite : theme.colors.textColor
        imageHolderView.isHidden = isSelected
        deleteButton.isHidden = !isSelected
    }

    // MARK: - Actions
    
    @objc
    private func backgroundViewTapHandler() {
        model.isSelected.toggle()
        
        updateUI(isSelected: model.isSelected)
    }
    
    @IBAction private func deleteButtonTouchUp(_ sender: UIButton) {
        model.deleteUserButtonPublisher.send(())
    }
}
