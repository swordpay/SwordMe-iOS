//
//  EmptyHeaderAndFooterView.swift
//  sword-ios
//
//  Created by Scylla IOS on 13.06.22.
//

import UIKit

public final class EmptyHeaderAndFooterView: UITableViewHeaderFooterView, Setupable {
    public typealias SetupModel = EmptyModel

    public func setup(with model: EmptyModel) {}
}

public struct EmptyModel: Emptiable {
    public var isEmpty: Bool { return true }
}
