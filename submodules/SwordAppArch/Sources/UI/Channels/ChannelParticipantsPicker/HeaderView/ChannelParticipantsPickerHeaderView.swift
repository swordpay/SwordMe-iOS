//
//  ChannelParticipantsPickerHeaderView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.03.23.
//

import UIKit
import Combine

final class ChannelParticipantsPickerHeaderView: SetupableView {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBarHolderView: UIView!
    @IBOutlet private weak var newGroupTitleLabel: UILabel!
    @IBOutlet private weak var selectedParticipantsCollectionViewHolderView: UIView!
    @IBOutlet private weak var selectedParticipantsCollectionView: UICollectionView!
    @IBOutlet private weak var newGroupNameHolderStackView: UIView!
    @IBOutlet private weak var newGroupNameBackgroundView: UIView!
    @IBOutlet private weak var newGroupNameTextField: UITextField!
    @IBOutlet private weak var newGroupErrorLabel: UILabel!
    
    @IBOutlet private weak var topSeparator: UIView!
    @IBOutlet private weak var middleSeparator: UIView!
    @IBOutlet private weak var bottomSeparator: UIView!

    @IBOutlet private weak var selectedParticipantsCollectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    private var model: ChannelParticipantsPickerHeaderViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var shapeLayer: CAShapeLayer?

