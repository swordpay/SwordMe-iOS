//
//  CryptoShimmerLoadingView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 01.12.23.
//

import UIKit

final class CryptoShimmerLoadingView: SetupableView {
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var balanceHolderView: UIView!
    @IBOutlet private var balanceContentViews: [UIView]!
    
    @IBOutlet private weak var coinsHolderStackView: UIStackView!
    @IBOutlet private weak var searchBarHolderView: UIView!

    @IBOutlet private weak var searchBarTopConstraint: NSLayoutConstraint!

    func setup(with model: ()) {
        titleLabel.text = Constants.Localization.CryptoAccount.yourCryptoBalance
        let fontSize: CGFloat = UIScreen.hasSmallScreen ? 42 : 48

        balanceLabel.font = theme.fonts.medium(ofSize: fontSize, family: .poppins)
        balanceContentViews.forEach { $0.setCornerRadius(2) }

        setupSearchBar()
        setupCryptoItemViews()
        forceAnimate()

        layoutIfNeeded()
    }

    private func setupSearchBar() {
        guard let headerView = SearchBarHeaderView.loadFromNib() else { return }

        let topInset = UIApplication.shared.rootViewController()?.view.safeAreaInsets.top ?? 0

        headerView.setup(with: .init(placeholder: Constants.Localization.CryptoAccount.searchPlaceholder))
        headerView.setCornerRadius()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        self.searchBarHolderView.addSubview(headerView)
        headerView.addBorderConstraints(constraintSides: .all,
                                        by: .init(top: 0, left: 0, bottom: 0, right: 0))
        headerView.isUserInteractionEnabled = false
        
        searchBarTopConstraint.constant = topInset
    }

    private func setupCryptoItemViews() {
        (0...10).forEach { _ in
            guard let view = CryptoShimmerItemView.loadFromNib() else { return }
            
            view.setup(with: ())
            
            coinsHolderStackView.addArrangedSubview(view)
        }
    }
    
    private func animateBalanceViews() {
        balanceContentViews.forEach { $0.startShimmerAnimation() }
    }
    
    func forceAnimate() {
        animateBalanceViews()
        coinsHolderStackView.arrangedSubviews.forEach { child in
            if let shimmerChild = child as? CryptoShimmerItemView {
                shimmerChild.animate()
            }
        }
    }
}

