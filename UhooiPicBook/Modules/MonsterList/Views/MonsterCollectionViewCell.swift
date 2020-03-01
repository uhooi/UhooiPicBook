//
//  MonsterCollectionViewCell.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/29.
//

import UIKit

final class MonsterCollectionViewCell: UICollectionViewCell {

    // MARK: Stored Instance Properties

    @IBInspectable private var masksToBounds: Bool = false {
        willSet {
            self.layer.masksToBounds = newValue
            //            self.contentView.layer.masksToBounds = newValue
        }
    }

    @IBInspectable private var cornerRadius: CGFloat = 0.0 {
        willSet {
            self.layer.cornerRadius = newValue
            //            self.contentView.layer.cornerRadius = newValue
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

    // MARK: IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: Other Internal Methods

    func setup(icon: UIImage, name: String) {
        self.iconImageView.image = icon
        self.nameLabel.text = name
    }

}
