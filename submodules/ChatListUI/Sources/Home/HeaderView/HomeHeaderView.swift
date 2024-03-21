//
//  HomeHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Combine
import SwordAppArch

final class HomeHeaderView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBarHolderView: UIView!
    @IBOutlet private weak var searchIconImageView: UIImageView!
    @IBOutlet private weak var searchBarLabel: UILabel!
    @IBOutlet private weak var scanQRButton: UIButton!
    @IBOutlet private weak var feedButton: UIButton!
    @IBOutlet private weak var transactionsButton: UIButton!
    @IBOutlet private weak var recentsHolderView: UIView!
    
    @IBOutlet private weak var scanQRButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchBarHolderViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    private var model: HomeHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var internetQualityView: InternetQualityView?

    // MARK: - Setup UI
    
    func setup(with model: HomeHeaderViewModel) {
        self.model = model
        
        scanQRButton.setImage(UIImage(imageName: "qr-scan-backgrounded-icon"), for: .normal)
        searchIconImageView.image = UIImage(imageName: "search-icon")
        
        searchBarLabel.font = theme.fonts.font(style: .placeholder, family: .poppins, weight: .regular)
        searchBarLabel.text = Constants.Localization.Common.users
        feedButton.setTitle(Constants.Localization.Common.feed, for: .normal)
        transactionsButton.setTitle(Constants.Localization.Profile.transactions, for: .normal)

        setupRecentsView()
        setupConstraints()
        setupActionButtons()
        setupSearchBarHolderView()
        setupInternetQualityView()
        
        bindToNetworkState()
        bindToIsInternetQualtyStatus()
        bindToExternalSelectedTabIndex()
    }
    
    private func setupConstraints() {
        scanQRButtonHeightConstraint.constant = ComponentSizeProvider.homeSearchBarHeight.size
        searchBarHolderViewHeightConstraint.constant = ComponentSizeProvider.homeSearchBarHeight.size
    }

    private func setupRecentsView() {
        guard let recentsView = ChannelsHeaderView.loadFromNib() else {
            recentsHolderView.isHidden = true
            
            return
        }
        
        recentsHolderView.isHidden = true
        
        recentsView.translatesAutoresizingMaskIntoConstraints = false
        recentsView.setup(with: model.recentsSetupModel)
        
        recentsHolderView.addSubview(recentsView)
        recentsView.addBorderConstraints(constraintSides: .all)

        model.recentsSetupModel.recentChannels
            .sink { [ weak self ] channels in
                guard let self else { return }
                self.recentsHolderView.isHidden = self.model.recentsSetupModel.recentChannels.value.isEmpty
            }
            .store(in: &cancellables)
    }

    private func setupInternetQualityView() {
        guard let qualityView = InternetQualityView.loadFromNib() else { return }
        
        qualityView.alpha = 0
        qualityView.setup(with: model.internetQualityViewModel)
        qualityView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(qualityView)
        qualityView.addBorderConstraints(constraintSides: .horizontal)
        qualityView.topAnchor.constraint(equalTo: searchBarHolderView.topAnchor).isActive = true
        
        self.internetQualityView = qualityView
    }

    private func setupSearchBarHolderView() {
        searchBarHolderView.setCornerRadius(ComponentSizeProvider.homeSearchBarHeight.size / 2)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapHandler))
        
        searchBarHolderView.addGestureRecognizer(tapGesture)
        searchBarHolderView.isUserInteractionEnabled = true
    }
    
    private func setupActionButtons() {
        setupButton(feedButton, isSelected: model.isFeedSelected)
        setupButton(transactionsButton, isSelected: !model.isFeedSelected)
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
    
    private func bindToIsInternetQualtyStatus() {
        model.isInternetQualtyLow
            .receive(on: RunLoop.main)
            .sink { [ weak self ] isInternetQualtyLow in
                let alpha: CGFloat = isInternetQualtyLow ? 1 : 0
                
                UIView.animate(withDuration: 0.2) {
                    self?.internetQualityView?.alpha = alpha
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindToNetworkState() {
        model.networkState
            .receive(on: RunLoop.main)
            .sink { [ weak self ] networkState in
                let alpha: CGFloat = networkState == .online ? 0 : 1
                self?.model.internetQualityViewModel.networkState.send(networkState)

                UIView.animate(withDuration: 0.2) {
                    self?.internetQualityView?.alpha = alpha
                }
            }
            .store(in: &cancellables)
    }

    private func bindToExternalSelectedTabIndex() {
        model.externalSelectedTabIndex
            .sink { [ weak self ] index in
                self?.model.selectedTabIndex.send(index)
                self?.model.isFeedSelected = index == 0
                self?.setupActionButtons()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    private func searchBarTapHandler() {
        model.searchBarTapHandler.send(())
    }
    
    @IBAction private func feedButtonTouchUp(_ sender: UIButton) {
        guard !model.isFeedSelected else { return }
        
        model.isFeedSelected = true
        setupActionButtons()
        model.selectedTabIndex.send(0)
    }
    
    @IBAction private func transactionsButtonTouchUp(_ sender: UIButton) {
        guard model.isFeedSelected else { return }
        
        model.isFeedSelected = false
        setupActionButtons()

        model.selectedTabIndex.send(1)
    }
    
    @IBAction private func scanQRTouchUp(_ sender: UIButton) {
        model.scanQRTapHandler.send(())
    }
}
