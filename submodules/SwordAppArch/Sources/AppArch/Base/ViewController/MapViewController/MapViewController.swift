//
//  MapViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 11.05.22.
//

import UIKit

final class MapViewController: GenericStackViewController<MapViewModel, MapStackView> {
    // MARK: - Properties

    override var shouldEmbedInScrollView: Bool { return false }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        title = viewModel.title
    }
}
