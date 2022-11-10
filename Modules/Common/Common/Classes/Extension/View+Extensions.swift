//
//  View+Extensions.swift
//  Common
//
//  Created by kevinguyen261 on 10/11/2022.
//

import UIKit

public extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, bounds: CGRect? = nil) {
        let path = UIBezierPath(roundedRect: bounds ?? self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBottomShadow(ofColor color: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
}
