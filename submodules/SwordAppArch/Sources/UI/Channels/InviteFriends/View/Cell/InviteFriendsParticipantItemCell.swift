//
//  InviteFriendsParticipantItemCell.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.04.23.
//

import UIKit
import Combine

final class InviteFriendsParticipantItemCell: SetupableTableViewCell {
 
    // MARK: - IBOutlets
    
    @IBOutlet private weak var radioImageView: UIImageView!
    @IBOutlet private weak var participantPhotoImageView: UIImageView!
    @IBOutlet private weak var participantNameLabel: UILabel!
    
    // MARK: - Properties
    
    private var model: InviteFriendsParticipantItemCellModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellables = []
    }
    
    // MARK: - Setup UI
    
    func setup(with model: InviteFriendsParticipantItemCellModel) {
        self.model = model
        
        radioImageView.isHidden = !model.isForMultipleSelection
        participantNameLabel.text = model.participent.name

//        setupParticipantImageView()
        
        bindToSelection()
    }
    
    private func setupParticipantImageView() {
        guard let image = model.participent.image else {
            participantPhotoImageView.isHidden = true

            return
        }
        
        participantPhotoImageView.setCornerRadius(3)
        participantPhotoImageView.isHidden = false
        participantPhotoImageView.image = UIImage(data: image) 
    }
    
    // MARK: - Binding
    
    private func bindToSelection() {
        model.isSelected
            .sink { [ weak self ] isSelected in
                guard let self else { return }

                let imageName = isSelected ? self.model.selectedImageName
                                           : self.model.unselectedImageName
                self.radioImageView.image = UIImage(imageName: imageName)
            }
            .store(in: &cancellables)
    }
}
