//
//  CompletionStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import UIKit
// MARK: - SwordChange, Removed This part, check LottieAnimationComponent this implementation
import Lottie
import LottieAnimationComponent
import Combine

final class CompletionStackView: SetupableStackView {
    typealias SetupModel = CompletionStackViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var mainHolderStackView: UIStackView!
    @IBOutlet private weak var mediaHolderView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var actionButtonHolderView: UIView!

    // MARK: - Properties
    
//    private var animationView: LottieAnimationView?

    private var cancellables: Set<AnyCancellable> = []
    private var model: CompletionStackViewModel!

    // MARK: - Setup UI
    
    func setup(with model: CompletionStackViewModel) {
        self.model = model

        mainHolderStackView.setCustomSpacing(20, after: titleLabel)
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        setupActionButton()
        setupMedia(with: model.mediaType)
        
        bindToAppStateNotificationsIfNeeded()
    }
    
    private func setupMedia(with type: CompletionStackViewModel.MediaType) {
        switch type {
        case .image(let name):
            setupImageMedia(imageName: name)
        case .animation:
            return
//            self.setupAnimationMedia(fileName: fileName)
        }
    }
    
    private func setupImageMedia(imageName: String) {
        let imageView = UIImageView()

        imageView.image = UIImage(named: imageName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        mediaHolderView.addSubview(imageView)

        imageView.addBorderConstraints(constraintSides: .all)
    }

    private func setupAnimationMedia(fileName: String) {
//        let animationView = LottieAnimationView(name: fileName)
//
//        animationView.loopMode = .loop
//        animationView.contentMode = .scaleAspectFit
//        animationView.center = mediaHolderView.center
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//
//        mediaHolderView.addSubview(animationView)
//        animationView.addBorderConstraints(constraintSides: .all)
//        animationView.play()
//
//        self.animationView = animationView
    }
    
    private func setupActionButton() {
        let button = GradientedButton()

        button.setup(with: model.actionButtonSetupModel)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setCornerRadius()
        actionButtonHolderView.addSubview(button)
        button.addBorderConstraints(constraintSides: .all)
    }
    
    // MARK: - Binding
    
    private func bindToAppStateNotificationsIfNeeded() {
        guard case .animation = model.mediaType else { return }

//        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
//            .sink { [ weak self ] _ in
//                self?.animationView?.play()
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification, object: nil)
//            .sink { [ weak self ] _ in
//                self?.animationView?.pause()
//            }
//            .store(in: &cancellables)
    }
}
