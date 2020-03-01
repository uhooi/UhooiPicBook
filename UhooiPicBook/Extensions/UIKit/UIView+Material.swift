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
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: elevation)
        self.layer.shadowRadius = abs(CGFloat(elevation))
        self.layer.shadowOpacity = 0.24
    }

}
