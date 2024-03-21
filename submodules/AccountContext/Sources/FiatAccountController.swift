//
//  FiatAccountController.swift
//  AccountContext
//
//  Created by Tigran Simonyan on 13.06.23.
//

import UIKit
import Display
import TelegramPresentationData

public class FiatAccountController: ViewController {
    var context: AccountContext
    private var presentationData: PresentationData

    public init(context: AccountContext) {
        self.context = context
        
        self.presentationData = context.sharedContext.currentPresentationData.with { $0 }
        
        
        super.init(navigationBarPresentationData: NavigationBarPresentationData(presentationData: presentationData))
        
        self.tabBarItemContextActionType = .always
        
        self.statusBar.statusBarStyle = self.presentationData.theme.rootController.statusBarStyle.style
        
        self.title = self.presentationData.strings.Contacts_Title
        self.tabBarItem.title = self.presentationData.strings.Contacts_Title
        
        let icon: UIImage?
        icon = UIImage(bundleImageName: "Chat List/Tabs/IconContacts")

        self.tabBarItem.image = icon
        self.tabBarItem.selectedImage = icon
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.presentationData.strings.Common_Back, style: .plain, target: nil, action: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
