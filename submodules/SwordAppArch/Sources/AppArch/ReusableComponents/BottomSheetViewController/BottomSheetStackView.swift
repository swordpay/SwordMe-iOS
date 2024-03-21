//
//  BottomSheetStackView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 27.06.23.
//

import UIKit

final class BottomSheetStackView: SetupableStackView {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var holderView: UIView!
    @IBOutlet private weak var bottomSheetViewBottomConstraint: NSLayoutConstraint?

    // MAKR: - Properties
    
    private var model: BottomSheetStackViewModel!
    private var animationDuration: Double = 0.15
    private var isKeyboardOpened = false

    // MARK: - Setup UI
    
    func setup(with model: BottomSheetStackViewModel) {
        self.model = model
     
        setupHolderView()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapHandler))
//
//        addGestureRecognizer(tapGesture)
    }
    
    func addCustomView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(view)
    
        view.addBorderConstraints(constraintSides: .all)
//        view.layoutIfNeeded()
//        self.bottomSheetViewBottomConstraint?.constant = 0
    }

    func show() {
//        self.bottomSheetViewBottomConstraint?.constant = 0
//
//        UIView.animate(withDuration: animationDuration) {
//            self.layoutIfNeeded()
//        }
    }

    private func setupHolderView() {
        holderView.layer.masksToBounds = true
        holderView.layer.cornerRadius = 25
        holderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        holderView.backgroundColor = theme.colors.mainWhite
        
        setupPanGesture()
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

        holderView.addGestureRecognizer(panGesture)
        holderView.isUserInteractionEnabled = true
    }

    // MARK: - Gestures
    
    @objc
    func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        guard !isKeyboardOpened else { return }

        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: holderView)
            guard translation.y >= 0 else { return }

            bottomSheetViewBottomConstraint?.constant = -min(translation.y, holderView.frame.height)
            UIView.animate(withDuration: 0.1) {
                self.layoutIfNeeded()
            }
        case .ended, .failed, .cancelled:
            let velocity = gesture.velocity(in: self)
            let translation = gesture.translation(in: holderView)
            let isSwipedQuickly = (0...30).contains(velocity.y)
            let isPassedHalfOfView = translation.y > holderView.frame.height / 2

            if isSwipedQuickly || isPassedHalfOfView {
                dismiss()
            } else {
                bottomSheetViewBottomConstraint?.constant = 0
                UIView.animate(withDuration: animationDuration) {
                    self.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }

    @objc
    private func backgroundViewTapHandler() {
        dismiss()
    }
    
    private func dismiss(completion: Constants.Typealias.VoidHandler? = nil) {
        let height = holderView.frame.height
        
        if isKeyboardOpened {
            holderView?.endEditing(true)
        }

        UIView.animate(withDuration: animationDuration) {
            self.bottomSheetViewBottomConstraint?.constant = -height
            self.layoutIfNeeded()
        } completion: { animated in
            self.model.dismissCompletion.send(())
        }
    }
}
