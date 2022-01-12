//
//  CodableColor.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import UIKit.UIColor

struct CodableColor {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }

    func uiColor() -> UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension CodableColor: Codable {}
