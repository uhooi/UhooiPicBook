//
//  MonsterDetailViewController.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
protocol MonsterDetailUserInterface: AnyObject {
}

final class MonsterDetailViewController: UIViewController {

    // MARK: Type Aliases

    // MARK: Stored Instance Properties

    var presenter: MonsterDetailEventHandler!
    var imageCacheManager: ImageCacheManagerProtocol!

    var monster: MonsterEntity!

    // MARK: Computed Instance Properties

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

    override func viewDidLoad() {
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

    // MARK: Other Private Methods

    @objc
    private func didTapDancingImageView(_ sender: UITapGestureRecognizer) {
        presenter.didTapDancingImageView(dancingImage: dancingImageView.image)
    }

    private func configureView() {
        self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl) { [weak self] result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    self?.iconImageView.image = icon
                }
            case let .failure(error):
                // TODO: エラーハンドリング
                print(error)
            }
        }
        dancingImageView.image = imageCacheManager.cacheGIFImage(imageUrl: monster.dancingUrl)
        nameLabel.text = monster.name
        descriptionLabel.text = monster.description
        navigationController?.navigationBar.configureBackgroundColor(.init(hex: monster.baseColorCode))
    }

}

extension MonsterDetailViewController: MonsterDetailUserInterface {
}
