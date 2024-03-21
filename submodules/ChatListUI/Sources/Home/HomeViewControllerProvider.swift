//
//  HomeViewControllerProvider.swift
//  ChatListUI
//
//  Created by Tigran Simonyan on 01.08.23.
//

import Swinject
import Foundation
import SwordAppArch
import AccountContext

public enum HomeViewControllerProvider {
    public static func home(context: AccountContext) -> HomeViewController {
        let assembler = Assembler([ GetUserServiceAssembly(),
                                    GetUserByUsernameServiceAssembly(),
                                    VerifyEmailTokenServiceAssembly(),
                                    HomeViewControllerAssembly(context: context) ])
        let controller = assembler.resolver.resolve(HomeViewController.self)!

        return controller
    }
}
