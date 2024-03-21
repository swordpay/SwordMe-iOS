//
//  ChannelParticipantItemPhotoView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import UIKit

final class ChannelParticipantItemPhotoView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageHodlerView: UIView!
    
    // MARK: - Properties
    
    private var model: ChannelParticipantItemPhotoViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelParticipantItemPhotoViewModel) {
        self.model = model
        
        setupMemberPhotoImageView()
        model.prepareMemberPhotoData()
        
        imageHodlerView.layer.borderColor = theme.colors.mainWhite.cgColor
        imageHodlerView.layer.borderWidth = 3
    }
    
    private func setupMemberPhotoImageView() {
        guard let view = TextPlaceholderedImageView.loadFromNib() else { return }
        
        view.setup(with: model.textPlaceholderedImageViewSetupModel)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        imageHodlerView.addSubview(view)
        view.addBorderConstraints(constraintSides: .all)
        imageHodlerView.setCornerRadius(imageHodlerView.frame.height / 2)
    }
}
