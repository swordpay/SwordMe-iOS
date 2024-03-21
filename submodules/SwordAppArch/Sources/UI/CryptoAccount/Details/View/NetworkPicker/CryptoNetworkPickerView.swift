//
//  CryptoNetworkPickerView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 29.05.23.
//

import UIKit

final class CryptoNetworkPickerView: SetupableView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoHolderView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var networksTableView: UITableView!
    
    // MARK: - Properties
    
    private var model: CryptoNetworkPickerViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        networksTableView.isScrollEnabled = networksTableView.frame.height < networksTableView.contentSize.height
    }

    // MARK: - Setup UI
    
    func setup(with model: CryptoNetworkPickerViewModel) {
        self.model = model
        
        titleLabel.text = Constants.Localization.CryptoAccount.chooseNetwork
        titleLabel.font = theme.fonts.bold(ofSize: 26, family: .poppins)

        setupInfoView()
        setupTableView()
    }
    
    private func setupInfoView() {
        infoHolderView.setCornerRadius(10)
        infoLabel.text = model.isForDeposit ? Constants.Localization.CryptoAccount.chooseNetworkInfo : Constants.Localization.CryptoAccount.chooseNetworkWithdrawInfo
    }
    
    private func setupTableView() {
        networksTableView.register(UINib(nibName: "\(CryptoNetworkItemCell.self)",
                                         bundle: Constants.mainBundle),
                                   forCellReuseIdentifier: CryptoNetworkItemCellModel.reusableIdentifier)
        networksTableView.delegate = self
        networksTableView.dataSource = self
        networksTableView.estimatedRowHeight = 50
        networksTableView.rowHeight = UITableView.automaticDimension
        networksTableView.separatorStyle = .none

        networksTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func closeButtonTouchUp(_ sender: UIButton) {
        model.closeButtonHandler.send(())
    }
}

extension CryptoNetworkPickerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.networks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoNetworkItemCellModel.reusableIdentifier, for: indexPath) as? CryptoNetworkItemCell else {
            return UITableViewCell()
        }
        
        let network = model.networks[indexPath.row]
        cell.setup(with: .init(network: network))
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNetwork = model.networks[indexPath.row]
        
        model.selectedNetwork.send(selectedNetwork)
    }
}
