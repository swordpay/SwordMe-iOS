//
//  HomeStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 04.05.23.
//

import Combine
import Foundation

public final class HomeStackViewModel {
    var selectedIndex: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
}