    // MARK: - Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupNewGroupBackgroundView()
    }

    func setup(with model: ChannelParticipantsPickerHeaderViewModel) {
        self.model = model
        
        newGroupTitleLabel.text = Constants.Localization.Channels.newGroup
        newGroupErrorLabel.text = Constants.Localization.ValidationMessage.requiredFieldRange(minLenght: 1, maxLenght: 50)
        
        setupSearchBar()
        setupCollectionView()
        setupNewGroupTextField()

        selectedParticipantsCollectionView.reloadData()
        layoutIfNeeded()
        updateUI()

        bindToAddingParticipant()
        bindToDeletingParticipantIndexPath()
    }
    
    private func setupNewGroupTextField() {
        let placeholderColor = theme.colors.lightGray2
        
        newGroupNameTextField.attributedPlaceholder = NSAttributedString(string: Constants.Localization.Channels.newGroup,
                                  attributes: [.foregroundColor: placeholderColor,
                                               .font: theme.fonts.regular(ofSize: 22, family: .poppins)])
        newGroupNameTextField.delegate = self
    }
   
    private func setupSearchBar() {
        guard let headerView = SearchBarHeaderView.loadFromNib() else { return }
        
        headerView.setup(with: model.searchBarSetupModel)
        headerView.setCornerRadius()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBarHolderView.addSubview(headerView)
        headerView.addBorderConstraints(constraintSides: .all)
    }

    private func setupCollectionView() {
        selectedParticipantsCollectionView.register(UINib(nibName: "\(SelectedParticipantItemCell.self)",
                                                          bundle: Constants.mainBundle),
                                                    forCellWithReuseIdentifier: SelectedParticipantItemCellModel.cellIdentifier)

        selectedParticipantsCollectionView.isHidden = false
        selectedParticipantsCollectionView.delegate = self
        selectedParticipantsCollectionView.dataSource = self
        selectedParticipantsCollectionView.showsHorizontalScrollIndicator = false
        selectedParticipantsCollectionView.showsVerticalScrollIndicator = false

        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        let layout = AlignedCollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .init(width: 80, height: 30)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        
        selectedParticipantsCollectionView.collectionViewLayout = layout
    }
    
    private func calculateCollevtionViewHeight() {
        let newHeight = min(150, self.selectedParticipantsCollectionView.contentSize.height)
        
        guard newHeight != self.selectedParticipantsCollectionViewHeightConstraint.constant else { return }

        self.selectedParticipantsCollectionViewHeightConstraint.constant = 0 // TODO: - Try to implement better animation
        
//        UIView.animate(withDuration: 0.5) {
//            self.selectedParticipantsCollectionView.layoutIfNeeded()
//        }
    }
    
    private func updateGroupComponents() {
        guard model.source == .channelsList else { return }

        let isForGroup = model.dataSource.value.count > 1
        
        middleSeparator.isHidden = !isForGroup
        newGroupTitleLabel.isHidden = !isForGroup
        newGroupNameHolderStackView.isHidden = !isForGroup
    }
    
    private func validateGroupName(_ name: String?) {
        guard let name,
              name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            newGroupErrorLabel.isHidden = false
            
            return
        }
        
        newGroupErrorLabel.isHidden = true
    }
    
    private func setupNewGroupBackgroundView() {
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil

        let shadowLayer: CAShapeLayer = CAShapeLayer()
        
        newGroupNameBackgroundView.layer.cornerRadius = 4
        shadowLayer.path = UIBezierPath(roundedRect: newGroupNameBackgroundView.bounds,
           cornerRadius: 4).cgPath
        shadowLayer.fillColor = newGroupNameBackgroundView.backgroundColor?.cgColor
        shadowLayer.shadowColor = theme.colors.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2,
                                          height: 4)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 4
        newGroupNameBackgroundView.layer.insertSublayer(shadowLayer, at: 0)
        
        setNeedsLayout()
        
        self.shapeLayer = shadowLayer
    }

    private func updateUI() {
//        calculateCollevtionViewHeight()
//        updateGroupComponents()
//        updateSeparatorsVisibility()
    }

    private func updateSeparatorsVisibility() {
        let isHidden = model.dataSource.value.count == 0
        
        topSeparator.isHidden = isHidden
        bottomSeparator.isHidden = isHidden
    }

    private func setupInitialPeersIfNeeded() {
        guard !model.initialPeers.isEmpty else { return }

        let cellModels = model.initialPeers.map{ SelectedParticipantItemCellModel(participant: $0) }
        self.model.dataSource.value.append(contentsOf: cellModels)
        let indexPaths = (0..<cellModels.count).map { IndexPath(row: $0, section: 0) }
        self.selectedParticipantsCollectionView.performBatchUpdates {
            self.selectedParticipantsCollectionView.insertItems(at: indexPaths)
        } completion: { completed in
            self.updateUI()
        }
    }
    
    // MARK: - Binding
        
    private func bindToAddingParticipant() {
        model.addingParticipant
            .sink { [ weak self ] participant in
                guard let self else { return }
                
                let cellModel = SelectedParticipantItemCellModel(participant: participant)
                self.model.dataSource.value.insert(cellModel, at: 0)
//                guard self.model.dataSource.value.count != 1 else {
//                    self.selectedParticipantsCollectionView.reloadData()
//
//                    self.updateUI()
//                    return
//                }

                self.selectedParticipantsCollectionView.performBatchUpdates {
                    self.selectedParticipantsCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                } completion: { completed in
                    self.updateUI()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindToDeletingParticipantIndexPath() {
        model.deletingParticipantIndexPath
            .sink { [ weak self ] indexPath in
                guard let self else { return }
//                guard self.model.dataSource.value.count != 0 else {
//                    self.selectedParticipantsCollectionView.reloadData()
//
//                    self.updateUI()
//                    return
//                }

                self.selectedParticipantsCollectionView.performBatchUpdates {
                    self.selectedParticipantsCollectionView.deleteItems(at: [indexPath])
                } completion: { _ in
                    self.updateUI()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction private func doneButtonTouchHandler(_ sender: UIButton) {
        model.doneButtonTouchHandler.send(())
    }
}

extension ChannelParticipantsPickerHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.dataSource.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = model.dataSource.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedParticipantItemCellModel.cellIdentifier,
                                                            for: indexPath) as? SelectedParticipantItemCell else {
            return UICollectionViewCell()
        }
        
        
        cellModel.deleteUserButtonPublisher
            .sink { [ weak self ] in
                self?.model.deleteParticipant(cellModel.participant)
            }
            .store(in: &cancellables)

        cell.setup(with: cellModel)
        
        return cell
    }
}

extension ChannelParticipantsPickerHeaderView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateGroupName(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
