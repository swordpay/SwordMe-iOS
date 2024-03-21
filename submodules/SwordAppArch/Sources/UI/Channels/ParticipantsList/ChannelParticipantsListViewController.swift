//
//  ChannelParticipantsListViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 22.05.23.
//

import UIKit

final class ChannelParticipantsListViewController: GenericTableViewController<ChannelParticipantsListViewModel, EmptyHeaderAndFooterView, ChannelParticipantsListItemCell, EmptyHeaderAndFooterView> {
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.provideDataSource()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Participants"
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
