//
//  CryptoDetailsStackView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 09.03.23.
//

import UIKit
import Combine
import SwordCharts

final class CryptoDetailsStackView: SetupableStackView, ChartViewDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cryptoInfoHolderView: UIView!
    @IBOutlet private weak var chartView: LineChartView!
    @IBOutlet private weak var chartLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var segmentedControlHolderView: UIView!
    @IBOutlet private weak var userCryptoInfoHolderView: UIView!
    
    // MARK: - Properties
    
    private var model: CryptoDetailsStackViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Setup UI
    
    func setup(with model: CryptoDetailsStackViewModel) {
        self.model = model
        
        setupUserCryptoInfoView()
        setupCryptoInfoHolderView()
        
        setupSegmentedControl()
        
        bindToChartDataUpdate()
    }

    private func setupSegmentedControl() {
        guard let segmentedControl = SegmentedControl.loadFromNib() else { return }

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlHolderView.addSubview(segmentedControl)
        
        segmentedControl.addBorderConstraints(constraintSides: .all)
        segmentedControl.setup(with: model.intervalsSegmentedControlViewModel)
    }

    private func setupCryptoInfoHolderView() {
        guard let cryptoInfoView = CryptoInfoView.loadFromNib() else { return }
        
        cryptoInfoView.setup(with: model.cryptoInfoSetupModel)
        cryptoInfoView.translatesAutoresizingMaskIntoConstraints = false
        cryptoInfoHolderView.addSubview(cryptoInfoView)
        
        cryptoInfoView.addBorderConstraints(constraintSides: .all)
    }
    
    private func setupUserCryptoInfoView() {
        guard let cryptoUserInfoView = CryptoUserInfoView.loadFromNib() else {
            userCryptoInfoHolderView.isHidden = true

            return
        }
        userCryptoInfoHolderView.isHidden = false

        cryptoUserInfoView.setup(with: model.userCryptoInfoModel)
        cryptoUserInfoView.translatesAutoresizingMaskIntoConstraints = false
        userCryptoInfoHolderView.addSubview(cryptoUserInfoView)
        
        cryptoUserInfoView.addBorderConstraints(constraintSides: .all)
    }

    private func setupDateAxisOfChart() {

    }
    
    private func updateChart(chartData: [ChartDataEntry]) {
        chartView.noDataText = ""

        guard !chartData.isEmpty else {
            chartView.data = []
            chartView.data = nil

            return
        }

        chartLoadingIndicator.stopAnimating()
        let dataSet = LineChartDataSet(entries: chartData, label: "")
        dataSet.setColor(theme.colors.mainGray3)
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.lineWidth = 3

        let data = LineChartData(dataSet: dataSet)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.ddMM_slashed

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(
            values: chartData.map { dataPoint in
                let date = Date(timeIntervalSince1970: TimeInterval(dataPoint.x))
                return dateFormatter.string(from: date)
            }
        )

        chartView.rightAxis.drawLabelsEnabled = false
        let legend = chartView.legend
        let legendEntries = legend.entries

        for i in 0..<legendEntries.count {
            legendEntries[i].form = .none
        }

//        legend.setCustom(entries: legendEntries)

        chartView.data = data
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.legend.form = .none
        chartView.isUserInteractionEnabled = false
        chartView.animate(xAxisDuration: 1)
    }
    
    
    // MARK: - Binding

        private func bindToChartDataUpdate() {
            model.chartData
                .sink { [ weak self ] chartData in
                    self?.updateChart(chartData: chartData)
                }
                .store(in: &cancellables)
        }
        
        // MARK: - Actions
        
        @IBAction func intervalChanged(_ sender: Any) {
    //        let selectedInterval = model.intervals[segmentedControl.selectedSegmentIndex]
    //
    //        model.selectedInterval.send(selectedInterval)
        }

}
