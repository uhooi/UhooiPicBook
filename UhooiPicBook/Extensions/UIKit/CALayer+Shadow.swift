//
//  CALayer+Shadow.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/05.
//

import UIKit

protocol ShadowCALayer {
    func applyShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat)
}

extension CALayer {

    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0.0, y: CGFloat = 2.0, blur: CGFloat = 4.0, spread: CGFloat = 0.0) {
        self.shadowColor = color.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2.0
        if spread == 0.0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = self.bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        self.masksToBounds = false
    }

}
