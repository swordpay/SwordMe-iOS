//
//  BottomSheetPresentor.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 03.05.22.
//

import UIKit
import Combine
import Display

final class BottomSheetPresentor: NSObject, UIGestureRecognizerDelegate {
    var bottomSheetContentHolderView: UIView?

    var bottomSheetView: UIView?
    var bottomSheetViewBGView: UIView?

    private var cancellables: Set<AnyCancellable> = []
    private var window: UIView?

    private var bottomSheetViewBottomConstraint: NSLayoutConstraint?
    private var bottomSheetViewHeightConstraint: NSLayoutConstraint?

    private var animationDuration: Double = 0.15
    private var isKeyboardOpened = false
    private var dismissCompletion: Constants.Typealias.VoidHandler?
    
    // MARK: - Presentation

    func present(_ view: UIView, on parentView: UIView? = nil, height: CGFloat, onDismiss: Constants.Typealias.VoidHandler? = nil) {
        guard let window = parentView else { return }

        dismissCompletion = onDismiss
        
        self.window = window
        setupKeyboardNotifications()

        setupBackgroundView()
        prepareBottomSheetView()
        setupPanGesture()

        guard let sheetHolderView = bottomSheetView else { return }
        let bottomInset = window.safeAreaInsets.bottom
        let optimalHeight = min(window.frame.height * 0.8, height + bottomInset)

        view.translatesAutoresizingMaskIntoConstraints = false
        sheetHolderView.addSubview(view)
        view.addBorderConstraints(constraintSides: .all,
                                  by: UIEdgeInsets(top: 0, left: 0, bottom: -bottomInset, right: 0))

        bottomSheetViewHeightConstraint?.constant = optimalHeight
        bottomSheetViewBottomConstraint?.constant = optimalHeight
        bottomSheetViewHeightConstraint?.isActive = true
        bottomSheetViewBottomConstraint?.isActive = true

        window.layoutIfNeeded()

        bottomSheetViewBGView?.isHidden = false

        UIView.animate(withDuration: animationDuration) {
            self.bottomSheetViewBGView?.alpha = 1
            self.window?.layoutIfNeeded()
        } completion: { animated in
            if animated {
                UIView.animate(withDuration: self.animationDuration) {
                    self.bottomSheetViewBottomConstraint?.constant = 0
                    self.window?.layoutIfNeeded()
                }
            }
        }
    }

    func dismiss(completion: Constants.Typealias.VoidHandler? = nil) {
        guard let height = bottomSheetView?.frame.height else { return }

        if isKeyboardOpened {
            bottomSheetView?.endEditing(true)
        }

        cancellables = []

        UIView.animate(withDuration: animationDuration) {
            self.bottomSheetViewBottomConstraint?.constant = height
            self.window?.layoutIfNeeded()
        } completion: { animated in
            if animated {
                UIView.animate(withDuration: self.animationDuration) {
                    self.bottomSheetViewBGView?.alpha = 0
                    self.window?.layoutIfNeeded()
                } completion: { animated in
                    if animated {
                        self.bottomSheetViewBGView?.removeFromSuperview()
                        self.bottomSheetViewBGView = nil
                        self.bottomSheetView?.removeFromSuperview()
                        self.bottomSheetView = nil
                        completion?()
                        self.dismissCompletion?()
                    }
                }
            }
        }
    }

    // MARK: - UI Setup

    private func prepareBottomSheetView() {
        guard let window = window else { return }

        let mainView = UIView()

        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 25
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainView.backgroundColor = ThemeProvider.currentTheme.colors.mainWhite
        mainView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])

        bottomSheetViewHeightConstraint = mainView.heightAnchor.constraint(equalToConstant: 0)
        bottomSheetViewHeightConstraint?.isActive = false

        bottomSheetViewBottomConstraint = mainView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        bottomSheetViewBottomConstraint?.isActive = false

        self.bottomSheetView = mainView
    }

    private func setupBackgroundView() {
        let view = UIView()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapHandler))

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        window?.addSubview(view)
        view.addBorderConstraints(constraintSides: .all)

        view.alpha = 0
        view.backgroundColor = ThemeProvider.currentTheme.colors.textColor.withAlphaComponent(0.6)
//        view.addGestureRecognizer(tapGesture)

        bottomSheetViewBGView = view
    }

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

        bottomSheetView?.addGestureRecognizer(panGesture)
        bottomSheetView?.isUserInteractionEnabled = true
    }

    // MARK: - Handler

    @objc
    private func backgroundViewTapHandler() {
        dismiss()
    }

    @objc
    func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        guard !isKeyboardOpened else { return }

        guard let window = window,
              let bottomSheetView = bottomSheetView else {
            return
        }

        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: bottomSheetView)
            guard translation.y >= 0 else { return }

            bottomSheetViewBottomConstraint?.constant = min(translation.y, bottomSheetView.frame.height)
            UIView.animate(withDuration: 0.1) {
                self.window?.layoutIfNeeded()
            }
        case .ended, .failed, .cancelled:
            let velocity = gesture.velocity(in: window)
            let translation = gesture.translation(in: bottomSheetView)
            let isSwipedQuickly = (0...30).contains(velocity.y)
            let isPassedHalfOfView = translation.y > bottomSheetView.frame.height / 2

            if isSwipedQuickly || isPassedHalfOfView {
                dismiss()
            } else {
                bottomSheetViewBottomConstraint?.constant = 0
                UIView.animate(withDuration: animationDuration) {
                    self.window?.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}

// MARK: - Setup Keyboard Notifications

extension BottomSheetPresentor {
    func setupKeyboardNotifications() {
        let defaultNotifications = NotificationCenter.default

        defaultNotifications
            .publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .merge(with: defaultNotifications.publisher(for: UIResponder.keyboardWillHideNotification, object: nil))
            .sink(receiveValue: { [ weak self ] notification in
                self?.handleKeyboardNotification(notification)
            })
            .store(in: &cancellables)
    }

    func handleKeyboardNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let window = window else { return }

        let keyboardFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
        let keyboardFrame = window.convert(keyboardFrameScreenCoordinates, to: window)
        let keyboardDidHide = notification.name == UIResponder.keyboardWillHideNotification

        isKeyboardOpened = !keyboardDidHide

        handleKeyboardFrameChange(isHidden: keyboardDidHide,
                                  size: keyboardFrame.size,
                                  duration: animationDuration,
                                  curve: UIView.AnimationCurve(rawValue: animationCurve)!)
    }

    // MARK: - Handle Keyboard Frame Changes

    func handleKeyboardFrameChange(isHidden: Bool, size: CGSize, duration: Double, curve: UIView.AnimationCurve) {
        let bottomInset = isHidden ? 0 : size.height
        let animator = UIViewPropertyAnimator(duration: duration,
                                              curve: curve) { [ weak self ] in
            self?.bottomSheetViewBottomConstraint?.constant = -bottomInset
            self?.window?.layoutIfNeeded()
        }

        animator.startAnimation()
    }
}
