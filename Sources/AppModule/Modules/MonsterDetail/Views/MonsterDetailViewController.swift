//
//  MonsterDetailViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import ImageLoader

/// @mockable
@MainActor
protocol MonsterDetailUserInterface: AnyObject {
}

@MainActor
public final class MonsterDetailViewController: UIViewController {

    // MARK: Stored Instance Properties

    private var presenter: MonsterDetailEventHandler!

    private var monster: MonsterItem!

    // MARK: IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView! {
        willSet {
            newValue.image = nil
        }
    }
    @IBOutlet private weak var dancingImageView: UIImageView! {
        willSet {
            newValue.image = nil
            newValue.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDancingImageView(_:))))
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        willSet {
            newValue.text = nil
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        willSet {
            newValue.text = nil
        }
    }

    // MARK: View Life-Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        presenter.viewDidLoad()
    }

    // MARK: IBActions

    @IBAction private func didTapShareButton(_ sender: UIBarButtonItem) {
        presenter.didTapShareButton(
            sender.value(forKey: "view") as? UIView,
            name: nameLabel.text,
            description: descriptionLabel.text,
            icon: iconImageView.image
        )
    }

    // MARK: Other Internal Methods

    func inject(
        presenter: MonsterDetailEventHandler,
        monster: MonsterItem
    ) {
        self.presenter = presenter
        self.monster = monster
    }

    // MARK: Other Private Methods

    @objc
    private func didTapDancingImageView(_ sender: UITapGestureRecognizer) {
        presenter.didTapDancingImageView(dancingImage: dancingImageView.image)
    }

    private func configureView() {
        Task {
            await iconImageView.loadImage(with: monster.iconURL)
        }
        nameLabel.text = monster.name
        descriptionLabel.text = monster.description
        navigationController?.navigationBar.configureBackgroundColor(UIColor(hex: monster.baseColorCode))
        dancingImageView.loadGIFImage(with: monster.dancingURL)
    }
}

extension MonsterDetailViewController: MonsterDetailUserInterface {
}
