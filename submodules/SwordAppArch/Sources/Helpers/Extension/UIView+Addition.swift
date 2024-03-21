//
//  UIView + Extensions.swift
//  sword-ios
//
//  Created by Scylla IOS on 26.05.22.
//

import UIKit

public struct ViewBorder: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = ViewBorder(rawValue: 1 << 0)
    public static let bottom = ViewBorder(rawValue: 1 << 1)
    public static let leading = ViewBorder(rawValue: 1 << 2)
    public static let trailing = ViewBorder(rawValue: 1 << 3)
    public static let horizontal: ViewBorder = [.leading, .trailing]
    public static let vertical: ViewBorder = [.top, .bottom]
    public static let all: ViewBorder = [.top, .bottom, .leading, .trailing]
}

public extension UIView {
    @discardableResult
    func addBorderConstraints(constraintSides: ViewBorder,
                              by insets: UIEdgeInsets = .zero,
                              shouldRespectSafeArea: Bool = false) -> [ViewBorder: NSLayoutConstraint] {
        var constraits: [ViewBorder: NSLayoutConstraint] = [:]

        guard let superview = superview else { return constraits }

        let guide = superview.safeAreaLayoutGuide

        if constraintSides.contains(.leading) {
            let superViewLeadingAnchor = shouldRespectSafeArea ? guide.leadingAnchor : superview.leadingAnchor
            let leadingConstrait = self.leadingAnchor.constraint(equalTo: superViewLeadingAnchor, constant: insets.left)

            NSLayoutConstraint.activate([leadingConstrait])
            constraits[.leading] = leadingConstrait
        }
        if constraintSides.contains(.trailing) {
            let superViewTrailingAnchor = shouldRespectSafeArea ? guide.trailingAnchor : superview.trailingAnchor
            let trailingConstrait = self.trailingAnchor.constraint(equalTo: superViewTrailingAnchor, constant: insets.right)

            NSLayoutConstraint.activate([trailingConstrait])
            constraits[.trailing] = trailingConstrait
        }
        if constraintSides.contains(.top) {
            let superViewTopAnchor = shouldRespectSafeArea ? guide.topAnchor : superview.topAnchor
            let topConstrait = self.topAnchor.constraint(equalTo: superViewTopAnchor, constant: insets.top)

            NSLayoutConstraint.activate([topConstrait])
            constraits[.top] = topConstrait
        }
        if constraintSides.contains(.bottom) {
            let superViewBottomAnchor = shouldRespectSafeArea ? guide.bottomAnchor : superview.bottomAnchor
            let bottomConstrait = self.bottomAnchor.constraint(equalTo: superViewBottomAnchor, constant: insets.bottom)

            NSLayoutConstraint.activate([bottomConstrait])
            constraits[.bottom] = bottomConstrait
        }

        return constraits
    }
}

// MARK: - Loading from nib

public extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Constants.mainBundle.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
    
    class func loadFromNib(named: String? = nil, bundle: Bundle = Constants.mainBundle) -> Self? {
        let name = named ?? "\(Self.self)"

        guard let nib = bundle.loadNibNamed(name, owner: nil, options: nil),
              let view = nib.first as? Self else {

            return nil
        }

        return view
    }
}

// MARK: - Corner Radius

public extension UIView {
    func setCornerRadius(_ cornerRadius: CGFloat = 6) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    func dropShadow(color: UIColor = .black, opacity: Float = 0.2, offSet: CGSize = .init(width: -1, height: 1), radius: CGFloat = 10, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - Animation

extension UIView {
    func shake(duration: CFTimeInterval = 0.25, repeatCount: Float = 1) {
        let key = "position"
        let animation = CABasicAnimation(keyPath: key)

        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))

        layer.add(animation, forKey: key)
    }
}

extension UIView {
   func createDottedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [2,3]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}

extension UIView {
    func startShimmerAnimation(width: CGFloat? = nil) {
        let gradientLayer = self.addGradientLayer(width: width)
        let animation = addAnimation()
        
        CATransaction.begin()

        gradientLayer.add(animation, forKey: animation.keyPath)

        CATransaction.commit()
    }

    func stopShimmerAnimation() {
        self.layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        }
    }

    private func addGradientLayer(width: CGFloat? = nil) -> CAGradientLayer {
        let gradientColorOne: CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let gradientColorTwo: CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor

        lazy var gradientLayer: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
            gradient.locations = [0.0, 0.5, 1.0]

            return gradient
        }()
        
        let newFrame: CGRect = .init(origin: .zero, size: .init(width: width ?? bounds.width, height: bounds.height))

        gradientLayer.frame = newFrame
        self.layer.addSublayer(gradientLayer)

        return gradientLayer
    }
    
    private func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")

        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 2
        animation.repeatCount = .infinity

        return animation
    }
}
