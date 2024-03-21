//
//  BottomSheetViewController.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 27.06.23.
//

import UIKit

final class BottomSheetViewController: GenericStackViewController<BottomSheetViewModel, BottomSheetStackView> {
    
    // MARK: - Properties
    
    override var shouldRespectSafeArea: Bool { return false }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .clear
        
//        stackView.show()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addCustomView(_ view: UIView) {
        stackView.addCustomView(view)
    }
}
