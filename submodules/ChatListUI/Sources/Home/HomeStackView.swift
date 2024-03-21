//
//  HomeStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Combine
import SwordAppArch

public final class HomeStackView: SetupableStackView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var pagerHolderView: UIView!

    // MARK: - Properties
    
    private var model: HomeStackViewModel!
    private var pageController: UIPageViewController?
    private var cancellables: Set<AnyCancellable> = []
    
    private(set) lazy var controllers: [UIViewController] = {
        return [ ]
    }()

    // MARK: - Setup UI
    
    public func setup(with model: HomeStackViewModel) {
        self.model = model
        
        pagerHolderView.backgroundColor = .red
//        setupPageViewController()
//        
//        bindToSelectedScreenChange()
    }
    
    private func setupPageViewController() {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.view.backgroundColor = .clear
        addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        controller.view.addBorderConstraints(constraintSides: .all)
        controller.setViewControllers([controllers[0]], direction: .forward, animated: true)

        disablePagerScrolling(pageController: controller)
        self.pageController = controller
    }

    private func disablePagerScrolling(pageController: UIPageViewController) {
        for case let scrollView as UIScrollView in pageController.view.subviews {
            scrollView.isScrollEnabled = false
        }
    }
    
    // MARK: - Binding

    private func bindToSelectedScreenChange() {
        model.selectedIndex
            .dropFirst()
            .sink { [ weak self ] selectedIndex in
                guard let self else { return }
                let isSelectedScanner = selectedIndex == 0
                let direction: UIPageViewController.NavigationDirection = isSelectedScanner ? .reverse : .forward
                let selectedVC = self.controllers[selectedIndex]
                
                self.pageController?.setViewControllers([selectedVC],
                                                         direction: direction,
                                                         animated: true)
            }
            .store(in: &cancellables)
    }
}
