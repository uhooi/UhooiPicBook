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
        self.presenter.viewDidLoad()
    }

    // MARK: IBActions

    // MARK: Other Private Methods

    private func configureView() {
        self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl) { result in
            switch result {
            case let .success(icon):
                DispatchQueue.main.async {
                    self.iconImageView.image = icon
                }
            case let .failure(error):
                // TODO: エラーハンドリング
                print(error)
            }
        }

        self.nameLabel.text = monster.name
        self.descriptionLabel.text = monster.description
    }

}

extension MonsterDetailViewController: MonsterDetailUserInterface {
}
