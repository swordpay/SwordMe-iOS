//
//  ChannelPaymentStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.03.23.
//

import UIKit
import Combine

public final class ChannelPaymentStackView: SetupableStackView {
    // MARK: - IBOuetlets
    
    @IBOutlet private weak var headerHolderView: UIView!
    @IBOutlet private weak var footerHolderView: UIView!
        
    // MARK: - Properties
    
    private var model: ChannelPaymentStackViewModel!
    private var cancenllables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    public func setup(with model: ChannelPaymentStackViewModel) {
        self.model = model
        
        setupHeaderView()
//        setupFooterView()
    }
    
    private func setupHeaderView() {
        guard let headerView = ChannelPaymentHeaderView.loadFromNib() else { return }

        headerView.setup(with: model.headerModel)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerHolderView.addSubview(headerView)
        headerView.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupFooterView() {
        guard let footerView = ChannelPaymentFooterView.loadFromNib() else { return }
        
        footerView.setup(with: model.footerModel)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerHolderView.addSubview(footerView)
        footerView.addBorderConstraints(constraintSides: .all)
    }
}
