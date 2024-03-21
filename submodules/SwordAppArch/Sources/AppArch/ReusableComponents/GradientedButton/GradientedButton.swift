//
//  GradientedButton.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 27.06.22.
//

import UIKit
import Combine

public final class GradientedButton: UIButton, Setupable {
    public typealias SetupModel = GradientedButtonModel

    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []
    private var model: GradientedButtonModel!
    private var gradientLayer: CAGradientLayer?
    private var cornerRadius: CGFloat {
        return frame.height / 2
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        updateButtonState(isActive: model.isActive.value)
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupTitleColor()
    }

    public func setup(with model: GradientedButtonModel) {
        self.model = model

        setTitle(model.title, for: .normal)
        
        let fontSize: CGFloat = UIScreen.hasSmallScreen ? 20 : 24
        titleLabel?.font = model.font ?? theme.fonts.semibold(ofSize: fontSize,
                                                              family: .poppins)
        addTarget(self, action: #selector(touchUpHandler), for: .touchUpInside)

        bindToIsActive()
    }

    private func setupTitleColor() {
        lazy var colors = model.gradientColors
        let color: UIColor
        
        if model.hasBorders {
            switch model.style {
            case .default:
                color = theme.colors.gradientDarkBlue
            case .light:
                color = theme.colors.gradientDarkBlue
            case .destructive:
                color = theme.colors.mainRed
            }
        } else {
            color = model.style == .light ? theme.colors.gradientDarkBlue : theme.colors.mainWhite
        }
        
        setTitleColor(color, for: .normal)
    }

    private func updateButtonState(isActive: Bool) {
        if isActive {
            setupGradient()
            //TODO: Pay attention, maybe there is better solution
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        } else {
            setupBackgroundGradient(isActive: false)
            setTitleColor(theme.colors.mainGray4, for: .normal)
        }
    }

    // MARK: - Binding

    private func bindToIsActive() {
        model.isActive
            .sink { [ weak self ] isActive in
                guard let self else { return }
                
                self.isUserInteractionEnabled = isActive

                self.updateButtonState(isActive: isActive)
            }
            .store(in: &cancellables)
    }

    // MARK: - Gradient

    private func setupGradient() {
        if model.hasBorders {
            setupBordersGradient()
        } else {
            setupBackgroundGradient()
        }
    }

    private func setupBordersGradient() {
        resetGradientLayer()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = model.gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        let shape = CAShapeLayer()
        shape.lineWidth = 3
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shape.strokeColor = model.gradientColors.first?.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shape

        layer.addSublayer(gradientLayer)
        
        if model.style == .light {
            backgroundColor = theme.colors.gradientDarkBlue
        }

        self.gradientLayer = gradientLayer
    }

    private func setupBackgroundGradient(isActive: Bool = true) {
        resetGradientLayer()

        let colors = isActive ? model.gradientColors.map { $0.cgColor }
                              : [theme.colors.inactiveGradientedButtonDarkGray.cgColor,
                                 theme.colors.inactiveGradientedButtonLightGray.cgColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }

    private func resetGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }

    // MARK: - Handlers

    @objc
    private func touchUpHandler() {
        model.action()
    }
}
