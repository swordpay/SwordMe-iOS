//
//  CryptoDetailsStackViewModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import Combine
import Foundation
import SwordCharts

final class CryptoDetailsStackViewModel {
    private var cancellables: Set<AnyCancellable> = []
    
    let cryptoInfo: CryptoModel
    let selectedInterval: CurrentValueSubject<ChartDataInterval, Never> = CurrentValueSubject(.oneDay)
    
    let intervals = ChartDataInterval.allCases
    lazy var cryptoInfoSetupModel: CryptoInfoViewModel = .init(cryptoInfo: cryptoInfo)
    lazy var userCryptoInfoModel: CryptoUserInfoViewModel = .init(cryptoInfo: cryptoInfo)
    var chartData: CurrentValueSubject<[ChartDataEntry], Never> = CurrentValueSubject([])

    lazy var intervalsSegmentedControlViewModel: SegmentedControlSetupModel = {
        let models: [SegmentedControlSetupModel.ItemModel] = intervals.map { $0.rawValue }
            .enumerated()
            .map { .init(title: $0.element, isSelected: CurrentValueSubject($0.offset == 0)) }
        
        return SegmentedControlSetupModel(models: models, style: .dark, fontSize: .small, isAnimatable: false)
    }()

    init(cryptoInfo: CryptoModel) {
        self.cryptoInfo = cryptoInfo

        bindToSelectedInterval()
    }
    
    private func bindToSelectedInterval() {
        intervalsSegmentedControlViewModel.selectedIndex
            .sink { [ weak self ] index in
                guard let self else { return }

                let selectedInterval = self.intervals[index]
                
                self.selectedInterval.send(selectedInterval)
            }
            .store(in: &cancellables)
    }
}
