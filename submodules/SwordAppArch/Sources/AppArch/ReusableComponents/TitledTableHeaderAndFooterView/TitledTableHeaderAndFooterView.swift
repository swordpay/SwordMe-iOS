//
//  TitledTableHeaderAndFooterView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 23.04.22.
//

import UIKit
import Combine

public class TitledTableHeaderAndFooterView: UITableViewHeaderFooterView, Setupable {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabelBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var model: TitledTableHeaderAndFooterViewModel!

    // MARK: - Setup UI

    public func setup(with model: TitledTableHeaderAndFooterViewModel) {
        self.model = model

        titleLabel.font = model.font
        titleLabel.textAlignment = model.textAlignment
        titleLabelBackgroundView.backgroundColor = model.backgroundColor

        bindToTitle()
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        let view = UIView()
        
        view.backgroundColor = model.backgroundColor
        backgroundView = view
    }
    
    // MARK: - Binding
    
    private func bindToTitle() {
        model.title
            .sink { [ weak self ] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
    }
}
