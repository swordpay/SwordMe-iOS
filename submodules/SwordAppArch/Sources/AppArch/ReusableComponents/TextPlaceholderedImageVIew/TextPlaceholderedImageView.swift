//
//  TextPlaceholderedImageView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import UIKit
import Combine

final class TextPlaceholderedImageView: SetupableView {
    // MARK: - IBOutlets

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    
    private var model: TextPlaceholderedImageViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    func setup(with model: TextPlaceholderedImageViewModel) {
        self.model = model
        
        photoImageView.setCornerRadius(model.cornerRadius)
        titleLabel.setCornerRadius(model.cornerRadius)
        titleLabel.font = theme.fonts.bold(ofSize: model.fontSize, family: .rubik)
        setupImageView(with: model.imageData.value)

        bindToTitle()
        bindToImageData()
    }
    
    private func bindToImageData() {
        model.imageData
            .receive(on: RunLoop.main)
            .sink { [ weak self ] data in
                self?.setupImageView(with: data)
            }
            .store(in: &cancellables)
    }
    
    private func setupImageView(with data: Data?) {
        guard let data else {
            photoImageView.isHidden = true
            titleLabel.isHidden = false
            titleLabel.text = model.title.value.first?.uppercased()
            titleLabel.backgroundColor = theme.colors.mainYellow

            return
        }
        
        titleLabel.isHidden = true
        photoImageView.isHidden = false
        photoImageView.image = UIImage(data: data)
    }
    
    // MARK: - Binding
    
    private func bindToTitle() {
        model.title
            .sink { [ weak self ] title in
                self?.titleLabel.text = title.first?.uppercased()
            }
            .store(in: &cancellables)
    }
}
