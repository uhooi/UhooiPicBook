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

    @IBInspectable private var masksToBounds: Bool = false {
        willSet {
            self.layer.masksToBounds = newValue
        }
    }

    @IBInspectable private var cornerRadius: CGFloat = 0.0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable private var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        willSet {
            self.layer.shadowOffset = newValue
        }
    }

    @IBInspectable private var shadowRadius: CGFloat = 0.0 {
        willSet {
            self.layer.shadowRadius = newValue
        }
    }

    @IBInspectable private var shadowOpacity: Float = 0.0 {
        willSet {
            self.layer.shadowOpacity = newValue
        }
    }

}
