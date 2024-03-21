//
//  SelectedParticipantsView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 21.04.23.
//

import UIKit
import Combine

final class SelectedParticipantsView: SetupableView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var model: SelectedParticipantsViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Setup UI
    
    func setup(with model: SelectedParticipantsViewModel) {
        self.model = model

        titleLable.text  = Constants.Localization.Channels.selectedUsers
        setupCollectionView()
        
        bindToSelectedParticipants()
    }
    
    private func setupCollectionView() {
        itemsCollectionView.register(UINib(nibName: "\(SelectedParticipantItemCell.self)",
                                           bundle: .main),
                                     forCellWithReuseIdentifier: SelectedParticipantItemCellModel.cellIdentifier)

        itemsCollectionView.isHidden = false
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.showsHorizontalScrollIndicator = false
        itemsCollectionView.showsVerticalScrollIndicator = false
        
        setupCollectionViewLayout()
    }

    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        itemsCollectionView.collectionViewLayout = layout
    }

    // MARK: - Binding
    
    private func bindToSelectedParticipants() {
        model.selectedParticipants
            .sink { [ weak self ] _ in
                self?.itemsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SelectedParticipantsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.selectedParticipants.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let participant = model.selectedParticipants.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedParticipantItemCellModel.cellIdentifier,
                                                            for: indexPath) as? SelectedParticipantItemCell else {
            return UICollectionViewCell()
        }
        
        let cellModel = SelectedParticipantItemCellModel(participant: participant)
        
        cellModel.deleteUserButtonPublisher
            .sink { [ weak self ] in
                self?.model.deleteParticipan(at: indexPath)
            }
            .store(in: &cancellables)

        cell.setup(with: cellModel)
        
        return cell
    }
}
