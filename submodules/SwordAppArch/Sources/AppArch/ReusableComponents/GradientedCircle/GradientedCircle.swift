//
//  GradientedCircle.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 30.06.22.
//

import UIKit

final class GradientArcView: UIView {
    private var startColor: UIColor
    private var endColor:   UIColor
    private var lineWidth:  CGFloat
    private var endPossition: EndPossition
    private var shouldAnimate: Bool

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        return gradientLayer
    }()
    
    init(frame: CGRect, startColor: UIColor, endColor: UIColor, endPossition: EndPossition, lineWidth: CGFloat, animated: Bool = false) {
        self.startColor = startColor
        self.endColor = endColor
        self.lineWidth = lineWidth
        self.endPossition = endPossition
        self.shouldAnimate = animated

        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.startColor = ThemeProvider.currentTheme.colors.gradientLightBlue
        self.endColor = ThemeProvider.currentTheme.colors.gradientDarkBlue
        self.lineWidth = 0
        self.endPossition = .whole
        self.shouldAnimate = false

        super.init(coder: aDecoder)

        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradient()
    }
}
private extension GradientArcView {
    func configure() {
        layer.addSublayer(gradientLayer)
    }
    
    func updateGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor, endColor].map { $0.cgColor }
        let start: CGFloat = -.pi / 2
        let end: CGFloat = endPossition.angle
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        let mask = CAShapeLayer()

        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = lineWidth
        mask.path = path.cgPath
        mask.lineCap = .round
        
        gradientLayer.mask = mask
        
        if shouldAnimate {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.autoreverses = false
            animation.repeatCount = 1
            mask.add(animation, forKey: "line")
        }
    }
}

extension GradientArcView {
    enum EndPossition {
        case quarter
        case third
        case half
        case twoAndThird
        case threeAndQuarter
        case threeAndHalf
        case whole
        
        var angle: CGFloat {
            switch self {
            case .third:
                return .pi / 6 + .pi
            case .quarter:
                return .pi
            case .half:
                return .pi / 2
            case .twoAndThird:
                return 2 * .pi / 3
            case .threeAndQuarter:
                return 3 * .pi / 4
            case .threeAndHalf:
                return .pi / 3
            case .whole:
                return  -5 * .pi / 2
            }
        }
    }
}
