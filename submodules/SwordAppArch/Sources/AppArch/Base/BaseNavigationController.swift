//
//  BaseNavigationController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.06.22.
//

import UIKit

public class BaseNavigationController: UINavigationController {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .darkContent
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        setupNavigationBar(for: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupNavigationBar(translucent: Bool = false, showShadow: Bool = true) {
        let appearance = UINavigationBarAppearance()
        let image = UIImage(imageName: Constants.AssetName.SystemIcon.back)
        let buttonAppearance = UIBarButtonItemAppearance()

        buttonAppearance.normal.titleTextAttributes = [.font: ThemeProvider.currentTheme.fonts.semibold(ofSize: 20, family: .poppins)]

        if translucent {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithOpaqueBackground()
        }

        appearance.shadowColor = nil
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        appearance.buttonAppearance = buttonAppearance
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        appearance.backgroundColor = translucent ? .clear : theme.colors.mainWhite
        navigationBar.backItem?.title = ""
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.layoutIfNeeded()
    }

    func setupNavigationBarTitle(fontSize: CGFloat = 20) {
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: theme.colors.textColor,
            .font: theme.fonts.semibold(ofSize: fontSize, family: .poppins)
        ]

        navigationBar.titleTextAttributes = attributes
        navigationBar.standardAppearance.titleTextAttributes = attributes
        navigationBar.scrollEdgeAppearance?.titleTextAttributes = attributes
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        guard viewController != self.viewControllers.first else { return }

        let backButton = UIButton(type: .custom)

        backButton.frame = CGRect(origin: .zero, size: .init(width: 40, height: 40))
        backButton.setImage(UIImage(systemName: Constants.AssetName.SystemIcon.back), for: .normal)
        backButton.setCornerRadius(20)
        backButton.backgroundColor = .clear
        backButton.tintColor = theme.colors.textColor.withAlphaComponent(0.8)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)

        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.leftItemsSupplementBackButton = true
        viewController.navigationItem.leftBarButtonItem = backBarButton
    }

    private func setupNavigationBar(for viewController: UIViewController) {
        interactivePopGestureRecognizer?.delegate = nil

        setupNavigationBar()
        setupNavigationBarTitle()
    }
    
    @objc
    private func pop() {
        popViewController(animated: true)
    }
}

extension BaseNavigationController: Deeplinking {
    public func deeplink(to dest: DeeplinkDestinationing, completion: @escaping (UIViewController?) -> Void) {
        guard let rootViewController = viewControllers.first as? Deeplinking else { return }
        
        rootViewController.deeplink(to: dest, completion: completion)
    }
}

final class BackBarButtonItem: UIBarButtonItem {
    override var menu: UIMenu? {
        set {
            // no need for setup
        }

        get {
            return super.menu
        }
    }
}
