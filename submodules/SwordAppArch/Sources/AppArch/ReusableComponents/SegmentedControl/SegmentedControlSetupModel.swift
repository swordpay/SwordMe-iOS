//
//  SegmentedControlSetupModel.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 26.12.22.
//

import Combine
import Foundation

final class SegmentedControlSetupModel {
    private var cancellables: Set<AnyCancellable> = []

    let selectedIndex: CurrentValueSubject<Int, Never>
    let models: [ItemModel]
    let form: Form
    let style: Style
    let fontSize: FontSize
    let isAnimatable: Bool

    lazy var setupModels: [SegmentedControllItemSetupModel] = {
        let setupModels = models.map { SegmentedControllItemSetupModel(setupModel: $0, style: style, form: form, fontSize: fontSize) }
        
        setupModels.enumerated().forEach { element in
            element.element.selectionPublisher
                .sink { [ weak self ] in
                    self?.updateSelectedIndex(to: element.offset)
                }
                .store(in: &cancellables)
        }

        return setupModels
    }()

    init(models: [ItemModel],
         form: Form = .oval,
         style: Style = .light,
         fontSize: FontSize = .regular,
         isAnimatable: Bool = true) {
        self.models = models
        self.form = form
        self.style = style
        self.fontSize = fontSize
        self.isAnimatable = isAnimatable
        self.selectedIndex = .init(models.firstIndex(where: { $0.isSelected.value }) ?? 0)
    }
    
    func prepareCornerRadius(for height: CGFloat) -> CGFloat {
        return form == .oval ? height / 2 : 4
    }

    func updateSelectedIndex(to index: Int) {
        selectedIndex.send(index)
    }
}

extension SegmentedControlSetupModel {
    struct ItemModel {
        let imageName: String?
        let title: String
        let isSelected: CurrentValueSubject<Bool, Never>
        
        init(imageName: String? = nil,
             title: String,
             isSelected: CurrentValueSubject<Bool, Never>) {
            self.imageName = imageName
            self.title = title
            self.isSelected = isSelected
        }
    }
    
    enum Form {
        case oval
        case roundedRect
    }
    
    enum Style {
        case dark
        case light
    }

    enum FontSize {
        case regular
        case small
    }
}
