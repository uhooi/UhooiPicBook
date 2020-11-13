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
        }
    }

    // MARK: IBOutlets

    @IBOutlet private weak var baseView: BaseView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel! {
        willSet {
            newValue.text = nil
        }
    }
    
    // MARK: View Life-Cycle Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }

    // MARK: Other Internal Methods

    func setup(name: String, icon: UIImage, elevation: Double) {
        self.nameLabel.text = name
        self.iconImageView.image = icon
        self.baseView.elevate(elevation: elevation)
    }

}
