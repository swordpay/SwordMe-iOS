//
//  ChannelsHeaderComponentsView.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 04.10.23.
//

import UIKit
import Combine

public final class ChannelsHeaderComponentsView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tabsHolderView: UIView!
    @IBOutlet private weak var recentsHolderView: UIView!
    @IBOutlet private weak var feedButton: UIButton!
    @IBOutlet private weak var transactionsButton: UIButton!

    @IBOutlet private weak var recentsHolderViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var model: ChannelsHeaderComponentsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup UI
    
    public func setup(with model: ChannelsHeaderComponentsViewModel) {
        self.model = model
        
        feedButton.setTitle(Constants.Localization.Common.activity, for: .normal)
        transactionsButton.setTitle(Constants.Localization.Profile.transactions, for: .normal)

        setupTabViews()
        setupRecentsHolderView()
        
        bindToRecents()
    }
    
    private func setupRecentsHolderView() {
        let recentsView = ChannelsHeaderView(frame: .zero,
                                             collectionViewLayout: UICollectionViewFlowLayout())
                    
        recentsView.setup(with: model.channelsHeaderViewModel)

        recentsView.translatesAutoresizingMaskIntoConstraints = false
        recentsHolderView.addSubview(recentsView)
        
        recentsView.addBorderConstraints(constraintSides: .all)
        
        recentsHolderViewHeightConstraint.constant = ComponentSizeProvider.recentRoomsItemHeight.size
    }
    
    private func setupTabViews() {
        setupButton(feedButton, isSelected: true)
        setupButton(transactionsButton, isSelected: false)
    }
    
    private func setupButton(_ button: UIButton, isSelected: Bool) {
        let textColor = isSelected ? theme.colors.gradientDarkBlue : theme.colors.mainGray4
        let fontSize = FontStyle.homeSegmentsTilte.size
        let font = isSelected ? theme.fonts.semibold(ofSize: fontSize, family: .poppins)
                              : theme.fonts.regular(ofSize: fontSize, family: .poppins)
        
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = font
    }

    // MARK: - Binding
    
    private func bindToRecents() {
        model.channelsHeaderViewModel.recentChannels
            .receive(on: RunLoop.main)
            .sink { [ weak self ] recents in
                let isRecentsHidden = recents.isEmpty
                
                self?.recentsHolderView.isHidden = isRecentsHidden
            }.store(in: &cancellables)
    }

    // MARK: - Actions
    @IBAction private func transactionsButtonTouchUp(_ sender: UIButton) {
        NotificationCenter.default.post(name: .chatsTransactionsDidTap, object: nil)
    }
}
