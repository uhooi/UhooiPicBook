//
//  MonsterCollectionViewCell.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/29.
//

import UIKit

final class MonsterCollectionViewCell: UICollectionViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: Other Internal Methods

    func setup(icon: UIImage, name: String) {
        self.iconImageView.image = icon
        self.nameLabel.text = name
    }

}
