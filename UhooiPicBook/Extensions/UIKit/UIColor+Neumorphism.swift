//
//  UIColor+Neumorphism.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/05.
//

import UIKit

protocol NeumorphismColor {
    func lighterColor(value: CGFloat) -> UIColor
    func darkerColor(value: CGFloat) -> UIColor
    func hsbToHsl(h: CGFloat, s: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, l: CGFloat)
    func hslToHsb(h: CGFloat, s: CGFloat, l: CGFloat) -> (h: CGFloat, s: CGFloat, b: CGFloat)
}

extension UIColor: NeumorphismColor {

    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }

    func lighterColor(value: CGFloat) -> UIColor {
        changeLuminance(value: value)
    }

    func darkerColor(value: CGFloat) -> UIColor {
        changeLuminance(value: -value)
    }

    func hsbToHsl(h: CGFloat, s: CGFloat, b: CGFloat) -> (h: CGFloat, s: CGFloat, l: CGFloat) {
        let newH = h
        var newL = (2.0 - s) * b
        var newS = s * b
        newS /= (newL <= 1.0 ? newL : 2.0 - newL)
        newL /= 2.0
        return (h: newH, s: newS, l: newL)
    }

    func hslToHsb(h: CGFloat, s: CGFloat, l: CGFloat) -> (h: CGFloat, s: CGFloat, b: CGFloat) {
        let newH = h
        let ll = l * 2.0
        let ss = s * (ll <= 1.0 ? ll : 2.0 - ll)
        let newB = (ll + ss) / 2.0
        let newS = (2.0 * ss) / (ll + ss)
        return (h: newH, s: newS, b: newB)
    }

    private func changeLuminance(value: CGFloat) -> UIColor {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return self
        }

        let hsl = hsbToHsl(h: h, s: s, b: b)
        let hsb = hslToHsb(h: hsl.h, s: hsl.s, l: hsl.l + value)

        return UIColor(hue: hsb.h, saturation: hsb.s, brightness: hsb.b, alpha: a)
    }

}
