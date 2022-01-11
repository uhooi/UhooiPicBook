//
//  UIColor+Hex.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/04/05.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex
        if hex.prefix(1) == "#" {
            hexString = String(hex.suffix(hex.count - 1))
        }
        let v = Int("000000" + hexString, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
