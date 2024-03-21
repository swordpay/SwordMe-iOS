//
//  SystemServiceViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 18.04.22.
//

import UIKit

class SystemServiceViewController<ViewModel: SystemServiceViewModel>: GenericStackViewController<ViewModel, SystemServiceStackView> {
    // MARK: - Properties

    override var shouldEmbedInScrollView: Bool { return false }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme.colors.mainWhite
    }
}
