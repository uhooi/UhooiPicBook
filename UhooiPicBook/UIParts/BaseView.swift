//
//  BaseView.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/01.
//

import UIKit

@IBDesignable
final class BaseView: UIView {

    // MARK: Stored Instance Properties

    @IBInspectable private var cornerRadius: CGFloat = 0.0 {
        willSet {
            layer.cornerRadius = newValue
        }
    }

}
