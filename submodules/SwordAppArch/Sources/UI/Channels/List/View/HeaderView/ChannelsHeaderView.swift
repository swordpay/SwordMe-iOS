//
//  ChannelsHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import UIKit
import Display
import Combine

public final class ChannelsHeaderView: UICollectionView, Setupable, UIGestureRecognizerDelegate {
    // MARK: - Properties
    
    private var model: ChannelsHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    public func setup(with model: ChannelsHeaderViewModel) {
        self.model = model
        
        backgroundColor = .white
        setupCollectionView()
        
        bindTORecentChannels()
    }
    
    private func setupCollectionView() {
        register(UINib(nibName: "\(ChannelsHeaderItemCell.self)",
                       bundle: Constants.mainBundle),
                 forCellWithReuseIdentifier: ChannelsHeaderItemCellModel.cellIdentifier)
        
        isHidden = false
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
    
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionViewLayout = layout
    }
    
    private func bindTORecentChannels() {
        model.recentChannels
            .sink { [ weak self ] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        cancelContextGestures(view: self)
        
        return true
    }

    private func cancelContextGestures(view: UIView) {
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if let recognizer = recognizer as? InteractiveTransitionGestureRecognizer {
                    recognizer.cancel()
                } else if let recognizer = recognizer as? WindowPanRecognizer {
                    recognizer.cancel()
                }
            }
        }

        if let superview = view.superview {
            cancelContextGestures(view: superview)
        }
    }
}

extension ChannelsHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.recentChannels.value.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let channelItem = model.recentChannels.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelsHeaderItemCellModel.cellIdentifier,
                                                            for: indexPath) as? ChannelsHeaderItemCell else {
            return UICollectionViewCell()
        }

        cell.setup(with: .init(channelItem: channelItem))
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let channelItem = model.recentChannels.value[safe: indexPath.item] else { return }
        let userInfo = ["channelItem": channelItem]
        
        NotificationCenter.default.post(name: .recentItemDidSelected, object: self, userInfo: userInfo)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: ComponentSizeProvider.recentRoomsItemHeight.size,
                     height: ComponentSizeProvider.recentRoomsItemHeight.size)
    }
}
