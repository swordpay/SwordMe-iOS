//
//  GradientedBorderedView.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 06.07.22.
//

import UIKit

public final class GradientedBorderedView: UIView {
    lazy var colors: [CGColor] = [theme.colors.gradientLightGreen.cgColor,
                                  theme.colors.gradientBorderLightBlue.cgColor,
                                  theme.colors.gradientPurple.cgColor] {
        didSet {
            gradientLayer?.colors = colors
            setupGradient()
        }
    }

    var axis: Axis = .horizontal {
        didSet {
            setupGradient()
        }
    }

    var cornerRadiue: CGFloat = 6 {
        didSet {
            setupGradient()
        }
    }
    
    var lineWidth: CGFloat = 2 {
        didSet {
            setupGradient()
        }
    }
    
    var hasBorders: Bool = true {
        didSet {
            setupGradient()
        }
    }

    private var gradientLayer: CAGradientLayer?

    public override func layoutSubviews() {
        super.layoutSubviews()

        setupGradient()
    }

    private func setupBordersGradient() {
        resetGradientLayer()
        setCornerRadius(cornerRadiue)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
        gradientLayer.colors = colors
        gradientLayer.startPoint = prepareStartPoint()
        gradientLayer.endPoint = prepareEndPoint()

        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiue).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shape

        layer.addSublayer(gradientLayer)

        self.gradientLayer = gradientLayer
    }
    
    private func setupBackgroundGradient() {
        resetGradientLayer()
        setCornerRadius(cornerRadiue)

        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = prepareStartPoint()
        gradientLayer.endPoint = prepareEndPoint()

        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }

    private func setupGradient() {
        if hasBorders {
            setupBordersGradient()
        } else {
            setupBackgroundGradient()
        }
    }

    private func prepareStartPoint() -> CGPoint {
        switch axis {
        case .diagonal:
            return CGPoint(x: 0.0, y: 1.0)
        default:
            return .zero
        }
    }

    private func prepareEndPoint() -> CGPoint {
        switch axis {
        case .horizontal:
            return CGPoint(x: 1.0, y: 0.0)
        case .vertical:
            return CGPoint(x: 0.0, y: 1.0)
        case .diagonal:
            return CGPoint(x: 1.0, y: 0.0)
        }
    }
    
    private func resetGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
}

extension GradientedBorderedView {
    enum Axis {
        case horizontal
        case vertical
        case diagonal
    }
}
