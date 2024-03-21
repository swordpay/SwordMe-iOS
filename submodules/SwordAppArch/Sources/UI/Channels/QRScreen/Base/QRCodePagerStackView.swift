//
//  QRCodePagerStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.02.23.
//

import UIKit
import Combine

final class QRCodePagerStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var pagerHolderView: UIView!
    @IBOutlet private weak var segmentedControlHolderView: UIView!

    @IBOutlet private weak var closeButtonTopConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    private var model: QRCodePagerStackViewModel!
    private var pageController: UIPageViewController?
    private var cancellables: Set<AnyCancellable> = []

    private(set) lazy var qrOptionsViewControllers: [UIViewController] = {
        return [ ViewControllerProvider.Common.qrScanner(hasCloseButton: false,
                                                         resultPublisher: model.scanResultPublisher),
                 ViewControllerProvider.Common.myQRCode() ]
    }()

    // MARK: - Setup UI3
    
    func setup(with model: QRCodePagerStackViewModel) {
        self.model = model
        
        closeButton.setCornerRadius(21)
        setupSegmentedControl()
        setupPageViewController()
        
        bindToQROptionChange()
        
        closeButtonTopConstraint.constant = UIScreen.hasSmallScreen ? 20 : 50
        bringSubviewToFront(segmentedControlHolderView)
        bringSubviewToFront(closeButton)
    }
    
    private func setupSegmentedControl() {
        guard let segmentedControl = SegmentedControl.loadFromNib() else { return }

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlHolderView.addSubview(segmentedControl)
        
        segmentedControl.addBorderConstraints(constraintSides: .all)
        segmentedControl.setup(with: model.qrOptionSegmentedControlViewModel)
    }

    private func setupPageViewController() {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.view.backgroundColor = .clear
        addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        controller.view.addBorderConstraints(constraintSides: .all)
        controller.setViewControllers([qrOptionsViewControllers[0]], direction: .forward, animated: true)

        disablePagerScrolling(pageController: controller)
        self.pageController = controller
    }

    private func disablePagerScrolling(pageController: UIPageViewController) {
        for case let scrollView as UIScrollView in pageController.view.subviews {
            scrollView.isScrollEnabled = false
        }
    }
    
    // MARK: - Binding
    
    private func bindToQROptionChange() {
        model.qrOptionSegmentedControlViewModel.selectedIndex
            .dropFirst()
            .sink { [ weak self ] selectedIndex in
                guard let self else { return }
                let isSelectedScanner = selectedIndex == 0
                let direction: UIPageViewController.NavigationDirection = isSelectedScanner ? .reverse : .forward
                let selectedVC = self.qrOptionsViewControllers[selectedIndex]
                
                self.closeButton.backgroundColor = isSelectedScanner ? .black : .clear
                self.pageController?.setViewControllers([selectedVC],
                                                         direction: direction,
                                                         animated: true)

                if isSelectedScanner {
                    (self.qrOptionsViewControllers[0] as? QRScannerViewController)?.startSession()
                } else {
                    (self.qrOptionsViewControllers[0] as? QRScannerViewController)?.stopSession()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func closeButtonTouchUp(_ sender: UIButton) {
        model.closeButtonPublisher.send(())
    }
}
