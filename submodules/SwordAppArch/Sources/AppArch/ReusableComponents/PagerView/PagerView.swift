//
//  PagerView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 05.12.22.
//

import UIKit
import Combine

final class PagerView: SetupableView {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var holderStackView: UIStackView!

    // MARK: - Properties

    private var model: PagerViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupPagesBackgrounds()
    }

    // MARK: - Setup UI

    func setup(with model: PagerViewModel) {
        self.model = model
        
        bindToCurrentPage()
    }
    
    private func setupUI(currentPage: Int) {
        let views = (0 ..< model.numberOfPages).map { prepareItemView(index: $0) }
        
        resetHolderStackView()
        views.forEach { holderStackView.addArrangedSubview($0) }
        holderStackView.layoutIfNeeded()
    }

    private func setupPagesBackgrounds() {
        holderStackView.arrangedSubviews.enumerated().forEach { item in
            let isGradiented = (item.offset + 1) <= model.currentPage.value

            if isGradiented {
                setupBackgroundGradient(on: item.element)
            } else {
                item.element.backgroundColor = theme.colors.backgroundLightBlue
            }
        }
    }
    
    private func prepareItemView(index: Int) -> UIView {
        let pageView = UIView()
        let viewHeight: CGFloat = 5
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.heightAnchor.constraint(equalToConstant: viewHeight),
            pageView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        pageView.layer.cornerRadius = viewHeight / 2
        pageView.clipsToBounds = true

        return pageView
    }
    
    private func setupBackgroundGradient(on view: UIView) {
        let colors: [CGColor] = [theme.colors.gradientLightBlue.cgColor,
                                 theme.colors.gradientDarkBlue.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Binding
    
    private func bindToCurrentPage() {
        model.currentPage
            .sink { [ weak self ] page in
                self?.setupUI(currentPage: page)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    
    private func resetHolderStackView() {
        holderStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
