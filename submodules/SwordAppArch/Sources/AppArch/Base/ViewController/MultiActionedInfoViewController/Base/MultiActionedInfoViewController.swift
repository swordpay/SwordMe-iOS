//
//  MultiActionedInfoViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 08.12.22.
//

import UIKit

class MultiActionedInfoViewController<ViewModel: MultiActionedInfoViewModeling>: GenericStackViewController<ViewModel, MultiActionedInfoStackView> where ViewModel.SetupModel == MultiActionedInfoStackView.SetupModel {
    // MARK: - Properties
    
    override var headerContainerViewInsets: UIEdgeInsets {
        let leadingSpace: CGFloat = UIScreen.hasSmallScreen ? 20 : 60
        return UIEdgeInsets(top: 20, left: leadingSpace, bottom: -10, right: -leadingSpace)
    }
    
    override var contentContainerViewInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    override var shouldEmbedInScrollView: Bool { return false }
    
    // MARK: - Lifecycle Methods
    
    override func displayNodeDidLoad() {
        super.displayNodeDidLoad()
        
        setupHeaderView()
        viewModel.prepareContent()
    }

    // MARK: - Setup UI

    private func setupHeaderView() {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = theme.colors.textColor
        label.font = theme.fonts.font(style: .header,
                                      family: .poppins,
                                      weight: .bold)
        label.textAlignment = .center
        label.text = viewModel.title
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        self.headerView = label
    }
}
