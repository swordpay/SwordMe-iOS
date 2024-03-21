//
//  SetupableCell.swift
//  sword-ios
//
//  Created by Scylla IOS on 27.05.22.
//

import UIKit

public typealias SetupableView = UIView & Setupable
public typealias SetupableCollectionCell = UICollectionViewCell & Setupable

public protocol Setupable {
    associatedtype SetupModel

    func setup(with model: SetupModel)
}
