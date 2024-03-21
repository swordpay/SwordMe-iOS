//
//  PagerViewDataSourced.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.05.23.
//

import UIKit
import Combine

protocol PagerViewModeling {
    var icon: String? { get set }
    var title: String { get set }
    var description: String { get set }
}

protocol PagerViewDataSourced: ViewModeling {
    associatedtype PageModel: PagerViewModeling

    var dataSource: [PageModel] { get }
    var hasPageControl: Bool { get }
}

extension PagerViewDataSourced {
    var hasPageControl: Bool { return true }
}
