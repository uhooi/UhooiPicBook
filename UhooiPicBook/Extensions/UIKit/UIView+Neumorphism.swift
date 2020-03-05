//
//  UIView+Neumorphism.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/05.
//

import UIKit

protocol NeumorphismView {
    func addNeumorphismShadow(with parent: UIView, dist: CGFloat, blur: CGFloat)
}

extension UIView: NeumorphismView {

    func addNeumorphismShadow(with parent: UIView, dist: CGFloat = 9.0, blur: CGFloat = 16.0) {
        guard let backgroundColor = self.backgroundColor else {
            return
        }

        let shadowViews = neumorphismShadowViews(color: backgroundColor, dist: dist, blur: blur)
        shadowViews.forEach {
            parent.insertSubview($0, belowSubview: self)
        }
    }

    private func neumorphismShadowViews(color: UIColor, dist: CGFloat, blur: CGFloat) -> [UIView] {
        let lightShadowView: UIView = {
            let lightView = UIView(frame: frame)
            let lightColor = color.lighterColor(value: 0.12)
            lightView.backgroundColor = .white
            lightView.layer.applyShadow(color: lightColor, alpha: 0.5, x: -dist, y: -dist, blur: blur)
            lightView.layer.cornerRadius = layer.cornerRadius
            lightView.layer.maskedCorners = layer.maskedCorners
            return lightView
        }()

        let darkShadowView: UIView = {
            let darkView = UIView(frame: frame)
            let darkColor = color.darkerColor(value: 0.18)
            darkView.backgroundColor = .white
            darkView.layer.applyShadow(color: darkColor, alpha: 0.5, x: dist, y: dist, blur: blur)
            darkView.layer.cornerRadius = layer.cornerRadius
            darkView.layer.maskedCorners = layer.maskedCorners
            return darkView
        }()

        return [lightShadowView, darkShadowView]
    }

}
