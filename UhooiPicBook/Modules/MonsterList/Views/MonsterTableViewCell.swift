//
//  MonsterTableViewCell.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import UIKit

final class MonsterTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: View Life-Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: Other Internal Methods

    func setup(icon: UIImage, name: String) {
        self.iconImageView.image = icon
        self.nameLabel.text = name
    }

}
