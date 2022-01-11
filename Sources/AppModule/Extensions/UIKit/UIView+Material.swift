//
//  UIView+Material.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/01.
//

import UIKit

protocol MaterialView {
    func elevate(elevation: Double)
}

extension UIView: MaterialView {
    func elevate(elevation: Double) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: elevation)
        layer.shadowRadius = abs(CGFloat(elevation))
        layer.shadowOpacity = 0.24
    }
}
