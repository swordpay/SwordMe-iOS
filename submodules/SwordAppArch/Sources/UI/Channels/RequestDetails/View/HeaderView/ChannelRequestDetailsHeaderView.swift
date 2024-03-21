//
//  ChannelRequestDetailsHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 28.12.22.
//

import UIKit

final class ChannelRequestDetailsHeaderView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentHolderStackView: UIStackView!
    
    // MARK: - Properties
    
    private var model: ChannelRequestDetailsHeaderViewModel!
    
    // MARK: - Setup UI
    
    func setup(with model: ChannelRequestDetailsHeaderViewModel) {
        self.model = model
        
        setupContent()
    }
    
    private func setupContent() {
        let dataSource = model.provideDataSource()
        let contentItems = dataSource.compactMap { provideContentItemView(data: $0) }

        contentItems.forEach { contentHolderStackView.addArrangedSubview($0) }
    }
    
    private func provideContentItemView(data: (String, NSAttributedString)) -> ChannelRequestDetailsHeaderItemView?  {
        guard let itemView = ChannelRequestDetailsHeaderItemView.loadFromNib() else { return nil }
        
        itemView.setup(with: ChannelRequestDetailsHeaderItemViewModel(title: data.0, attributedDescription: data.1))
        
        return itemView
    }
}
