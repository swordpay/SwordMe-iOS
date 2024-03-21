//
//  MediaPickerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.05.22.
//

import UIKit

final class MediaPickerViewController: HeaderFooterViewController<MediaPickerViewModel> {
    override var shouldRespectSafeArea: Bool { return false }
    private let imagePickerController = UIImagePickerController()
    
    
    override func emptyStateViewProvider() -> UIView? {
        guard let emptyView = SystemServicePermissionAccessView.loadFromNib() else { return nil }

        emptyView.setup(with: viewModel.emptyStateViewModel)

        return emptyView
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPicketView()
        checkCameraAuthorizationStatusIfNeeded()
    }

    // MARK: - Setup UI

    private func setupPicketView() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = viewModel.sourceType
        imagePickerController.mediaTypes = ["public.image", "public.movie"]

        addChild(imagePickerController)
        contentView = imagePickerController.view
        imagePickerController.didMove(toParent: self)
    }

    private func checkCameraAuthorizationStatusIfNeeded() {
        guard viewModel.sourceType == .camera else { return }

        CameraManagerProvider.native.checkAuthorizationStatus()
    }

    // MARK: - Binding
    
    override func bindViewModel() {
        super.bindViewModel()
        
        bindToEmptyStateCloseButton()
        bindToCameraAuthorizationStatus()
    }
    
    private func bindToEmptyStateCloseButton() {
        viewModel.emptyStateViewModel.closeButtonActionPublisher
            .sink { [ weak self ] in
                self?.navigator.goTo(BackDestination.dismiss(animated: true, completion: nil))
            }
            .store(in: &cancellables)
    }

    private func bindToCameraAuthorizationStatus() {
        guard viewModel.sourceType == .camera else { return }

        CameraManagerProvider.native.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .sink { [ weak self ] status in
                guard let self,
                      let status else { return }

                switch status {
                case .unauthorized:
                    self.viewModel.isEmptyState.send(true)
                case .notDetermined:
                    CameraManagerProvider.native.authorizeCameraAccess()
                default:
                    return
                }
            }.store(in: &cancellables)
    }

    // MARK: - Navigation

    public override func dismiss(completion: (() -> Void)? = nil) {
        navigator.goTo(BackDestination.dismiss(animated: true, completion: completion))
    }
}

// MARK: - UIImagePicketController Delegate

extension MediaPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss { [ weak self ] in
            if let image = info[.originalImage] as? UIImage {
                self?.viewModel.mediaSelectionHandler(.uiImage(image.correctlyOrientedImage()))
            } else if let videoURL = info[.mediaURL] as? URL {
                self?.viewModel.mediaSelectionHandler(.video(videoURL))
            } else {
                print("failed to load images")
            }
        }
    }
}
